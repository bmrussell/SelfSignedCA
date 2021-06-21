#!/usr/bin/env bash

read -p "Organisation : " CERT_ORG
read -p "City         : " CERT_CITY
read -p "Province     : " CERT_PROVINCE
read -p "Country      : " CERT_COUNTRY

[ ! -d "CA" ] && mkdir -p "CA"
[ ! -d "CA/${CERT_ORG}" ] && mkdir -p "CA/${CERT_ORG}"

echo "Generating Private Key"
echo "----------------------"
openssl genrsa -des3 -out "CA/${CERT_ORG}/${CERT_ORG}.key" 2048
echo
echo "Generating Root Certificate"
echo "---------------------------"
openssl req -x509 -new -nodes -key "CA/${CERT_ORG}/${CERT_ORG}.key" -subj "/CN=${CERT_ORG}/O=${CERT_ORG}/L=${CERT_CITY}/ST=${CERT_PROVINCE}/C=${CERT_COUNTRY}" -days 1825 -keyout "CA/$CERT_ORG/$CERT_ORG.key" -out "CA/$CERT_ORG/$CERT_ORG.pem"

# Copy the openssl config that was used to the CA folder
OSSLCNF="$(openssl version -a | grep OPENSSLDIR | awk -F '"' '{print $2}')/openssl.cnf"
cp $OSSLCNF "CA/${CERT_ORG}/"

# Make a shell script for the CA default environment
echo "#!/usr/bin/env bash" > "CA/${CERT_ORG}/env.sh"
echo "export CERT_ORG=${CERT_ORG}" >> "CA/${CERT_ORG}/env.sh"
echo "export CERT_CITY=${CERT_CITY}" >> "CA/${CERT_ORG}/env.sh"
echo "export CERT_PROVINCE=${CERT_PROVINCE}" >> "CA/${CERT_ORG}/env.sh"
echo "export CERT_COUNTRY=${CERT_COUNTRY}" >> "CA/${CERT_ORG}/env.sh"