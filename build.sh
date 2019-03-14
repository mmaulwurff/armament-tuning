#!/bin/bash

name=armament-tuning

rm -f $name.pk3 \
&& \
git log --pretty=format:"-%d %ai %s%n" > changelog.txt \
&& \
zip $name.pk3 \
    *.txt \
    *.zs \
    zscript/*.zs \
    *.md \
    LICENSE \
&& \
cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
gzdoom \
       \ #-iwad ~/Programs/Games/wads/doom/HERETIC.WAD \
       \ #-iwad ~/Programs/Games/wads/doom/freedoom1.wad \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
       -nomonsters
