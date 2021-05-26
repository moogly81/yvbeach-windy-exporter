# yvbeach-windy-exporter
Gets the data from the one of the best kitesurfing site in switzerland https://www.yvbeach.com/yvmeteo.htm into the WINDY app. 


## How to use
1. Clone this repo
2. Set your windy api key in your environment: `export WINDY_API_KEY=XXXXXXXXXXX`
3. `docker compose up` 
   
 3b. Alternatively, you can run the script :

- in bash :
	
   ```
   ./yvbeach-etl.sh
   ```
   
- in python :
	
   ```
   pip3 install -r requirements.txt
   ./yvbeach-etl.py
   ```
   
- in docker  :
	
   ```
   docker run --env WINDY_API_KEY=${WINDY_API_KEY} moogly81/yvbeach-windy-exporter:latest
   ``` 
   

4. Set it up to run every minute to send the data to windy. 


## Weird units used by windy custom api
If I understood correctly, these ar the units used : 

```
//d5* - direction from 0 to 1024. direction in degrees is equal = (d5/1024)*360
//accum - external potential. should be divided by 10 to convert into voltage
//p- pressure in mbar or hPa
//thc - temperature of internal pressure sensor (this sensor is not installed in 0099)
//te2 - temperature of the external temperature sensor
//a* - average wind per sending interval. for m/c - divide by 10 (what is m/c ? does that mean it is in 10cm/sec)
//m* - minimal wind per sending interval. for m/c - divide by 10
//g* - maximum wind per sending interval. for m/c - divide by 10
//i* - device number
//b - internal tension. In 100th of V  (for volts - divide by 100)
//h - humidity, if sensor is installed in % 
//secret= XXXXXXX
```
