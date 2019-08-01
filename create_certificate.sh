#!/bin/bash

mkdir -p certs

read -p "Country Name (2 letter code. eg, BR ): " CN
read -p "State or Province Name (full name): " ST
read -p "Locality Name (eg, city): " LN
read -p "Organization Name (eg, company): " ORG
read -p "Organizational Unit Name (eg, IT): " OU
read -p "Common Name (e.g. server FQDN or YOUR domain): " CMN

echo $CN

CONF=`mktemp`
(
cat <<EOF 
[ req ]
distinguished_name="req_distinguished_name"
prompt="no"

[ req_distinguished_name ]
C   =   "${CN}"
ST  =   "${ST}"
L   =   "${LN}"
O   =   "$ORG"
OU  =   "$OU"
CN  =   "$CMN"

EOF
) > $CONF

clear

openssl genrsa 2048 > certs/privatekey.pem

openssl req -new -key certs/privatekey.pem -out certs/csr.pem -config $CONF

openssl x509 -req -days 365 -in certs/csr.pem -signkey certs/privatekey.pem -out certs/server.crt

echo -e "\n====:: Certificate - server.crt - :: ==== \n\n"
cat certs/server.crt
echo -e "\n\n" 

echo -e "====:: Certificate - privatekey.pem - :: ==== \n\n"
cat certs/privatekey.pem
echo -e "\n\n"