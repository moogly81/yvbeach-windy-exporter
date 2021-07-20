#!/usr/bin/env bash

# This script fetches html page form yvonand beach and transforms it into a key=value list

set -euo pipefail


raw_html=$(curl -s "https://yvbeach.com/yvmeteo.htm")
output_file='yvbeach.data'
rm -f $output_file

PRESSURE_MBAR=$(echo "$raw_html" | grep PRESSION| sed 's/^.*nbsp; \(.*\) mb .*/\1/')
echo "PRESSURE_MBAR=$PRESSURE_MBAR" >> $output_file
out="PRESSURE_MBAR=$PRESSURE_MBAR\n"

TEMPERATURE_CELSIUS=$(echo "$raw_html" | grep TEMPERATURE| sed 's/^.*nbsp; \(.*\)\&deg.*deg.*/\1/')
echo "TEMPERATURE_CELSIUS=$TEMPERATURE_CELSIUS" >> $output_file
out+="TEMPERATURE_CELSIUS=$TEMPERATURE_CELSIUS\n"

WATER_TEMPERATURE_CELSIUS=$(echo "$raw_html" | grep 'TEMP DU LAC'| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')
echo "WATER_TEMPERATURE_CELSIUS=$WATER_TEMPERATURE_CELSIUS" >> $output_file
out+="WATER_TEMPERATURE_CELSIUS=$WATER_TEMPERATURE_CELSIUS\n"

DEW_POINT=$(echo "$raw_html" | grep 'POINT DE ROSEE'| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')
echo "DEW_POINT=$DEW_POINT" >> $output_file

DAILY_RAIN_MM=$(echo "$raw_html" | grep 'PLUIE DU JOUR'| sed 's/^.*nbsp; *\(.*\) mm.*/\1/')
echo "DAILY_RAIN_MM=$DAILY_RAIN_MM" >> $output_file

WIND_KMH=$(echo "$raw_html" | grep VENT| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
echo "WIND_KMH=$WIND_KMH" >> $output_file

GUST_KMH=$(echo "$raw_html" | grep RAFALE| sed 's/^.*nbsp; \(.*\) km\/h.*/\1/')
echo "GUST_KMH=$GUST_KMH" >> $output_file

WIND_DIRECTION_DEGREES=$(echo "$raw_html" | grep DIRECTION| sed 's/^.*nbsp; \(.*\)\&deg.*/\1/')
echo "WIND_DIRECTION_DEGREES=$WIND_DIRECTION_DEGREES" >> $output_file

HUMIDITY_PERCENT=$(echo "$raw_html" | grep HUMIDITE| sed 's/^.*nbsp; \(.*\) %.*/\1/')
echo "HUMIDITY_PERCENT=$HUMIDITY_PERCENT" >> $output_file

printf "${out}"
