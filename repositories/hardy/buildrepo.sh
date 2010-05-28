#!/bin/bash
gz () {
for i in "$@"; do
    gzip < "$i" > "$i".gz
done
}

echo "Build firmware symlinks"
(cd dists/hardy/base/binary-amd64; ln -svf ../binary-all/*_all.deb .)
(cd dists/hardy/base/binary-i386; ln -svf ../binary-all/*_all.deb .)
(cd dists/hardy/emc2.3/binary-amd64; ln -svf ../binary-all/*_all.deb .)
(cd dists/hardy/emc2.3/binary-i386; ln -svf ../binary-all/*_all.deb .)

echo "Build base layout"
apt-ftparchive packages dists/hardy/base/binary-amd64/ > dists/hardy/base/binary-amd64/Packages
apt-ftparchive packages dists/hardy/base/binary-i386/ > dists/hardy/base/binary-i386/Packages
apt-ftparchive sources dists/hardy/base/source/ > dists/hardy/base/source/Sources

echo "Build emc2.2 layout"
apt-ftparchive packages dists/hardy/emc2.2/binary-amd64/ > dists/hardy/emc2.2/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.2/binary-i386/ > dists/hardy/emc2.2/binary-i386/Packages
apt-ftparchive sources dists/hardy/emc2.2/source/ > dists/hardy/emc2.2/source/Sources

echo "Build emc2.3 layout"
apt-ftparchive packages dists/hardy/emc2.3-sim/binary-amd64/ > dists/hardy/emc2.3-sim/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.3-sim/binary-i386/ > dists/hardy/emc2.3-sim/binary-i386/Packages
#apt-ftparchive packages dists/hardy/emc2.3-sim/binary-all/ > dists/hardy/emc2.3-sim/binary-all/Packages
apt-ftparchive sources dists/hardy/emc2.3-sim/source/ > dists/hardy/emc2.3-sim/source/Sources

apt-ftparchive packages dists/hardy/emc2.3/binary-amd64/ > dists/hardy/emc2.3/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.3/binary-i386/ > dists/hardy/emc2.3/binary-i386/Packages
#apt-ftparchive packages dists/hardy/emc2.3/binary-all/ > dists/hardy/emc2.3/binary-all/Packages
apt-ftparchive sources dists/hardy/emc2.3/source/ > dists/hardy/emc2.3/source/Sources

echo "Build emc2.4 layout"
apt-ftparchive packages dists/hardy/emc2.4-sim/binary-amd64/ > dists/hardy/emc2.4-sim/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.4-sim/binary-i386/ > dists/hardy/emc2.4-sim/binary-i386/Packages
#apt-ftparchive packages dists/hardy/emc2.4-sim/binary-all/ > dists/hardy/emc2.4-sim/binary-all/Packages
apt-ftparchive sources dists/hardy/emc2.4-sim/source/ > dists/hardy/emc2.4-sim/source/Sources

apt-ftparchive packages dists/hardy/emc2.4/binary-amd64/ > dists/hardy/emc2.4/binary-amd64/Packages
apt-ftparchive packages dists/hardy/emc2.4/binary-i386/ > dists/hardy/emc2.4/binary-i386/Packages
#apt-ftparchive packages dists/hardy/emc2.4/binary-all/ > dists/hardy/emc2.4/binary-all/Packages
apt-ftparchive sources dists/hardy/emc2.4/source/ > dists/hardy/emc2.4/source/Sources

echo "Generate Release"
apt-ftparchive -c apt-emc2-custom-release.conf release dists/hardy > dists/hardy/Release

echo "Make compressed copies"
gz `find -name Packages -or -name Sources -or -name Release`

echo "signing repository"
rm -f dists/hardy/Release.gpg
gpg -a -b --default-key='emc-board@linuxcnc.org' -o dists/hardy/Release.gpg dists/hardy/Release

echo "all done -- ./repo-put.sh if all looks good"
