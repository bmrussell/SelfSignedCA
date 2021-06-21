#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo 'createcert <CA Name> <dns name> [ip address|domain]...'
    echo 'Creates certificate with DNS name, external DNS name and optional IP address'
    exit
fi

CA="${1}"
domain="${2}"
ipcount=1
ipstring=""
NEWLINE=$'\n'
dnsstring="DNS.1 = ${domain}"
dnscount=2

for arg in "$@"
do
	if [ "$arg" != "$domain" ] && [ "$arg" != "$CA" ]; then
        echo "1: ${arg}"
		if [[ $arg =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
			ipstring="${ipstring}${NEWLINE}IP.${ipcount} = ${arg}"
			((ipcount=ipcount+1))
            echo "2: ${ipcount}/${ipstring}"
		else
			dnsstring="${dnsstring}${NEWLINE}DNS.${dnscount} = ${arg}"
			((dnscount=dnscount+1))
            echo "3: ${dnscount}/${dnsstring}"
		fi
	fi
done


read -p "Email for certificate : " CERT_EMAIL
source "./CA/${CA}/env.sh"

echo Creating certificate for 
echo ${dnsstring}
echo and
echo ${ipstring} 
echo with
echo "==========================="
echo "${CERT_COUNTRY}."
echo "${CERT_PROVINCE}."
echo "${CERT_CITY}."
echo "${CERT_ORG}."
echo "${CERT_EMAIL}."
echo "==========================="

read -s -n 1 -p "Press any key to continue . . ."

# Create a subfolder for the certs

DOMAIN_FOLDER="CA/${CERT_ORG}/${domain}"

[ ! -d "${DOMAIN_FOLDER}" ] && mkdir -p "${DOMAIN_FOLDER}"

# Create a private key
openssl genrsa -out "${DOMAIN_FOLDER}/${domain}.key" 2048 > /dev/null 2>&1

# Create a signing request (CSR)
echo -e '\n'
echo Creating certificate signing request "${DOMAIN_FOLDER}/${domain}.csr"...
csr="${CERT_COUNTRY}${NEWLINE}${CERT_PROVINCE}${NEWLINE}${CERT_CITY}${NEWLINE}${CERT_ORG}${NEWLINE}${NEWLINE}${domain}${NEWLINE}${CERT_EMAIL}${NEWLINE}${NEWLINE}"
echo "$csr" | openssl req -new -key "${DOMAIN_FOLDER}/${domain}.key" -out "${DOMAIN_FOLDER}/${domain}.csr"  > /dev/null 2>&1

# Create config for Subject Alternate Name(s) (SAN)
echo -e '\n'
echo Creating "${DOMAIN_FOLDER}/${domain}.ext"...
ext="authorityKeyIdentifier=keyid,issuer${NEWLINE}basicConstraints=CA:FALSE${NEWLINE}keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment${NEWLINE}subjectAltName = @alt_names${NEWLINE}${NEWLINE}[alt_names]${NEWLINE}${dnsstring}${ipstring}${NEWLINE}"
echo "$ext" > "${DOMAIN_FOLDER}/${domain}.ext"

# Create Certificate
echo -e '\n'
echo Creating certificate at "${DOMAIN_FOLDER}/${domain}.pem" and "${DOMAIN_FOLDER}/${domain}.key"...
openssl x509 -req -in "${DOMAIN_FOLDER}/${domain}.csr" -CA "CA/${CERT_ORG}/${CERT_ORG}.pem" -CAkey "CA/${CERT_ORG}/${CERT_ORG}.key" -CAcreateserial -out "${DOMAIN_FOLDER}/${domain}.pem" -days 1825 -sha256 -extfile "${DOMAIN_FOLDER}/${domain}.ext"

# Convert for Windows just in case
echo -e '\n'
echo Converting to PFX for Windows "${DOMAIN_FOLDER}/${domain}.pem"...
openssl pkcs12 -export -out "${DOMAIN_FOLDER}/${domain}.pfx" -inkey "${DOMAIN_FOLDER}/${domain}.key" -in "${DOMAIN_FOLDER}/${domain}.pem"

echo Done.






