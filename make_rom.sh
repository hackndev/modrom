#!/bin/sh

if [ "$1" == "--help" -o "$1" == "-h" ]; then
	echo "Usage: $0 [-d device-name]"
	echo "	-d	Specifies a device to write to.	Do not include /dev/ in the name, i.e. sda would write to first USB drive."
	exit
fi

cd data
zip ../data.zip *
cd ..

python makecafe.py -c data.zip > rom-partition

if [ "$1" != "-d" ]; then
echo "Now run:"
echo "dd if=table.sct of=/dev/DEVICE conv=notrunc"
echo "dd if=rom-partition of=/dev/DEVICE seek=134079 bs=512 conv=notrunc"
else
dd if=table.sct of=/dev/$2 conv=notrunc
dd if=rom-partition of=/dev/$2 seek=134079 bs=512 conv=notrunc
fi
