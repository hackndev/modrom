#!/bin/sh

# Will just download generic ROM from fahhem.com

if [ -n "$(which curl)" ]; then
    DL_PROG="$(which curl)"
    DL_OPTS="-C - -o "
elif [ -n "$(which wget)" ]; then
    DL_PROG="$(which wget)"
    DL_OPTS="-c -O "
else
    echo "Please install curl or wget."
	exit 1
fi

if [ -z "$(which md5sum)" ]; then
    echo "Please install md5sum"
	exit 1
fi


$DL_PROG $DL_OPTS rom-partition.md5 http://fahhem.com/ldlinux/rom-partition.md5

if [ -f rom-partition.md5 ]; then
	VALIDROMMD5=$(cat rom-partition.md5)
else
	echo "Fahhem.com may be down, using default md5"
	VALIDROMMD5="7560ae777c0410ca79f51906e3778756  rom-partition"
fi

while [ "$DOWN" != "YES" ]; do
	if [ -f rom-partition ] && [ "$(md5sum rom-partition)" != "$VALIDROMMD5"] 2>/dev/null; then
		echo "Found (valid) previously downloaded file - skipping download"
	else # either doesn't exist or invalid
		if [ "$DOWNLOADED" == "YES"]; then
			#attempting to stick to DRY and not repeat MD5 check
			echo "Fahhem.com may be down, cannot get rom-partition"
			exit 2
		fi
		$DL_PROG $DL_OPTS rom-partition http://fahhem.com/ldlinux/rom-partition.bin
		DOWNLOADED="YES"
	fi
done

$DL_PROG $DL_OPTS table.sct http://fahhem.com/ldlinux/table.sct.bin

if [ "$(du table.sct|cut -b 1)" != "4" ]; then
	echo "Fahhem.com may be down, cannot get table.sct"
	exit 2
fi

exit 0
