#!/bin/sh
if [ -z "$WINDY_API_KEY" ] ;  then 
  echo "WINDY_API_KEY not found in environment, please export it."
  echo "ex:"
  echo 'echo "export WINDY_API_KEY=XXXXXXXX" > ../.setup-api-key.sh'
  echo 'source  ../.setup-api-key.sh'
fi

sudo docker build -t yvbeach-to-windy .
sudo docker run --name ybeach-to-windy -d --env WINDY_API_KEY=${WINDY_API_KEY} yvbeach-to-windy
