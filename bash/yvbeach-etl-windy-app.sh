#!/usr/bin/env bash

# This script transforms the Yvonand beach meteo page to import them into windy.
# The api is easy. Send a single get request with all parameters (including the secret , LOL)
set -euo pipefail

# This is necessary to wait for the page to be fetched ...
sleep 10

#raw_html=$(cat yvmeteo.htm)
echo "INFO : windy.app export"

raw_html=$(cat "/tmp/yvmeteo.htm")

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
p_=$(echo "$raw_html" | grep PRESSION| sed 's/^.*nbsp; \(.*\) mb .*/\1/')
p=$(echo "$p_/1" | bc)
echo "Measured pressure : $p mbars"
ARGS+="&p=$p"

#  te2 - température of the external temperature sensor
te2_=$(echo "$raw_html" | grep TEMPERATURE| sed 's/^.*nbsp; \(.*\)\&deg.*deg.*/\1/')
te2=$(echo "$te2_/1" | bc)
echo "Measured temperature : $te2_ degrees,  reported as $te2"
ARGS+="&te2=$te2"

#  thc - temperature of internal pressure sensor, in tenth of degrees

#  a* - average wind per sending interval in dm/s. for m/s - divide by 10
a_=$(echo "$raw_html" | grep VENT| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
a=$(echo "$a_ * 100/36" | bc)
echo "Measured wind (avg) : $a_ km/h,  reported as $a dm/s"
ARGS+="&a=$a"

#  m* - minimal wind per sending interval in dm/s. for m/s - divide by 10
# I don't have that, I'm taking the average ...
m=$a
ARGS+="&m=$m"
echo "Measured wind (min) : $a_ km/h,  reported as $a dm/s"

#  g* - maximum wind per sending interval in dm/s. for m/s - divide by 10
g_=$(echo "$raw_html" | grep RAFALE| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
g=$(echo "$g_ * 100/36" | bc)
echo "Measured wind (max) : $g_ km/h,  reported as $g dm/s"
ARGS+="&g=$g"

# d5- direction from 0 to 1024. direction in degrees is equal = (d5/1024)*360
d5_=$(echo "$raw_html" | grep DIRECTION| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')
d5=$(( d5_ * 1024/360))
echo "Measured wind direction : $d5_ degrees,  reported as $d5"
ARGS+="&d5=$d5"

#  b - internal tension. for volts - divide by 100
#

#  h - humidity
h=$(echo "$raw_html" | grep HUMIDITE| sed 's/^.*nbsp; \(.*\) %.*/\1/')
ARGS+="&h=$h"
echo "Measured humidity : $h%"

echo "sending data to windy (the secret is hidden in the log):"
echo    "https://windyapp.co/apiV9.php?method=addCustomMeteostation&$ARGS" |sed 's/secret=[[:alnum:]]*/secret=XXXXXXX/'   
curl -s "https://windyapp.co/apiV9.php?method=addCustomMeteostation&$ARGS"
echo
