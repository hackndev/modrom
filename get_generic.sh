#!/bin/sh

# Will just download generic ROM from fahhem.com

curl -o rom-partition2 http://fahhem.com/ldlinux/rom-partition.bin

if [ "$(du rom-partition2 | cut -b 1-5)" != "19968" ]; then
	echo "Fahhem.com is down."
	exit
fi

curl -o table.sct2 http://fahhem.com/ldlinux/table.sct.bin

if [ "$(du table.sct2|cut -b 1)" != "4" ]; then
	echo "Fahhem.com is down."
	exit
fi
