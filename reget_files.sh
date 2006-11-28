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
	DL_OPTS="-C - -O"
elif [ -n "$(which wget)" ]; then
	DL_PROG="$(which wget)"
	DL_OPTS="-c"
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
	$DL_PROG $DL_OPTS http://palmone.r3h.net/downloads.palmone.com/LifeDrive_Update_2_0_EFIGS_win.zip
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

if [ ! -e "unpdb.py" ]; then
	svn cat https://svn.sourceforge.net/svnroot/hackndev/linux4palm/tools/unpdb.py > unpdb.py
fi

if [ ! -e "brahma-palmos.zip" ]; then
	ls brahma-palmos.zip.?.pdb | sort | xargs -ti python unpdb.py {} - | dd skip=1 bs=32 > brahma-palmos.zip
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

if [ ! -e "makecafe.py" ]; then
	svn cat https://svn.sourceforge.net/svnroot/hackndev/linux4palm/tools/makecafe.py > makecafe.py
fi

if [ ! -e "rom-partition" ]; then
	python makecafe.py -c brahma-palmos.zip > ../rom-partition
fi

if [	-z "$(md5sum ../rom-partition | grep 639952c7a50e8d12d1d9351f3cbe9aa6)" ]; then
	echo "Something else went wrong."
	echo "I have no idea what. Might be python, could be a bad makecafe.py."
	echo "PM fahhem about this."
	exit
fi

if [ ! -e "table.sct" ]; then
	echo 'AAAAAAAAAAAAAAAAAAAAAQEABlgPCD8AAACACwIAAFgQCAAoHAu/CwIAgLAAAAAoHQsLz13xP7wCAIBLdwAAAAAAAAAAAAAAAAAAAAAAVao=' | python -c 'import base64,sys;sys.stdout.write("\0"*432+base64.b64decode(sys.stdin.read()))' > ../table.sct
fi

mv brahma-palmos.zip ../

echo "All the files are set up now."
