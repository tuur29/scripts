#!/usr/bin/python

# This script checks if my doorbell is pressed and sends a notification via join if it is

# only one instance allowed
from tendo import singleton
me = singleton.SingleInstance()

import RPi.GPIO as GPIO
import time
import datetime
import subprocess
import json

# options, no exclamation marks
header = 17
title = "Doorbell"
text = "Doorbell pressed"
pcIP = "192.168.x.x " #add space after
phoneIP = "192.168.x.x "
devices = "DEVICE" #comma seperated
icon = "https://example.com/icon.png"
apikey = ""
pushbullettoken = "KEY"

# send notif
def send(text=text,title=title,devices=devices): 

	timestamp = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d at %H:%M:%S')

	subprocess.call('curl "https://joinjoaomgcd.appspot.com/_ah/api/messaging/v1/sendPush?deviceNames='+devices.replace(" ", "%20").replace(",", "%2C")+'&deviceId=group.all&text='+text.replace(" ", "%20")+'%20on%20'+timestamp.replace(" ", "%20")+'&title='+title+'&group=doorbell&smallicon='+icon+'&apikey='+apikey+'"', shell=True)

	p = subprocess.Popen("curl --header 'Access-Token: "+pushbullettoken+"' --header 'Content-Type: application/json' --data-binary '{\"body\":\""+text+' on '+timestamp+"\",\"title\":\""+title+"\",\"type\":\"note\"}' --request POST https://api.pushbullet.com/v2/pushes", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

	response, errors = p.communicate()
	data = json.loads(response)

	subprocess.Popen("(sleep 30 && curl --header 'Access-Token: "+pushbullettoken+"' --request DELETE https://api.pushbullet.com/v2/pushes/"+data["iden"]+")", shell=True)

	# print timestamp +"  "+ text
	return

# get signal
GPIO.setmode(GPIO.BCM)
GPIO.setup(header, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def state():
	return GPIO.input(header)

# main
locked = False

while True:
	if locked == False:
		
		# check if blinking
		if state() == True:
			time.sleep(0.2)

			if state() == False:
				time.sleep(0.2)
				if state() == True:
					# doorbell pressed
					hour = int(datetime.datetime.fromtimestamp(time.time()).strftime('%-H'))
					if 6 <= hour <= 22:
						onlinedevices = open('/home/pi/devices.txt').read()
						if (phoneIP in onlinedevices) or (pcIP in onlinedevices):
							send()
						time.sleep(5)

			else:
				time.sleep(0.2)
				if state() == True:
					# doorbell disconnected
					locked = True
					send("Doorbell%20is%20disconnected")

	else:
		# check if bell reconnected
		time.sleep(3)
		if state() == False:
			send("Doorbell%20is%20reconnected")
			locked = False

	time.sleep(0.2)
