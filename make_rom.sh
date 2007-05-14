#!/bin/sh

if [ "$1" == "--help" -o "$1" == "-h" ]; then
	echo "Usage: $0 [-d device-name]"
	echo "	-d	Specifies a device to write to.	Do not include /dev/ in the name, i.e. sda would write to first USB drive."
	exit
fi

cd data
zip ../data.zip * > /dev/null
cd ..

python makecafe.py -c data.zip > rom-partition

./write_rom.sh $1 $2
