#!/bin/bash

echo "Build base layout"
apt-ftparchive packages dists/hardy/base/binary-amd64/ > dists/hardy/base/binary-amd64/Packages
apt-ftparchive packages dists/hardy/base/binary-i386/ > dists/hardy/base/binary-i386/Packages
apt-ftparchive sources dists/hardy/base/source/ > dists/hardy/base/source/Sources

apt-ftparchive packages dists/hardy/base/binary-amd64/ | gzip -c > dists/hardy/base/binary-amd64/Packages.gz
apt-ftparchive packages dists/hardy/base/binary-i386/ | gzip -c > dists/hardy/base/binary-i386/Packages.gz
apt-ftparchive sources dists/hardy/base/source/ | gzip -c > dists/hardy/base/source/Sources.gz

echo "Build emc2.2 layout"
apt-ftparchive packages dists/hardy/emc2.2/binary-amd64/ > dists/hardy/emc2.2/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.2/binary-i386/ > dists/hardy/emc2.2/binary-i386/Packages
apt-ftparchive sources dists/hardy/emc2.2/source/ > dists/hardy/emc2.2/source/Sources

apt-ftparchive packages dists/hardy/emc2.2/binary-amd64/ | gzip -c > dists/hardy/emc2.2/binary-amd64/Packages.gz
apt-ftparchive packages dists/hardy/emc2.2/binary-i386/ | gzip -c > dists/hardy/emc2.2/binary-i386/Packages.gz
apt-ftparchive sources dists/hardy/emc2.2/source/ | gzip -c > dists/hardy/emc2.2/source/Sources.gz

echo "Build emc2.3 layout"
apt-ftparchive packages dists/hardy/emc2.3/binary-amd64/ > dists/hardy/emc2.3/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.3/binary-i386/ > dists/hardy/emc2.3/binary-i386/Packages
apt-ftparchive sources dists/hardy/emc2.3/source/ > dists/hardy/emc2.3/source/Sources

apt-ftparchive packages dists/hardy/emc2.3/binary-amd64/ | gzip -c > dists/hardy/emc2.3/binary-amd64/Packages.gz
apt-ftparchive packages dists/hardy/emc2.3/binary-i386/ | gzip -c > dists/hardy/emc2.3/binary-i386/Packages.gz
apt-ftparchive sources dists/hardy/emc2.3/source/ | gzip -c > dists/hardy/emc2.3/source/Sources.gz

echo "Generate Release"
apt-ftparchive -c apt-emc2-custom-release.conf release dists/hardy > dists/hardy/Release
apt-ftparchive -c apt-emc2-custom-release.conf release dists/hardy | gzip -c > dists/hardy/Release.gz

echo "signing repository"
gpg -a -b --default-key='emc-board@linuxcnc.org' -o dists/hardy/Release.gpg dists/hardy/Release

echo "all done."
