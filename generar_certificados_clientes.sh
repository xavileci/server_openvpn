#!/bin/sh
if [ $# -ne 1 ]
then
    echo "Se esperaba un nombre de uaurio como argumento"
    exit 1
fi
nombre=$1
STORE_FOLDER="${HOME}/certificados_vpn/"
TMP_DIR="${STORE_FOLDER}/tmp/${nombre}"
IP="$(curl ifconfig.me)"
PORT="$(grep "^port" /etc/openvpn/server/server.conf |awk '{print $NF}')"

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
mkdir -p ${TMP_DIR}
cp -axp /etc/openvpn/keys/ta.key ${TMP_DIR}
cp -axp /etc/openvpn/easy-rsa/pki/issued/${nombre}.crt ${TMP_DIR}
cp -axp /etc/openvpn/easy-rsa/pki/private/${nombre}.key ${TMP_DIR}
cp -axp /etc/openvpn/keys/ca.crt ${TMP_DIR}

cp -axp /usr/share/doc/openvpn-2.4.10/sample/sample-config-files/client_template.conf ${TMP_DIR}/${nombre}.ovpn &&\
sed -i "s/%IP%/${IP}/" ${TMP_DIR}/${nombre}.ovpn
sed -i "s/%PORT%/${PORT}/" ${TMP_DIR}/${nombre}.ovpn
sed -i "s/%USER%/${nombre}/" ${TMP_DIR}/${nombre}.ovpn

chmod 600 ${TMP_DIR}/*
cd ${TMP_DIR}/..
tar czf ${STORE_FOLDER}/${nombre}.tgz ${nombre}
if [[ $? != 0 ]]
then 
    exit 1
fi
rm -rf ${TMP_DIR}

exit $?
