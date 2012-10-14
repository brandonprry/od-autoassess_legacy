#!/bin/bash

if [ `whoami` != "root" ]
then
	echo "You need to be root(ish)."
	exit
fi

INSTALLPATH=`readlink -f $0 | sed "s/$(basename $0)//"`

echo "Removing installation folder..."
rm -rf $INSTALLPATH

echo "Removing PATH links..."
rm /usr/bin/od-autoassess
rm /usr/bin/od-autoassess_gui

echo "DONE!"
