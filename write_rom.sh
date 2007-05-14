#!/bin/sh

if [ "$1" != "-d" ]; then
echo "Now run:"
echo "dd if=table.sct of=/dev/DEVICE conv=notrunc"
echo "dd if=rom-partition of=/dev/DEVICE seek=134079 bs=512 conv=notrunc"
else
dd if=table.sct of=/dev/$2 conv=notrunc
dd if=rom-partition of=/dev/$2 seek=134079 bs=512 conv=notrunc
fi
