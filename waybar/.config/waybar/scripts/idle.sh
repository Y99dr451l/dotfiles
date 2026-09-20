#!/usr/bin/zsh
if [ $(pidof hypridle) ]; then
	echo \{\"percentage\": 100\}
else
	echo \{\"percentage\": 0\}
fi