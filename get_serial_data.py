#!/usr/nin/python

import serial, time
import sys, signal

if len(sys.argv) > 1:
    angle = str(sys.argv[1] + '!')
    #print('degree: ' + str(degree))
    #print(angle)
else:
    sys.exit(0);


ser = serial.Serial()

ser.port = '/dev/ttyACM0'

ser.baudrate = 9600 

def sigint_handler(signal, frame):
    ser.flushInput()
    ser.close()
    sys.exit(0)
signal.signal(signal.SIGINT, sigint_handler)


ser.timeout = 2 #1 for non blocking 2 for blocking

try:
    ser.open()

except Exception as e:
    print('Error with serial port: ' + str(e))
    exit()

#data_found = false

if ser.isOpen():
    try:
        #flush the buffers
        #ser.flushOutput()
        
        while True:#ser.in_watting < 1:
            if ser.read(1) == b'*':
                ser.flushInput()
                break
                #break

        #send the angle that you want the distance from 
        ser.write(angle.encode('ascii')) #angle.encode('ascii')) #angle.encode('ascii', 'replace'))
        ser.flush()
            
        data = ser.readline()
        data = str(data)
        
        #loop through all the characters and delete all those that are not important
        for char in data:
            if char in " \'\\bnr":
                data = data.replace(char, '')
        
        #print the data
        print(data)
        
    except Exception as e1:
        print('Error communicating...: ' + str(e1))

else:
    print('cannot open serial port ')
