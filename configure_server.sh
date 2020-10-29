#!/bin/bash

mkdir -p /etc/openvpn/easy-rsa/
mkdir -p /var/log/openvpn/

echo "CONFIGURE VPN SERVER"
cp -rf /usr/share/easy-rsa/3.0.8/* /etc/openvpn/easy-rsa/

cd /etc/openvpn/easy-rsa
./easyrsa init-pki

echo "Generamos la CA (nos ha obligado a ponerle contraseña, nopass sin):"
./easyrsa build-ca

echo "Creamos el parámetro Diffie-Hellman:"
./easyrsa gen-dh

echo "Generamos el certificado del servidor:"
./easyrsa gen-req vpn.frasquetarquitectos.com nopass

echo "Generamos el cifrado TLS:"
openvpn --genkey --secret /etc/openvpn/keys/ta.key

mkdir /etc/openvpn/keys/
chmod 750 /etc/openvpn/keys
cp -axp /etc/openvpn/easy-rsa/pki/ca.crt /etc/openvpn/keys/
cp -axp /etc/openvpn/easy-rsa/pki/dh.pem /etc/openvpn/keys/
cp -axp /etc/openvpn/easy-rsa/pki/issued/vpn.frasquetarquitectos.com.crt /etc/openvpn/keys/
cp -axp /etc/openvpn/easy-rsa/pki/private/vpn.frasquetarquitectos.com.key /etc/openvpn/keys/

cp -axp /usr/share/doc/openvpn/sample/sample-config-files/server.conf /etc/openvpn/server.conf
sed -i '/^ca/ ca \/etc\/openvpn\/keys\/ca.crt' /etc/openvpn/server.conf
sed -i '/^cert/ cert \/etc\/openvpn\/keys\/devops.crt' /etc/openvpn/server.conf
sed -i '/^key/ key \/etc\/openvpn\/keys\/devops.key' /etc/openvpn/server.conf
sed -i '/^dh/ dh \/etc\/openvpn\/keys\/dh.pem' /etc/openvpn/server.conf
sed -i '/^tls-auth/  tls-auth /etc/openvpn/keys/ta.key 0' /etc/openvpn/server.conf
sed -i '/^status/  status /var/log/openvpn/openvpn-status.log' /etc/openvpn/server.conf

