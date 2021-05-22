#  !/usr/bin/env bash
set -euo pipefail

curl https://www.yvbeach.com/yvmeteo.htm > raw.htm





secret="$WINDY_API_KEY"
ARGS="secret=$secret"
#  accum - external potential. should be divided by 10 to convert into voltage

#  p- pressure. for mmHg should be divided by 1,33. For kPa - divide by 10 (this sensor is not installed in 0099)
p=$(cat raw.htm | grep PRESSION| sed 's/^.*nbsp; \(.*\) mb .*/\1/')
p=$(echo "$p/1" | bc)
ARGS="p=$p&$ARGS"

#  thc - temperature of internal pressure sensor (this sensor is not installed in 0099)
thc=$(cat raw.htm | grep TEMPERATURE| sed 's/^.*nbsp; \(.*\)\&deg.*deg.*/\1/')
thc=$(echo "$thc * 10/1" | bc)
ARGS="thc=$thc&$ARGS"

#  te2 - température of the external temperature sensor

#  a* - average wind per sending interval. for m/c - divide by 10
a=$(cat raw.htm | grep VENT| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
a=$(echo "$a * 10/1" | bc)
ARGS="a=$a&$ARGS"

#  m* - minimal wind per sending interval. for m/c - divide by 10
m=$a
ARGS="m=$m&$ARGS"

#  g* - maximum wind per sending interval. for m/c - divide by 10
g=$(cat raw.htm | grep RAFALE| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
g=$(echo "$g * 10/1" | bc)
ARGS="g=$g&$ARGS"

# d5- direction from 0 to 1024. direction in degrees is equal = (d5/1024)*360
d5=$(cat raw.htm | grep DIRECTION| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')
let d5=$d5*1024/360
ARGS="d5=$d5&$ARGS"

#  i* - device number
i="YVONNAND"
ARGS="i=$i&$ARGS"


#  b - internal tension. for volts - divide by 100
#  h - humidity, if sensor is installed
h=$(cat raw.htm | grep HUMIDITE| sed 's/^.*nbsp; \(.*\) %.*/\1/')
ARGS="h=$h&$ARGS"



echo "https://windyapp.co/apiV9.php?method=addCustomMeteostation&$ARGS"

#secret=456HJHlfcyg89&d5=123&a=11&m=10&g=15&p=${pressure}&te2=20&i=test1//d5*"

