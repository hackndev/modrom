#!/bin/sh

# Will just download generic ROM from fahhem.com

curl -o rom-partition http://fahhem.com/ldlinux/rom-partition.bin

if [ "$(du rom-partition | cut -b 1-5)" != "19968" ]; then
	echo "Fahhem.com is down."
	exit
fi

curl -o table.sct http://fahhem.com/ldlinux/table.sct.bin

if [ "$(du table.sct|cut -b 1)" != "4" ]; then
	echo "Fahhem.com is down."
	exit
fi
