# Self Signed CA

Bash scripts to make certificates with a self signed CA using OpenSSL.

Key usage is `Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment`

## new-ca.sh
### Description
Creates a new cerificate authority with name *name* under `CA/name`
#### Example Usage
```
$./new-ca.sh
Organisation : Skywalkers
City         : Moisture Farm
Province     : Toche Station
Country      : TA
Generating Private Key
----------------------
Generating RSA private key, 2048 bit long modulus (2 primes)
............................................................................................................+++++
................................................................+++++
e is 65537 (0x010001)
Enter pass phrase for CA/Skywalkers/Skywalkers.key:
Verifying - Enter pass phrase for CA/Skywalkers/Skywalkers.key:

Generating Root Certificate
---------------------------
Enter pass phrase for CA/Skywalkers/Skywalkers.key:
```

## https-cert.sh

#### Description
Creates a new server certificate cerificate authority with name *name* under `CA/name`

#### Example Usage
```
./https-cert.sh Skywalkers www.thefarm.com www.moisturenow.com 192.168.1.66
1: www.moisturenow.com
3: 3/DNS.1 = www.thefarm.com
DNS.2 = www.moisturenow.com
1: 192.168.1.66
2: 2/
IP.1 = 192.168.1.66
Email for certificate : owen@skywalkers.com
Creating certificate for
DNS.1 = www.thefarm.com DNS.2 = www.moisturenow.com
and
IP.1 = 192.168.1.66
with
===========================
TA.
Toche.
Moisture.
Skywalkers.
owen@skywalkers.com.
===========================
Press any key to continue . . .

Creating certificate signing request CA/Skywalkers/www.thefarm.com/www.thefarm.com.csr...


Creating CA/Skywalkers/www.thefarm.com/www.thefarm.com.ext...


Creating certificate at CA/Skywalkers/www.thefarm.com/www.thefarm.com.pem and CA/Skywalkers/www.thefarm.com/www.thefarm.com.key...
Signature ok
subject=C = TA, ST = Toche, L = Moisture, O = Skywalkers, CN = www.thefarm.com, emailAddress = owen@skywalkers.com
Getting CA Private Key
Enter pass phrase for CA/Skywalkers/Skywalkers.key:


Converting to PFX for Windows CA/Skywalkers/www.thefarm.com/www.thefarm.com.pem...
Enter Export Password:
Verifying - Enter Export Password:
Done.
```


### Example Certs Generated
#### CA Cert
```
openssl x509 -noout -text -in CA/Skywalkers/Skywalkers.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            5b:87:fd:17:58:01:c0:fa:a8:0c:08:43:11:3a:ab:b9:8c:73:49:16
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = Skywalkers, O = Skywalkers, L = Moisture Farm, ST = Toche Station, C = TA
        Validity
            Not Before: Jun 21 17:03:22 2021 GMT
            Not After : Jun 20 17:03:22 2026 GMT
        Subject: CN = Skywalkers, O = Skywalkers, L = Moisture Farm, ST = Toche Station, C = TA
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:d4:c7:76:6b:70:e1:c9:74:93:18:ab:90:20:97:
...
                    9c:e3:af:9e:cb:dd:e9:12:9e:28:84:c0:7c:3a:87:
                    17:33
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                7D:19:27:29:D4:C4:5C:CE:06:B6:E7:10:63:B0:5C:59:FE:9B:53:8B
            X509v3 Authority Key Identifier:
                keyid:7D:19:27:29:D4:C4:5C:CE:06:B6:E7:10:63:B0:5C:59:FE:9B:53:8B

            X509v3 Basic Constraints: critical
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
         b8:e9:03:7b:a2:0f:41:63:ac:df:24:aa:7a:a4:40:2e:2b:4e:
...
         17:fb:dd:6e
```

#### Server Cert
```
openssl x509 -noout -text -in CA/Skywalkers/www.thefarm.com/www.thefarm.com.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            70:f3:99:a0:32:71:9d:6a:2e:06:59:ce:a9:eb:65:c6:46:a2:3a:75
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = Skywalkers, O = Skywalkers, L = Moisture Farm, ST = Toche Station, C = TA
        Validity
            Not Before: Jun 21 17:05:22 2021 GMT
            Not After : Jun 20 17:05:22 2026 GMT
        Subject: C = TA, ST = Toche, L = Moisture, O = Skywalkers, CN = www.thefarm.com, emailAddress = owen@skywalkers.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:d4:c5:e7:32:96:60:ad:17:fd:b6:66:4e:b2:8d:
...
                    e2:31
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Authority Key Identifier:
                keyid:7D:19:27:29:D4:C4:5C:CE:06:B6:E7:10:63:B0:5C:59:FE:9B:53:8B

            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Key Usage:
                Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment
            X509v3 Subject Alternative Name:
                DNS:www.thefarm.com, DNS:www.moisturenow.com, IP Address:192.168.1.66
    Signature Algorithm: sha256WithRSAEncryption
         a3:57:4d:3c:1f:24:32:44:50:3a:ae:78:24:e9:8d:34:fa:e0:
...
         ca:32:16:64
```