# yvbeach-windy-exporter
Simple ETL to get data from the one of the best kitesurfing site in switzerland https://www.yvbeach.com/yvmeteo.htm  and load it into windy.app using their [custom api](windy-custom-api.md) .All credit go to Thomas Boegli who maintains the station. If you can, contribute to the incredible station's reliability by tipping him a few CHF, as I did.

## How to use
1. Clone this repo
2. Set your windy api key in your environment: `export WINDY_API_KEY=XXXXXXXXXXX`
3. `cd bash; docker compose up -d` 

This will fetch the data every minute.

## Debug
You can run the script once by doing : 

- in bash :
	
   ```
   cd bash
   ./yvbeach-etl.sh
   ```
   
- in python :
	
   ```
   cd python
   pip3 install -r requirements.txt
   ./yvbeach-etl.py
   ```
   
- in python with docker  :
	
   ```
   cd python
   docker run --env WINDY_API_KEY=${WINDY_API_KEY} moogly81/yvbeach-windy-exporter:latest
   ``` 
   