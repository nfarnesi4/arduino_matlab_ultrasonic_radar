#!/usr/nin/python

import serial, time
import sys, signal

#check to make sure there are two input arguments
if len(sys.argv) > 2:
    serial_port = str(sys.argv[1])
    angle = str(sys.argv[2] + '!')
else:
    sys.exit(0);

#create the serial port object
ser = serial.Serial()
#specifiy the serial port
ser.port = serial_port
#set the the baudrate of the serial port
ser.baudrate = 9600 
#set the intial value of the dtr to zero
ser.dtr = 0
#set the timeout mode
ser.timeout = 2 #1 for non blocking 2 for blocking

#handle the control c interup from the user
def sigint_handler(signal, frame):
    #clear the data
    ser.flush()
    #close the port
    ser.close()
    #exit the program
    sys.exit(0)
signal.signal(signal.SIGINT, sigint_handler)

#open the serial port
try:
    ser.open()
#catch the serial expection
except Exception as e:
    print('Error with serial port: ' + str(e))
    sys.exit(-1)
    
#if the serial port is open
if ser.isOpen():
    try:
        #send the angle that you want the distance from 
        ser.write(angle.encode('ascii')) #angle.encode('ascii')) #angle.encode('ascii', 'replace'))

        #clear old data and send new stuff
        ser.flush()

        #read the line in from the arduino
        data = ser.readline()

        #convert the data into a string
        data = str(data)
        
        #loop through all the characters and delete all those that are not important
        for char in data:
            if char in " \'\\bnr":
                data = data.replace(char, '')
        
        #print the data
        print(data)
        
    #exception that can be thrown by any of the cals to the serial object
    except Exception as e1:
        print('Error communicating...: ' + str(e1))
        sys.exit(-1)

#opening the serial port failed
else:
    print('cannot open serial port ')
    sys.exit(-1)

