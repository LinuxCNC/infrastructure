#! /bin/bash

# Check for root access
if [ "$EUID" -ne 0 ]
  then echo "Please run this script with sudo, ie sudo ./linuxcnc-install.sh"
  exit
fi

echo 'Getting archive signing key'
GPGTMP=$(mktemp -d /tmp/.gnupgXXXXXX)
gpg --homedir $GPGTMP --keyserver hkp://keyserver.ubuntu.com --recv-key 3cb9fd148f374fef
gpg --homedir $GPGTMP --export 'EMC Archive Signing Key' | tee /usr/share/keyrings/linuxcnc-old.gpg > /dev/null
gpg --homedir $GPGTMP --keyserver hkp://keyserver.ubuntu.com --recv-key e43b5a8e78cc2927
gpg --homedir $GPGTMP --export 'LinuxCNC Archive Signing Key' | tee /usr/share/keyrings/linuxcnc.gpg > /dev/null
echo 'deleting temp files'
rm -rf $GPGTMP
echo 'getting distribution name'
. /etc/os-release
echo 'Updating apt repository list'
case $VERSION_CODENAME in
	'buster' | 'bullseye' | 'bookworm' )
		echo deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/linuxcnc-old.gpg] https://www.linuxcnc.org/ $VERSION_CODENAME base 2.9-uspace 2.9-rt | tee /etc/apt/sources.list.d/linuxcnc.list > /dev/null
		echo deb-src [arch=amd64,arm64 signed-by=/usr/share/keyrings/linuxcnc-old.gpg] https://www.linuxcnc.org/ $VERSION_CODENAME base 2.9-uspace 2.9-rt | tee -a /etc/apt/sources.list.d/linuxcnc.list > /dev/null ;;
	*)
		echo deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/linuxcnc.gpg] https://www.linuxcnc.org/ $VERSION_CODENAME base 2.9-uspace 2.9-rt | tee /etc/apt/sources.list.d/linuxcnc.list > /dev/null
		echo deb-src [arch=amd64,arm64 signed-by=/usr/share/keyrings/linuxcnc.gpg] https://www.linuxcnc.org/ $VERSION_CODENAME base 2.9-uspace 2.9-rt | tee -a /etc/apt/sources.list.d/linuxcnc.list > /dev/null ;;
esac

echo 'Updating APT index'
apt-get update
echo 'Installing LinuxCNC'
apt-get install linuxcnc-uspace
echo ''
echo 'You might also want to consider installing the docs package for your language'
echo 'And also the linuxcnc-uspace-dev package'
echo 'command: sudo apt-get install linuxcnc-doc-[en/fr/de/ja/es/ru/da/hu/sl]'
echo 'sudo apt-get install linuxcnc-dev'

