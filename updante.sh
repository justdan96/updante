#!/bin/bash

repoquery -q -a --pkgnarrow=updates --qf="%{name}-%{version}-%{arch}" | zenity --text-info --title="Available Updates" --width="500" --height="550" --checkbox="Install above updates"

if [ $? -eq 0 ]; then
   pkcon -p -y update >>/tmp/updante-temp.log &
   (while [ "$(pidof pkcon)" != "" ]; do
      CurrentOutput="$(tail --lines=1 /tmp/updante-temp.log)"
      echo "# $CurrentOutput" | sed -u "s|# Percentage:[^0-9]*||g" | sed -u "s|100|99|g"
   done)| zenity --progress --auto-close --no-cancel --title="Installing Updates" --text="Updating..." --width="500"
   # pkcon -p -y update | zenity --progress --title="Installing Updates" --text="Updating..." --pulsate --percentage="0"
fi

rm -f /tmp/updante-temp.log
