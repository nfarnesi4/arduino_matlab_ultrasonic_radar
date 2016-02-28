#!/usr/nin/python

import serial, time
import sys, signal

ser = serial.Serial()

ser.port = '/dev/ttyACM0'

ser.baudrate = 9600 

def sigint_handler(signal, frame):
    ser.flushInput()
    ser.close()
    sys.exit(0)
signal.signal(signal.SIGINT, sigint_handler)


#ser.timeout = 2 #1 for non blocking 2 for blocking

try:
    ser.open()

except Exception as e:
    print('Error with serial port: ' + str(e))
    exit()

if ser.isOpen():
    try:
        time.sleep(1)
        ser.flushInput()
        
        while True:
            data = ser.readline()
            data = str(data)
            for char in data:
                if char in " \'\\bnr":
                    data = data.replace(char, '')
                    
            print(data)
        
    except Exception as e1:
        print('Error communicating...: ' + str(e1))

else:
    print('cannot open serial port ')
