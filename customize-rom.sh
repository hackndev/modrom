#!/bin/sh
#

cut_line()
{
echo $1 | cut -c $2
}

echo "" > locales
echo "" > remove_files

cat custom.conf | while read LINE; do
if [ ! -z "$LINE" -a "`echo $LINE | cut -c 1`" != "#" ]; then

# remove this locale
if [ "$(cut_line $LINE 1)" == "l" ]; then
	LOCALE="$(cut_line $LINE "1-6")"
	case $LOCALE in
		* ) echo "$LOCALE" >> locales
	esac
fi

#remove this program
if [ "$(cut_line $LINE 1)" == "p" ]; then
	PROGRAM="$(cut_line $LINE "1-6")"
	case $PROGRAM in
		* ) echo "$PROGRAM" >> remove_files
	esac
fi
	
fi
done

if [ ! -d data ]; then
	unzip brahma-palmos -d data > /dev/null || exit
fi

cd data
mv ../locales ./
mv ../remove_files ./

# Removes locales not wanted
cat locales | while read LOCALE; do
if [ -n "$LOCALE" ]; then
LOCALE=${LOCALE:1:5}
#rm *$LOCALE.oprc
fi
done
