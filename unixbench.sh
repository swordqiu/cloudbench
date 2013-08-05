#!/bin/bash

CMD=./repo/UnixBench/Run

if [ ! -f $CMD ]; then
	cd repo
	sh unixbench_install
	cd ..
	if [ ! -f $CMD ]; then
		echo "Cannot compile blogbench, exit"
		exit
	fi
fi

cd ./repo/UnixBench

./Run
