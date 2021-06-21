#!/bin/sh
if [ -z "$WINDY_API_KEY" ] ;  then 
  echo "WINDY_API_KEY not found in environment, please export it."
fi
