#!/bin/bash

set -e

echo "=== Actualizando sistema ==="
sudo apt-get update && sudo apt-get upgrade -y

echo "=== Instalando dependencias de compilación ==="
sudo apt-get install -y \
   git autoconf automake libtool make libreadline-dev texinfo \
   pkg-config libpam0g-dev libjson-c-dev bison flex python3-pytest \
   libc-ares-dev python3-dev libsystemd-dev python-ipaddress python3-sphinx \
   install-info build-essential libsnmp-dev perl libcap-dev \
   libpcre3-dev libelf-dev libpcre2-dev cmake libssh-dev protobuf-c-compiler \
   libprotobuf-c-dev libzmq5 libzmq3-dev

###############################################
# LIMPIEZA DE RTRLIB ANTERIOR (OBLIGATORIO)
###############################################
echo "=== Eliminando instalaciones antiguas de rtrlib ==="
sudo rm -rf /usr/local/include/rtrlib
sudo rm -rf /usr/include/rtrlib
sudo rm -f /usr/local/lib/librtr*
sudo rm -f /usr/lib/librtr*
sudo rm -f /usr/local/lib/pkgconfig/rtrlib.pc
sudo rm -f /usr/lib/pkgconfig/rtrlib.pc
sudo ldconfig

###############################################
# LIBYANG
###############################################
echo "=== Instalando libyang ==="
cd /tmp
rm -rf libyang
git clone https://github.com/CESNET/libyang.git
cd libyang
git checkout v2.1.128
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
sudo make install

###############################################
# RTRLIB (CORREGIDA CON ASPA)
###############################################
echo "=== Instalando rtrlib con ASPA ==="
cd /tmp
rm -rf rtrlib
git clone https://github.com/rtrlib/rtrlib
cd rtrlib
mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_RTR=ON \
      -DENABLE_ASPA=ON \
      -DCMAKE_INSTALL_PREFIX=/usr ..

make -j$(nproc)
sudo make install
sudo ldconfig

echo "=== Verificando rtrlib instalada ==="
ls -l /usr/include/rtrlib || (echo "ERROR: rtrlib no se instaló correctamente" && exit 1)
ls -l /usr/lib/librtr* || (echo "ERROR: librtr no está presente" && exit 1)
ls -l /usr/lib/pkgconfig/rtrlib.pc || (echo "ERROR: rtrlib.pc no existe" && exit 1)

###############################################
# FRRouting
###############################################
echo "=== Instalando FRRouting ==="
sudo groupadd -r -g 92 frr || true
sudo groupadd -r -g 85 frrvty || true
sudo adduser --system --ingroup frr --home /var/run/frr/ \
   --gecos "FRR suite" --shell /sbin/nologin frr || true
sudo usermod -a -G frrvty frr || true

cd /tmp
rm -rf frr
git clone https://github.com/frrouting/frr.git
cd frr

./bootstrap.sh

echo "=== Ejecutando configure con PKG_CONFIG_PATH correcto ==="

PKG_CONFIG_PATH=/usr/lib/pkgconfig ./configure \
    --prefix=/usr \
    --includedir=/usr/include \
    --enable-exampledir=/usr/share/doc/frr/examples \
    --bindir=/usr/bin \
    --sbindir=/usr/lib/frr \
    --libdir=/usr/lib/frr \
    --libexecdir=/usr/lib/frr \
    --localstatedir=/var/run/frr \
    --sysconfdir=/etc/frr \
    --with-moduledir=/usr/lib/frr/modules \
    --with-libyang-pluginsdir=/usr/lib/frr/libyang_plugins \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-snmp=agentx \
    --enable-multipath=64 \
    --enable-user=frr \
    --enable-group=frr \
    --enable-vty-group=frrvty \
    --enable-systemd=yes \
    --enable-rpki=yes \
    --with-pkg-git-version \
    --with-pkg-extra-version=-custom

echo "=== Compilando FRR ==="
make -j$(nproc)
sudo make install

###############################################
# INSTALACIÓN DE ARCHIVOS DE CONFIG
###############################################
echo "=== Instalando archivos de configuración ==="
sudo install -m 775 -o frr -g frr -d /var/log/frr
sudo install -m 775 -o frr -g frrvty -d /etc/frr
sudo install -m 640 -o frr -g frrvty tools/etc/frr/vtysh.conf /etc/frr/vtysh.conf
sudo install -m 640 -o frr -g frr tools/etc/frr/frr.conf /etc/frr/frr.conf
sudo install -m 640 -o frr -g frr tools/etc/frr/daemons.conf /etc/frr/daemons.conf
sudo install -m 640 -o frr -g frr tools/etc/frr/daemons /etc/frr/daemons

###############################################
# SERVICE FILE
###############################################
echo "=== Instalando servicio systemd ==="
sudo install -m 644 tools/frr.service /etc/systemd/system/frr.service
sudo systemctl daemon-reload
sudo systemctl enable frr

###############################################
# SYSCTL
###############################################
echo "=== Configurando sysctl ==="
sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf
sudo sed -i "s/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/" /etc/sysctl.conf

###############################################
# HABILITAR BGP + RPKI
###############################################
echo "=== Habilitando bgpd con RPKI ==="
sudo sed -i "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
sudo sed -i "s/bgpd_options=\"   -A 127.0.0.1\"/bgpd_options=\"   -A 127.0.0.1 -M rpki\"/" /etc/frr/daemons

echo "=== Corrigiendo permisos del directorio PID ==="
sudo chmod 740 /var/run/frr

echo "=== Iniciando FRR ==="
sudo systemctl start frr

echo "=== Instalación completada con éxito ==="
