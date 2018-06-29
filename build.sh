#!/bin/bash

name=armament-tuning

rm -f $name.pk3 \
&& \
zip $name.pk3 \
    *.txt \
&& \
gzdoom -glversion 3 \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
       -nomonsters

       #-iwad ~/Programs/Games/wads/doom/HERETIC.WAD \
