#!/bin/bash

for i in {1..5}; do
	sudo usermod -aG dev_team1 "student$i"
	echo "student$i << grout dev_team1"
done

echo "done"
