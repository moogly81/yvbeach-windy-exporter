#!/bin/sh
sudo docker stop yvbeach
sudo docker run --detach --name yvbeach --rm  --env-file ../.env moogly81/yvbeach-windy-exporter:latest
