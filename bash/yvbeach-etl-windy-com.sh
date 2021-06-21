#!/usr/bin/env bash

# This script transforms the Yvonand beach meteo page to import them into windy.
# The api is easy. Send a single get request with all parameters (including the secret , LOL)
set -euo pipefail

raw_html=$(curl -s "https://www.yvbeach.com/yvmeteo.htm")


#comes from environment
if  [ -z ${WINDY_COM_API_KEY+x} ]; then 
    echo "Please set up your api key : "
    echo "export WINDY_COM_API_KEY=XXXXXXXXXX"
    exit 1
fi

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
wind=$(echo "$a_ * 100/3.6" | bc)
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
gust=$(echo "$g_ * 100/3.6" | bc)
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


#exit 0
curl "https://stations.windy.com/pws/update/$WINDY_COM_API_KEY?winddir=$d5_&wind=$wind&gust=$gust&temp=$te2&humidity=$h&mbar=$p"


#  station - 32 bit integer; required for multiple stations; default value 0; alternative names: si, stationId
#  time - text; iso string formated time "2011-10-05T14:48:00.000Z"; when time (or alternative) is NOT present server time is used
#  dateutc - text; UTC time formated as "2001-01-01 10:32:35"; (alternative to time)
#  ts - unix timestamp [s] or [ms]; (alternative to time)
#  temp - real number [°C]; air temperature
#  tempf - real number [°F]; air temperature (alternative to temp)
#  wind - real number [m/s]; wind speed
#  windspeedmph - real number [mph]; wind speed (alternative to wind)
#  winddir - integer number [deg]; instantaneous wind direction
#  gust - real number [m/s]; current wind gust
#  windgustmph - real number [mph]; current wind gust (alternative to gust)
#  rh - real number [%]; relative humidity ; alternative name: humidity
#  dewpoint - real number [°C];
#  pressure - real number [Pa]; atmospheric pressure
#  mbar - real number [milibar, hPa]; atmospheric pressure alternative
#  baromin - real number [inches Hg]; atmospheric pressure alternative
#  precip - real number [mm]; precipitation over the past hour
#  rainin - real number [in]; rain inches over the past hour (alternative to precip)
#  uv - number [index];
