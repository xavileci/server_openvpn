# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"
  config.vm.hostname = "openvpncentos7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.99.5"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "/mnt/c/certificado_vpn/", "/mnt/certificados_clientes"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "512"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-SHELL
     echo "INSTALL SOFTWARE"
     yum install -y epel-release
     yum check-update
     yum install -y vim-minimal.x86_64 net-tools 
     yum install -y kernel-devel kernel-headers
     yum install -y dkms binutils gcc make patch libgomp glibc-headers glibc-devel
     yum update -y 
     yum install -y openvpn easy-rsa
     mkdir -p /etc/openvpn/easy-rsa/

#     echo "CONFIGURE VPN SERVER"
#     cp -rf /usr/share/easy-rsa/3.0.8/* /etc/openvpn/easy-rsa/
#
#     cd /etc/openvpn/easy-rsa
#     ./easyrsa init-pki
# 
#     echo "Generamos la CA (nos ha obligado a ponerle contraseña, nopass sin):"
#     ./easyrsa build-ca
#
#     echo "Creamos el parámetro Diffie-Hellman:"
#     ./easyrsa gen-dh
#
#     echo "Generamos el certificado del servidor:"
#     ./easyrsa gen-req vpn.frasquetarquitectos.com nopass
#
#     echo "Generamos el cifrado TLS:"
#     openvpn --genkey --secret /etc/openvpn/keys/ta.key
#
#     mkdir /etc/openvpn/keys/
#     chmod 750 /etc/openvpn/keys
#     cp -axp /etc/openvpn/easy-rsa/pki/ca.crt /etc/openvpn/keys/
#     cp -axp /etc/openvpn/easy-rsa/pki/dh.pem /etc/openvpn/keys/
#     cp -axp /etc/openvpn/easy-rsa/pki/issued/vpn.frasquetarquitectos.com.crt /etc/openvpn/keys/
#     cp -axp /etc/openvpn/easy-rsa/pki/private/vpn.frasquetarquitectos.com.key /etc/openvpn/keys/
#
#     cp -axp /usr/share/doc/openvpn/sample/sample-config-files/server.conf /etc/openvpn/server.conf
#     sed -i '/^ca/ ca \/etc\/openvpn\/keys\/ca.crt' /etc/openvpn/server.conf
#     sed -i '/^cert/ cert \/etc\/openvpn\/keys\/devops.crt' /etc/openvpn/server.conf
#     sed -i '/^key/ key \/etc\/openvpn\/keys\/devops.key' /etc/openvpn/server.conf
#     sed -i '/^dh/ dh \/etc\/openvpn\/keys\/dh.pem' /etc/openvpn/server.conf
#     sed -i '/^tls-auth/  tls-auth /etc/openvpn/keys/ta.key 0' /etc/openvpn/server.conf
#     sed -i '/^status/  status /var/log/openvpn/openvpn-status.log' /etc/openvpn/server.conf

     mkdir -p /var/log/openvpn/
     touch /var/log/openvpn/openvpn-status.log
     echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

     reboot
   SHELL
end
