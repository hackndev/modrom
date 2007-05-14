#!/bin/sh
#run modFiles.pl
#remove the data directory if you want to start from scratch
#run reget_files.sh to be sure you have all the files
#run rm-files.sh to remove unwanted files (only removes for now)
#run makerom.sh with "-d XdX" to write to the drive at /dev/XdX
#		or
#run makerom.sh without "-d" to just make a rom-partition file

echo ""
echo "Do you wish to make a custom rom or write a generic one to disk?"
echo -n "Type Y for custom, N for generic. "
while read -n 1 YESNO; do
        if [ "$YESNO" == "n" -o "$YESNO" == "N" ]; then
		#get rom-partition and table.sct
		./get_generic.sh

		echo "If you know the /dev/ entry of your microdrive, enter it now."
		echo "If you do not, enter nothing."
		while read DEV; do
		if [ -n "$DEV" -a "$DEV" != "dunno" ]; then
			DDEV="-d $DEV"
			break
		elif [ "$DEV" == "dunno" ]; then
			DDEV=""
			break
		elif [ "$DEV" == "" ]; then
			DDEV=""
			break
		fi
		done

		./write_rom.sh $DDEV
		exit
        fi
        if [ "$YESNO" == "y" -o "$YESNO" == "Y" ]; then
                break
        fi
done

./modFiles.pl

echo ""
echo -n "Do you wish to start with fresh files? [Y/n] "
while read -n 1 YESNO; do
	if [ "$YESNO" == "y" -o "$YESNO" == "Y" ]; then
		rm -rf data
	fi
	if [ "$YESNO" == "n" -o "$YESNO" == "N" ]; then
		break
	fi	
done

echo ""
echo "Getting any necessary files now:"

./reget_files.sh
./rm-files.sh

echo "If you know the /dev/ entry of your microdrive, enter it now."
echo "If you do not, enter \"dunno\" without quotes."
while read DEV; do
if [ -n "$DEV" -a "$DEV" != "dunno" ]; then
	DDEV="-d $DEV"
	break
elif [ "$DEV" == "dunno" ]; then
	DDEV=""
	break
fi
done

./make_rom.sh $DDEV
echo "Finished."
