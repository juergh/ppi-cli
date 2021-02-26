#!/bin/bash -eu
#
#Environment settings
#

echo "-- Source ${BASH_SOURCE[0]}"

export RPI_MASTER=rpi-master:5000
export PATH=../bottle-pi:${PATH}
