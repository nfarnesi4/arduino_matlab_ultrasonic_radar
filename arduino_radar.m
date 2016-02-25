clear all
clc

ard_port = '/dev/ttyACM0';
new_ping_dir = 'libs/NewPing';

ard = arduino(ard_port, 'uno','libraries', 'servo', 'libraries', new_ping_dir);