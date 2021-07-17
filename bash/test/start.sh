#!/bin/sh




# if [ -z "$WINDY_API_KEY" ] ;  then 
#   echo "WINDY_API_KEY not found in environment, please export it."
#   echo "ex:"
#   echo 'echo "export WINDY_API_KEY=XXXXXXXX" > ../.setup-api-key.sh'
#   echo 'source  ../.setup-api-key.sh'
# fi
# if [ -z "$WINDY_COM_API_KEY" ] ;  then 
#   echo "WINDY_API_KEY not found in environment, please export it."
#   echo "ex:"
#   echo 'echo "export WINDY_COMAPI_KEY=XXXXXXXX" >> ../.setup-api-key.sh'
#   echo 'source  ../.setup-api-key.sh'
# fi


docker rm -f yvbeach
sudo docker build -t yvbeach-to-windy .
sudo docker run --name yvbeach --rm  --env-file .env yvbeach-to-windy
