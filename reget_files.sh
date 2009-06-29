#!/bin/sh
# Copyright HacknDev (Fahrzin Hemmati fahhem@fahhem.com)
# This script automatically installs Palm OS to your microdrive
# 
# Programs needed before install:
# curl | wget
# unzip
# cabextract
# unshield
# python2.4
# subversion
# xargs
# sdd | dd
# md5sum


# Now checking for all necessary programs
# curl or wget. curl preferred
if [ -n "$(which curl)" ]; then
	DL_PROG="$(which curl)"
	DL_OPTS="-C - -o "
elif [ -n "$(which wget)" ]; then
	DL_PROG="$(which wget)"
	DL_OPTS="-c -O "
else
	echo "Please install curl or wget."
	INSTALL_STUFF="yes"
fi

check_exist() {
if [ -z "$(which $1)" ]; then
	echo "Please install $1."
	INSTALL_STUFF="yes"
fi
}

check_exist unzip
check_exist cabextract
check_exist unshield
#check_exist python2.4
check_exist svn
check_exist xargs
check_exist md5sum
check_exist dd
if [ "$INSTALL_STUFF" == "yes" ]; then
	exit
fi


# Now that everything is here, use it.

if [ -z "$(pwd | grep \"/tmp_files\$\")" ]; then
	mkdir -p tmp_files && cd tmp_files
fi

if [ -z "$(du LifeDrive_Update_2_0_EFIGS_win.zip 2> /dev/null| grep 21853)" ]; then
	$DL_PROG $DL_OPTS LifeDrive_Update_2_0_EFIGS_win.zip http://palmone.r3h.net/downloads.palmone.com/LifeDrive_Update_2_0_EFIGS_win.zip
fi

if [ ! -e "LifeDrive 2.0 Updater.exe" ]; then
	unzip LifeDrive_Update_2_0_EFIGS_win.zip
fi

if [ ! -d "Disk1" ]; then
	cabextract 'LifeDrive 2.0 Updater.exe'
fi

#mkdir -p data && cd data

if [ ! -d "BrahmaUpdate" ]; then
	unshield x Disk1/data1.cab
fi

cd Brahma* 2> /dev/null

UNPDB=""
if [ ! -e "unpdb.py" ] && [ ! -e "../../unpdb.py" ]; then
	$DL_PROG $DL_OPTS unpdb.py "http://git.hackndev.com/?p=hackndev/tools;a=blob_plain;f=unpdb.py;hb=HEAD"
elif [ ! -e "unpdb.py" ]; then
	UNPDB="../../"
fi

if [ ! -e "makecafe.py" ] && [ ! -e "../../makecafe.py" ]; then
	$DL_PROG $DL_OPTS makecafe.py "http://git.hackndev.com/?p=hackndev/tools;a=blob_plain;f=makecafe.py;hb=HEAD"
fi

if [ ! -e "table.sct" ]; then
	echo 'AAAAAAAAAAAAAAAAAAAAAQEABlgPCD8AAACACwIAAFgQCAAoHAu/CwIAgLAAAAAoHQsLz13xP7wCAIBLdwAAAAAAAAAAAAAAAAAAAAAAVao=' | python -c 'import base64,sys;sys.stdout.write("\0"*432+base64.b64decode(sys.stdin.read()))' > ../../table.sct
fi

if [ ! -e "brahma-palmos.zip" ]; then
	ls brahma-palmos.zip.?.pdb | sort | xargs -ti python ${UNPDB}unpdb.py {} - | dd skip=1 bs=32 > brahma-palmos.zip
fi

if [ 	-z "$(du -b brahma-palmos.zip | grep 20479778)" \
				-o  \
	-z "$(md5sum brahma-palmos.zip | grep 242847c981475636f7b74c7ba9a40379)" \
	\
	]; then
	echo "Something went wrong."
	echo "This is likely linked to python or the subversion repository."
	echo "PM fahhem about this."
	exit
fi


cp brahma-palmos.zip ../../
cp makecafe.py unpdb.py ../../ 2>/dev/null

echo "All the files are set up now."
