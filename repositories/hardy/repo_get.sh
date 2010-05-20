#!/bin/bash
rsync --progress --max-delete=0 -av -e "ssh -C" "$@" emcboard@linuxcnc.org:www.linuxcnc.org/hardy/dists/ dists
