#!/bin/sh

gksudo -m "Enter your password to install EMC2" true
gpg --keyserver pgpkeys.mit.edu --recv-key 8F374FEF
gpg -a --export 8F374FEF | sudo apt-key add -

sudo sh -c 'cat > /etc/apt/sources.list.d/linuxcnc.list' <<EOF
deb http://www.linuxcnc.org/emc2 lucid base emc2.4
deb-src http://www.linuxcnc.org/emc2 lucid base emc2.4
EOF

sudo apt-get update
sudo apt-get -o Apt::Install-Recommends=true install emc2

