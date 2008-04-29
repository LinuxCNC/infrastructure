#!/bin/bash

rsync -avz -e ssh juve@dinero.dreamhost.com:/home/emcboard/www.linuxcnc.org/hardy/dists/ dists
