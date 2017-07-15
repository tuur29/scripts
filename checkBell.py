#!/usr/bin/python

# This script checks if my doorbell is pressed and sends a notification via join if it is

# only one instance allowed
from tendo import singleton
me = singleton.SingleInstance()

import RPi.GPIO as GPIO
import time
import datetime
import subprocess

# options (spaces to %20, no exclamation marks)
header = 17
title = "Doorbell"
text = "Doorbell%20pressed"
devices = "Phone" #comma seperated
apikey = ""

# send notif
def send(text=text,title=title,devices=devices): 
	timestamp = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d%%20at%%20%H:%M:%S')
	subprocess.call('curl "https://joinjoaomgcd.appspot.com/_ah/api/messaging/v1/sendPush?deviceNames='+devices+'&deviceId=group.all&text='+text+'%20on%20'+timestamp+'&title='+title+'&group=doorbell&apikey='+apikey+'"', shell=True)
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
