#!/bin/bash

DESTDIR=$1

if [ -z $1 ]; then
	echo "Usage: blogbench.sh <DESTFILE>"
	exit 1
fi

if [ -x $DESTDIR ]; then
	echo "DESTDIR $DESTDIR exists, please specifiy a new directory"
	exit 1
fi

CMD=./repo/blogbench-1.1/src/blogbench

if [ ! -f $CMD ]; then
	cd repo
	sh blogbench_install
	cd ..
	if [ ! -f $CMD ]; then
		echo "Cannot compile blogbench, exit"
		exit
	fi
fi

DESTDIR=$(readlink -f "$DESTDIR")

echo "Test on $DESTDIR"

mkdir -p $DESTDIR

if [ "$?" != "0" ]; then
	echo "Fail to create dir $DESTDIR"
	exit 1
fi

$CMD -d $DESTDIR

rm -fr $DESTDIR
