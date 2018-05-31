#!/bin/bash

# Simple script to delay a predefined command by x minutes
# ! Command should contains the full path to a executable
# ! Add permission for apache to sudo the at command (with visudo)


# CONFIG

command="/home/user/script.sh"
defaulttimeout=30


# CODE

echo "Content-type: text/plain"
echo

if [ -z ${1+x} ]; then 
    timeout=$defaulttimeout
else
    timeout=$1
fi

echo $timeout
echo $command | sudo at now + $timeout minute -M
echo "ok"
