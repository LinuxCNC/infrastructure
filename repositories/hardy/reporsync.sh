#!/bin/bash

rsync -avz -e ssh dists/ juve@dinero.dreamhost.com:/home/emcboard/www.linuxcnc.org/hardy/dists

