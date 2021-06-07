#!/usr/bin/env bash

# This script transforms the Yvonand beach meteo page to import them into windy.
# The api is easy. Send a single get request with all parameters (including the secret , LOL)

set -euo pipefail

raw_html=$(curl "https://www.yvbeach.com/yvmeteo.htm")


#comes from environment
if  [ -z ${WINDY_API_KEY+x} ]; then 
    echo "Please set up your api key : "
    echo "export WINDY_API_KEY=XXXXXXXXXX"
    exit 1
fi
secret="$WINDY_API_KEY"
ARGS="secret=$secret"

#  i - device number
# Can be pretty much anything
# Must be inserted in the db by with the windy.app team 
i="Yvonand"
ARGS+="&i=$i"

#  accum - external potential. should be divided by 10 to convert into voltage
#


#  p- pressure in mbar
p=$(echo "$raw_html" | grep PRESSION| sed 's/^.*nbsp; \(.*\) mb .*/\1/')
p=$(echo "$p/1" | bc)
ARGS+="&p=$p"

#  thc - temperature of internal pressure sensor, in tenth of degrees
thc=$(echo "$raw_html" | grep TEMPERATURE| sed 's/^.*nbsp; \(.*\)\&deg.*deg.*/\1/')
thc=$(echo "$thc * 10/1" | bc)
ARGS+="&thc=$thc"

#  te2 - température of the external temperature sensor

#  a* - average wind per sending interval in dm/s. for m/s - divide by 10
a=$(echo "$raw_html" | grep VENT| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
a=$(echo "$a * 100/36" | bc)
ARGS+="&a=$a"

#  m* - minimal wind per sending interval in dm/s. for m/s - divide by 10
# I don't have that, I'm taking the average ...
m=$a
ARGS+="&m=$m"

#  g* - maximum wind per sending interval in dm/s. for m/s - divide by 10
g=$(echo "$raw_html" | grep RAFALE| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
g=$(echo "$g * 100/36" | bc)
ARGS+="&g=$g"

# d5- direction from 0 to 1024. direction in degrees is equal = (d5/1024)*360
d5=$(echo "$raw_html" | grep DIRECTION| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')
d5=$(( d5 * 1024/360))
ARGS+="&d5=$d5"

#  b - internal tension. for volts - divide by 100
#

#  h - humidity
h=$(echo "$raw_html" | grep HUMIDITE| sed 's/^.*nbsp; \(.*\) %.*/\1/')
ARGS+="&h=$h"


curl  "https://windyapp.co/apiV9.php?method=addCustomMeteostation&$ARGS"