#!/bin/bash

# Mod_PageSpeed Installer in Centos Web Panel

# Simple Bash script by Bullten Web Hosting Solutions [http://www.bullten.com]

CDIR='/usr/local/mod-pagespeed'
# BDIR='/usr/local/mod-pagespeed/bin'
# EDIR='/usr/local/mod-pagespeed/mod_pagespeed'
SOURCE_URL_1='http://www.python.org/ftp/python/2.7/Python-2.7.tgz'
SOURCE_URL_2='https://www.kernel.org/pub/software/scm/git/git-2.0.4.tar.gz'
SOURCE_URL_3='http://src.chromium.org/svn/trunk/tools/depot_tools'
SOURCE_URL_4='https://github.com/pagespeed/mod_pagespeed.git'
packagepy="Python-2.7.tgz"
packagegit="git-2.0.4.tar.gz"
# pathDEPOT="/usr/local/mod-pagespeed/bin/depot_tools"
RED='\033[01;31m'
RESET='\033[0m'
GREEN='\033[01;32m'


clear

echo -e "$GREEN******************************************************************************$RESET"
echo -e "   Mod_PageSpeed Installation in CentOS Web Panel [http://centos-webpanel.com] $RESET"
echo -e "       Bullten Web Hosting Solutions http://www.bullten.com/"
echo -e "   Web Hosting Company Specialized in Providing Managed VPS and Dedicated Server   "
echo -e "$GREEN******************************************************************************$RESET"
echo " "
echo " "
echo -e $RED"This script will install Mod_PageSpeed on your system"$RESET
echo -e $RED""
echo -n  "Press ENTER to start the installation  ...."
#read option

clear

if [ -e "$CDIR" ];then
echo -e $RED"Installation directory found "$CDIR", Proceeding with installation."$RESET
echo "" 
sleep 5

else

echo ""
echo "No installation directory found, Creating installation directory"
mkdir -p $CDIR
sleep 5

fi

clear

# rm -rf $CDIR; mkdir -p $CDIR
# rm -rf $BDIR; mkdir -p $BDIR
# rm -rf $EDIR; mkdir $EDIR


echo -e $RED"Installing gcc-c++ gperf make rpm-build"$RESET
echo -e $RED""$RESET
sleep 5
sudo yum install gcc-c++ gperf make rpm-build -y

echo ""
echo -e $RED"Installation of gcc-c++ gperf make rpm-build completed"$RESET
sleep 2

clear

echo -e $RED"Python 2.7 Installation will begin in 5 seconds..."$RESET
echo ""
sleep 5
if [ -e "/usr/local/bin/python" ];then
echo -e $RED"Python already installed on your system."$RESET
sleep 2
else

echo -e $RED"Installing Python on your system."$RESET
echo ""
sleep 5

cd $CDIR
rm -rf $packagepy
rm -rf Python-2.7
wget --no-check-certificate $SOURCE_URL_1
tar xf $packagepy
cd Python-2.7
./configure --prefix=/usr/local
make && make altinstall
ln -s /usr/local/bin/python2.7 /usr/local/bin/python

echo ""
echo -e $RED"Completed Python Installation."$RESET
sleep 2

fi

clear

echo -e $RED"Git 2.0.4 Installation will begin in 5 seconds..."$RESET
echo ""
sleep 5

if [ -e "/usr/local/bin/git" ];then
echo -e $RED"Git already installed on your system."$RESET
sleep 2

else

echo -e $RED"Installing Git 2.0.4 on your system."$RESET
echo ""
sleep 5

cd $CDIR
rm -rf $packagegit
rm -rf git-2.0.4
wget --no-check-certificate $SOURCE_URL_2
tar -xf $packagegit
cd git-2.0.4
./configure
make && make install

echo ""
echo -e $RED"Completed Git Installation."$RESET
sleep 2

fi


clear

echo -e $RED"Chromium Depot Tools Installation will begin in 5 seconds..."$RESET
echo ""
sleep 5

if [ -e "$CDIR/bin/depot_tools" ];then
export PATH=$PATH:/usr/local/mod-pagespeed/bin/depot_tools
echo -e $RED"Chromium Depot already installed on your system."$RESET
sleep 5

else

rm -rf $CDIR/bin
mkdir -p $CDIR/bin
cd $CDIR/bin
svn co $SOURCE_URL_3
export PATH=$PATH:/usr/local/mod-pagespeed/bin/depot_tools

echo ""
echo -e $RED"Chromium Depot Tools Installation Completed."$RESET
sleep 5

fi

clear

echo -e $RED"Mod_PageSpeed Installation will begin in 5 seconds..."$RESET
echo ""
sleep 5

if [ -e "$CDIR/mod_pagespeed/src" ];then

cd $CDIR/mod_pagespeed/src
export SSL_CERT_DIR=/etc/pki/tls/certs
make AR.host=`pwd`/build/wrappers/ar.sh AR.target=`pwd`/build/wrappers/ar.sh BUILDTYPE=Release
cd install
chmod +x install_apxs.sh
APXS_BIN=/usr/local/apache/bin/apxs ./install_apxs.sh

else

rm -rf $CDIR/mod_pagespeed
mkdir -p $CDIR/mod_pagespeed
cd $CDIR/mod_pagespeed
gclient config $SOURCE_URL_4 --unmanaged --name=src
gclient sync --force --jobs=1

cd $CDIR/mod_pagespeed/src
export SSL_CERT_DIR=/etc/pki/tls/certs
make AR.host=`pwd`/build/wrappers/ar.sh AR.target=`pwd`/build/wrappers/ar.sh BUILDTYPE=Release
cd install
chmod +x install_apxs.sh
APXS_BIN=/usr/local/apache/bin/apxs ./install_apxs.sh

echo ""
echo -e $RED"Mod_PageSpeed Installation Completed."$RESET


fi

echo ""
echo -e $RED"Restarting Apache"$RESET
sleep 2

service httpd restart
chkconfig httpd on

sleep 2

echo -e $RED"Installation completed"$RESET
echo ""
echo -e $RED"Mod_PageSpeed is now enabled on your server.:)"$RESET
echo ""
echo -e $RED"If you find error please report it to support@bullten.com"$RESET