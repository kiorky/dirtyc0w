#!/usr/bin/env bash
cd $(dirname "$(readlink -f $0)")
USAGE="\
curl -s https://raw.githubusercontent.com/kiorky/dirtyc0w/master/dirtyc0w/dirtyc0w_asroot.sh>dirtyc0w_asroot.sh;\
cat dirtyc0w_asroot.sh;\
echo press_enter;read;sudo bash dirtyc0w_asroot.sh
"
if [[ -n ${DEBUG-} ]]; then
    set -x
fi
log() { echo "${@}" >&2 ; }
vv() { echo "${@}" >&2 ; "${@}"; }
W=$(pwd)
URL="https://raw.githubusercontent.com/kiorky/scripts/master/dirtyc0w"
tmp="$(mktemp)"
srcs="pokemon.c dirtyc0w.c"
srcs="pokemon.c"
f=${tmp}/m00m00
input="vuln"
get="curl -k -s"
if ! which gcc >/dev/null 2>&1; then
    log "missing compiler"
    exit 666
fi
if ! which curl >/dev/null 2>&1; then
    if ! which curl >/dev/null 2>&1; then
        get="wget --no-check-certificate -O-"
    else
        for i in $srcs; do
            if [ ! -e "${i}" ]; then
                log "missing downloader"
                exit 666
            fi
        done
    fi
fi
ret=0
cd /
if [[ -n "$tmp" ]] && [ -e "$tmp" ];then
    rm -rf "$tmp"
    mkdir "$tmp"
    chmod 2777 "${tmp}"
    for src in ${srcs};do
        printf hame > "${f}"
        if [ -z ${patterns-} ]; then
            patterns="/${src//.c}tmp.*"
        else
            patterns="${patterns} /${src//.c}tmp.*"
        fi
        bin=/${src//.c}$(basename $tmp)
        asrc=$W/$src
        if [ ! -e "$W/$src" ];then
            asrc="$tmp/$src"
            $get \
            "${URL}/${src}" \
            2>/dev/null > "$asrc"
        fi
        log "Compiling ${asrc}"
        gcc -pthread "${asrc}" -o "$bin"
        if [ -x "$bin" ];then
            wrapper="${bin}.sh"
            echo "#!/usr/bin/env bash" > "${wrapper}"
            case $bin in
                *pokemon*)
                    echo '"'$bin'" "'$f'" "'$input'"' >> "${wrapper}"
                    ;;
                *dirtyc0w*)
                    echo '"'$bin'" "'$f'" "'$input'"' >> "${wrapper}"
                    ;;
            esac
            chmod +x "${wrapper}"
            su -s /bin/bash -l nobody -c "${wrapper}"
        else
            log "noncompiled: ${src}"
            if [ $ret -lt 1 ]; then
                ret=3
            fi
        fi
        if grep -q "$input" "$f";then
            log vuln
            ret=455
            break
        fi
    done
else
    ret=1
fi
if [[ -z ${NODELETE-} ]];then
    if [[ -n "${patterns-}" ]] ;then
        rm -vf $patterns
    fi
    rm -rf "${tmp}"
fi
exit $ret
# vim:set et sts=4 ts=4 tw=80:
