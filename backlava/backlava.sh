#!/bin/bash

## (cc) marcio rps AT gmail.com
## This script is based on the configuration found at https://wiki.archlinux.org/index.php/rsync

SRC="/home/logan/test/"
SNAP="/home/logan/snaps"
OPTS="-rltgoi --delay-updates --delete --chmod=a-w"
MINCHANGES=20

ionice -c 3 -p $$
renice +12 -p $$

rsync $OPTS $SRC $SNAP/latest >> $SNAP/rsync.log

COUNT=$( wc -l $SNAP/rsync.log|cut -d" " -f1 )
if [ $COUNT -gt $MINCHANGES ] ; then
        DATETAG=$(date +%Y-%m-%d)
        if [ ! -e $SNAP/$DATETAG ] ; then
                cp -al $SNAP/latest $SNAP/$DATETAG
                chmod u+w $SNAP/$DATETAG
                mv $SNAP/rsync.log $SNAP/$DATETAG
               chmod u-w $SNAP/$DATETAG
         fi
fi

