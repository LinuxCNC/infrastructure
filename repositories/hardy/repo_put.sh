#!/bin/bash
set -x
rsync --delay-updates --progress --max-delete=0 --bwlimit 24 -av -e "ssh -C" "$@" dists/ emcboard@linuxcnc.org:www.linuxcnc.org/hardy/dists
