#!/bin/sh
nombre=$1

echo "....GENERANDO CLAVE PRIVADA...."
cd /etc/openvpn/easy-rsa/

./easyrsa gen-req ${nombre} nopass
if [ $? != 0 ]]
then 
    exit 1
fi 

echo "....GENERANDO CLAVE PRUBLICA...."
./easyrsa sign client ${nombre}
if [ $? != 0 ]]
then 
    exit 1
fi 

echo "....GENERANDO PAQUETE DE USUARIO...."
mkdir -p /tmp/${nombre}
cp -axp /etc/openvpn/keys/ta.key /tmp/${nombre}
cp -axp /etc/openvpn/easy-rsa/pki/issued/${nombre}.crt /tmp/${nombre}
cp -axp /etc/openvpn/easy-rsa/pki/private/${nombre}.key /tmp/${nombre}
cp -axp /etc/openvpn/keys/ca.crt /tmp/${nombre}

chmod 600 /tmp/${nombre}/*
cd /tmp
tar czf /mnt/clientes_vpn/${nombre}.tgz ${nombre}
if [ $? != 0 ]]
then 
    exit 1
fi
rm -rf /tmp/${nombre}

exit $?

