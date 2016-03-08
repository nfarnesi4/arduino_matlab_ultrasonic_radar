function [distance, angle, errormsg] = getDistance( angle )
%%create the system command    
%base_cmd = 'python get_serial_data.py %d';
base_cmd = 'python dummy_data.py %d';
cmd = sprintf(base_cmd, angle);

%%run the command and grab data from the sensor
[status, cmdout] = system(cmd);
data = str2num(cmdout);

%check for errors
if length(data) < 2
    errormsg = 'data error';
    distance = -1;
elseif data(1) ~= angle
    distance = -1;
    errormsg = 'error reading command';
else 
    errormsg = 'no error';
    distance = data(2);
end

end

