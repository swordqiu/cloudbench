#!/bin/bash

DESTFILE=$1

if [ -z $1 ]; then
	echo "Usage: fio_test.sh <DESTFILE>"
	exit 1
fi

if [ -x $DESTFILE ]; then
	echo "DESTFILE $DESTFILE exists, please specifiy a new file"
	exit 1
fi

FIO_CMD=./repo/fio/fio

if [ ! -f $FIO_CMD ]; then
	cd repo
	sh fio_install
	cd ..
	if [ ! -f $FIO_CMD ]; then
		echo "Cannot compile fio, exit"
		exit
	fi
fi

DESTFILE=$(readlink -f "$DESTFILE")

echo "Test on $DESTFILE"

touch $DESTFILE

if [ "$?" != "0" ]; then
	echo "Fail to create file $DESTFILE"
	exit 1
fi

echo "Sequential READ"

$FIO_CMD --filename=$DESTFILE -iodepth=64 -ioengine=libaio --direct=1 --rw=read --bs=1m --size=2g --numjobs=4 --runtime=20 --name=test-read --group_reporting

echo "Sequentail WRITE"
$FIO_CMD --filename=$DESTFILE -iodepth=64 -ioengine=libaio --direct=1 --rw=write --bs=1m --size=2g --numjobs=4 --runtime=20 --name=test-write --group_reporting

echo "Random READ"
$FIO_CMD --filename=$DESTFILE -iodepth=64 -ioengine=libaio --direct=1 --rw=randread --bs=4k --size=2G --numjobs=64 --runtime=20 --name=test-rand-read --group_reporting

echo "Random WRITE"
$FIO_CMD --filename=$DESTFILE -iodepth=64 -ioengine=libaio -direct=1 --rw=randwrite --bs=4k --size=2G --numjobs=64 --runtime=20 --name=test-rand-write --group_reporting

rm $DESTFILE
