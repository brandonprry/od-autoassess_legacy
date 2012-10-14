#!/bin/bash

if [ `whoami` != "root" ]
then
	echo "You need to be root(ish)."
	exit
fi

CURDIR=`readlink -f $0 | sed "s/$(basename $0)//"`

echo "Where do you want to install to? (default: /opt/od-autoassess)"
read INSTALLDIR

if [ ! "$INSTALLDIR" ]
then
	INSTALLDIR="/opt/od-autoassess/"
fi

echo "Creating install directory..."
mkdir -p $INSTALLDIR

echo "Copying files..."
cp -R ./* $INSTALLDIR

echo "Linking to PATH..."
ln -s "$INSTALLDIR"od-autoassess.sh /usr/bin/od-autoassess
ln -s "$INSTALLDIR"od-autoassess_gui.py /usr/bin/od-autoassess_gui

chmod +x "$INSTALLDIR"od-autoassess.sh
chmod +x "$INSTALLDIR"od-autoassess_gui.py

echo "DONE!"
