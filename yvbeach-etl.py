#!/usr/bin/env python3

# This script transforms the Yvonand beach meteo page to import them into windy.
# The api is easy. Send a single get request with all parameters (including the secret , LOL)


import requests
import re
from bs4 import BeautifulSoup
import os

secret = os.environ.get('WINDY_API_KEY')

url = 'https://www.yvbeach.com/yvmeteo.htm'
res = requests.get(url)
html_page = res.content
soup = BeautifulSoup(html_page, 'html.parser')
text = soup.find_all(text=True)

output = ''
args = ''
for t in text:
    output += '{} '.format(t)
#print(output)

#for line in text_file:
for line in output.splitlines():
    #print(line)
    line = line.strip() 
    if ' : ' in line:
        if re.match('\A[A-Z]', line):                                        #if line begins with Upper case letter
            line = re.sub('\A(\w*).*:[\sA-Z-]*([0-9\.]*).*', r'\1:\2', line) #regex of the death, if this break, good luck !
            if re.match('PRESSION', line): 
                p = re.sub('.*:([\d\.])', r'\1', line)
                p = int(float(p)+0.5)
                args="&p="+str(p)
                print('pression =', p, "mbars")
            if re.match('VENT', line): 
                a = re.sub('.*:([\d\.])', r'\1', line)
                a = int(float(a)*10)
                args+="&a="+str(a)
                # I don't have minimum, I'll take it from the actual value
                args+="&m="+str(a)
                print('average =', a, "(in 10th of km/h...)")
            if re.match('RAFALE', line): 
                g = re.sub('.*:([\d\.])', r'\1', line) 
                g = int(float(g)*10)
                args+="&g="+str(g)
                print('max =', g, "in 10th of km/h...")
            if re.match('DIRECTION', line): 
                d5 = re.sub('.*:([\d\.])', r'\1', line) 
                d5 = int(float(d5)*1024/360)
                args+="&d5="+str(d5)
                print('direction =', d5, "from 0 to 1024 (1024 being 360 degrees)")
            if re.match('TEMPERATURE', line): 
                thc = re.sub('.*:([\d\.])', r'\1', line) 
                thc = int(float(thc)*10)
                args+="&thc="+str(thc)
                print('temperature =', thc, "in 10th of celcius degrees") 
            if re.match('HUMIDITE', line): 
                h = re.sub('.*:([\d\.])', r'\1', line) 
                h = int(float(h))
                args+="&h="+str(h)
                print('humidity =', h, "in %")


dest_url="https://windyapp.co/apiV9.php?method=addCustomMeteostation"

more_args="&i=YVONAND&secret="+secret
complete_url=dest_url+args+more_args
print(complete_url)


send = requests.get(complete_url)
print(send.content)

