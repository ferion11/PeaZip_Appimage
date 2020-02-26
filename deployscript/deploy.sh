#!/bin/bash
P_URL="https://github.com/giorgiotani/PeaZip/releases/download/7.1.0/peazip_portable-7.1.0.LINUX.x86_64.GTK2.tar.gz"
P_NAME=$(echo $P_URL | cut -d/ -f5)
P_VERSION=$(echo $P_URL | cut -d/ -f8)
P_FILENAME=$(echo $P_URL | cut -d/ -f9)
WORKDIR="workdir"

#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================

#add-apt-repository ppa:mystic-mirage/pycharm -y

#-----------------------------
#dpkg --add-architecture i386
apt update
#apt install -y aptitude wget file bzip2 gcc-multilib
apt install -y aptitude wget file bzip2
#===========================================================================================
# Get inex
# using the package
mkdir "$WORKDIR"

wget -nv $P_URL
tar xf $P_FILENAME -C "$WORKDIR/"

cd "$WORKDIR" || die "ERROR: Directory don't exist: $WORKDIR"

pkgcachedir='/tmp/.pkgdeploycache'
mkdir -p $pkgcachedir

#aptitude -y -d -o dir::cache::archives="$pkgcachedir" install pycharm-community

#extras
#wget -nv -c http://ftp.osuosl.org/pub/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-4_amd64.deb -P $pkgcachedir

#find $pkgcachedir -name '*deb' ! -name 'mesa*' -exec dpkg -x {} . \;
#echo "All files in $pkgcachedir: $(ls $pkgcachedir)"
#---------------------------------

##clean some packages to use natives ones:
#rm -rf $pkgcachedir ; rm -rf share/man ; rm -rf usr/share/doc ; rm -rf usr/share/lintian ; rm -rf var ; rm -rf sbin ; rm -rf usr/share/man
#rm -rf usr/share/mime ; rm -rf usr/share/pkgconfig; rm -rf lib; rm -rf etc;
#---------------------------------
#===========================================================================================

##fix something here:

#===========================================================================================
# appimage
cd ..

#wget -nv -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O  appimagetool.AppImage
chmod +x appimagetool.AppImage

chmod +x AppRun

cp AppRun $WORKDIR
cp resource/* $WORKDIR

./appimagetool.AppImage --appimage-extract

export ARCH=x86_64; squashfs-root/AppRun -v $WORKDIR -u 'gh-releases-zsync|ferion11|$P_NAME_Appimage|continuous|$P_NAME-v${P_VERSION}-*arch*.AppImage.zsync' $P_NAME-v${P_VERSION}-${ARCH}.AppImage

echo "All files at the end of script: $(ls)"
