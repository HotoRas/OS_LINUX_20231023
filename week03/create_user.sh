#!/bin/bash
for i in {1,20}; do
	useradd -m -s /bin/bash "student$i"
	echo "student$i:password!" | chpasswd
	change -d 0 "student$i"
done
