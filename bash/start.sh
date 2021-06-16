#!/bin/sh
source  ../.setup-api-key.sh
sudo docker build -t yvbeach-to-windy .
sudo docker run --name ybeach-to-windy -d --env WINDY_API_KEY=${WINDY_API_KEY} yvbeach-to-windy
