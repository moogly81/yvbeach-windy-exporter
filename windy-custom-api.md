# windy.app V9 custom api documentation
I wasn't able to find it anywhere, so here is it.

Send your data with a **GET** request, with data as url arguments. 

### Identification parameters 

  - **i** :  device number (coordinate w/ the windy.app support team to insert the station into their DB)
  - **secret** :  XXXXXXX (get this from the windy.app support team)



### Mandatory parameters 
All parameters are integers.

  - **d5** : direction from 0 to 1024. Clockwise. North is 0. Direction in degrees = (d5/1024)*360
  - **a** :  average wind per sending interval. In 10th of m/s  (for m/s - divide by 10)
  - **m** : minimal wind per sending interval. In 10th of m/s  (for m/s - divide by 10)
  - **g** : maximum wind per sending interval. In 10th of m/s  (for m/s - divide by 10)


### Optional parameters 
All parameters are integers.

  - **accum** : external potential. In 10th of V. (for V - divide by 10)
  - **p** : pressure in mbar 
  - **thc** : temperature of internal pressure sensor, in degrees celsius
  - **te2** : temperature of the external temperature sensor, in degrees celsius
  - **b** : internal tension. In 100th of V  (for volts - divide by 100)
  - **h** : humidity, in % 


Example  of a complete request: 

```
GET https://windyapp.co/apiV9.php?method=addCustomMeteostation&p=1015&g=290&a=124&m=124&d5=568&thc=88&i=yvonand&secret=XXXXXX
```