#!/usr/nin/python

import serial, time
import sys, signal
import random

if len(sys.argv) > 1:
    angle = str(sys.argv[1])
else:
    sys.exit(0);

def sigint_handler(signal, frame):
    sys.exit(0)
signal.signal(signal.SIGINT, sigint_handler)

print(angle + ', ' + str(random.randint(250,400)) )

