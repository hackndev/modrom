#!/bin/sh

cd data
zip ../data.zip *
cd ..

python makecafe.py -c data.zip > rom-partition

echo "Now run:"
echo "dd if=table.sct of=/dev/DEVICE conv=notrunc"
echo "dd if=rom-partition of=/dev/DEVICE seek=134079 bs=512 conv=notrunc"
