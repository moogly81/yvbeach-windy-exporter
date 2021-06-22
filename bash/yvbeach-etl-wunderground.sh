#!/usr/bin/env bash

# This script transforms the Yvonand beach meteo page to import them into windy.
# The api is easy. Send a single get request with all parameters (including the secret , LOL)
set -eo pipefail

# This is necessary to wait for the page to be fetched ...
sleep 13

echo "INFO : wunderground.com export"

raw_html=$(cat /tmp/yvmeteo.htm)


#  p- pressure in mbar
p_=$(echo "$raw_html" | grep PRESSION| sed 's/^.*nbsp; \(.*\) mb .*/\1/')
p=$(echo "$p_/1" | bc)

#  te2 - température of the external temperature sensor
te2_=$(echo "$raw_html" | grep TEMPERATURE| sed 's/^.*nbsp; \(.*\)\&deg.*deg.*/\1/')

#  thc - temperature of internal pressure sensor, in tenth of degrees

#  a* - average wind per sending interval in dm/s. for m/s - divide by 10
a_=$(echo "$raw_html" | grep VENT| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
windspeedmph=$(echo "scale=1; $a_ /1.609" | bc)

#  g* - maximum wind per sending interval in dm/s. for m/s - divide by 10
g_=$(echo "$raw_html" | grep RAFALE| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
windgustmph=$(echo "scale=1; $g_ /1.609" | bc)

# d5- direction from 0 to 1024. direction in degrees is equal = (d5/1024)*360
d5_=$(echo "$raw_html" | grep DIRECTION| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')

#  b - internal tension. for volts - divide by 100
#

#  h - humidity
h=$(echo "$raw_html" | grep HUMIDITE| sed 's/^.*nbsp; \(.*\) %.*/\1/')

url="https://weatherstation.wunderground.com/weatherstation/updateweatherstation.php?ID=IYVONA1&PASSWORD=ujfzEJby&dateutc=now&winddir=$d5_&windspeedmph=$windspeedmph&windgustmph=$windgustmph&humidity=$h&action=updateraw" 
echo "INFO : Wunderground : sending data (the secret is hidden in the log):"
echo "INFO : command :  $url" |sed 's/PASSWORD=[[:alnum:]]*/PASSWORD=XXXXXXX/'   
curl "$url" 
echo
