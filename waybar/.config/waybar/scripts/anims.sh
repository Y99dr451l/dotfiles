#!/usr/bin/zsh

if [ $(hyprctl repl 'hl.get_config("animations.enabled")') = 'false' ]; then
	echo \{\"percentage\": 0\}
else
	echo \{\"percentage\": 100\}
fi