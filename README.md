# yvbeach-windy-exporter
Simple ETL to get data from the one of the best kitesurfing site in switzerland https:www.yvbeach.com/yvmeteo.htm  and load it into windy.app . 


## How to use
1. Clone this repo
2. Set your windy api key in your environment: `export WINDY_API_KEY=XXXXXXXXXXX`
3. `cd python; docker compose up` 
   
 3b. Alternatively, you can run the script :

- in bash :
	
   ```
   cd bash
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


## Using the windy.app custom api
Send your data with a **GET** request, with data as url arguments ...


### Identification parameters 

  - **i** :  device number (coordinate w/ the windy.app support team to insert the station into their DB)
  - **secret** :  XXXXXXX (get this from the windy.app support team)


### Mandatory parameters 


  - **d5** : direction from 0 to 1024. Clockwise. North is 0. Direction in degrees = (d5/1024)*360
  - **a** :  average wind per sending interval. In 10th of m/s  (for m/s - divide by 10)
  - **m** : minimal wind per sending interval. In 10th of m/s  (for m/s - divide by 10)
  -  **g** : maximum wind per sending interval. In 10th of m/s  (for m/s - divide by 10)


### Optional parameters 

  - **accum** : external potential. In 10th of V. (for V - divide by 10)
  - **p** : pressure in mbar or hPa
  - **thc** : temperature of internal pressure sensor, in 10th of degrees celsius
  - **te2** : temperature of the external temperature sensor, in 10th of degrees celsius
  - **b** : internal tension. In 100th of V  (for volts - divide by 100)
  - **h** : humidity, in % 


Example  of a complete request: 

```
GET https://windyapp.co/apiV9.php?method=addCustomMeteostation&p=1015&g=290&a=124&m=124&d5=568&thc=88&i=yvonand&secret=XXXXXX
```


