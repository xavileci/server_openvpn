#!/bin/sh
nombre=$1
ip=170.253.50.199
port=1994

echo "....GENERANDO CLAVE PRIVADA...."
cd /etc/openvpn/easy-rsa/

./easyrsa gen-req ${nombre} nopass
if [[ $? != 0 ]]
then 
    exit 1
fi 

echo "....GENERANDO CLAVE PRUBLICA...."
./easyrsa sign client ${nombre}
if [[ $? != 0 ]]
then 
    exit 1
fi 

echo "....GENERANDO PAQUETE DE USUARIO...."
mkdir -p /tmp/${nombre} &&\
cp -axp /etc/openvpn/keys/ta.key /tmp/${nombre} &&\
cp -axp /etc/openvpn/easy-rsa/pki/issued/${nombre}.crt /tmp/${nombre} &&\
cp -axp /etc/openvpn/easy-rsa/pki/private/${nombre}.key /tmp/${nombre} &&\
cp -axp /etc/openvpn/keys/ca.crt /tmp/${nombre} &&\

cp -axp sample/sample-config-files/client_frasquetarquitectos.conf /tmp/${nombre}/${nombre}.ovpn &&\
sed -i "s/%IP%/${ip}/" /tmp/${nombre}/${nombre}.ovpn
sed -i "s/%PORT%/${port}/" /tmp/${nombre}/${nombre}.ovpn
sed -i "s/%USER%/${nombre}/" /tmp/${nombre}/${nombre}.ovpn

chmod 600 /tmp/${nombre}/*
cd /tmp
tar czf /mnt/certificados_clientes/${nombre}.tgz ${nombre}
if [[ $? != 0 ]]
then 
    exit 1
fi
rm -rf /tmp/${nombre}

exit $?

