function [distance, angle, errormsg] = getDistance( serial_port, angle )
%%create the system command
base_cmd = 'python get_serial_data.py %s %d';
cmd = sprintf(base_cmd, serial_port, angle);

%Dummy data command
%base_cmd = 'python dummy_data.py %d';%
%cmd = sprintf(base_cmd, angle);

%%run the command and grab data from the sensor
[status, cmdout] = system(cmd);
data = str2num(cmdout);

%%check for errors

%not enough data error
if length(data) < 2
    errormsg = 'not enough data error';
    distance = -1;
%the angle printed from the script is not the same 
elseif data(1) ~= angle
    distance = -1;
    errormsg = 'angle error';
%no errors occured
else 
    errormsg = 'no error';
    distance = data(2);
end

end

