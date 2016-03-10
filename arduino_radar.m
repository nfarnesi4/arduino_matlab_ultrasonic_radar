clear all
clc

%%Const vars (denoted with 'k')

%angle const:
kupper_angle = 180;
klower_angle = 0;
kscan_step = 1;
ksweep_length = ((kupper_angle - klower_angle) + 1)/kscan_step;

%sensor const:
kmax_distance = 200;
kserial_port = '/dev/ttyACM0';

%spike filter const:
kbuffer_length = 7; %must be an odd number
kmidpoint_size = 3; %must be lower than the buffer_lenght/2
kspike_threshold = 60;

%%Program vars:

%the intial direction of the scan can be either clockwise (180->0) or
%counterclockwise (0 -> 180)
direction = 'counterclockwise';

%create the struct that will hold all the information about each point
current_scan_data = struct('angleDeg',klower_angle,'angleRad', klower_angle*(pi/180), 'distance', kmax_distance, 'new', true);

%init the scan data vec with all the angles and max distance
scan_data_vec = current_scan_data;   

%%set up the plot

%get the plot object for updateing he data
pp = polarplot([scan_data_vec.angleRad], [scan_data_vec.distance]);

%setup line properies
pp.LineWidth = 4;
pp.Color = 'green'

%get plot axis handle
ax = gca;

%set all the axis properties
ax.ThetaLimMode = 'manual';
ax.ThetaLim = [klower_angle kupper_angle];
ax.RLimMode = 'manual';
ax.RLim = [0 kmax_distance]; 
ax.RAxis.Label.String = 'Distance (cm)';
ax.ThetaGrid = 'off';
ax.Title.String = 'Arduino Radar';

%%the main program loop
while true
    
    %set the direction of the scan
    if strcmp(direction, 'counterclockwise')
        start_angle = klower_angle;
        end_angle = kupper_angle;
        step = kscan_step;
        %change the direction for the next scan
        direction = 'clockwise';
    else
        start_angle = kupper_angle;
        end_angle = klower_angle;
        step = -kscan_step;
        %change the direction for the next scan
        direction = 'counterclockwise';
    end
    
    %loop that does 1 full scan
    for current_angle = start_angle:step:end_angle
        
        %gret the distance data from the arduino
        [distance, angle, errormsg] = getDistance(kserial_port, current_angle);
        
        %check for an error reading the arduino
        if (~strcmp(errormsg, 'no error'))
            %an error ocurred print the error and exit the for loop but
            %not the main loop
            fprintf('Arduino Error %s\n', errormsg);
            break;
        end
        
        %Degrees:
        current_scan_data.angleDeg = current_angle;
        %Rad:
        current_scan_data.angleRad = angle*(pi/180);
        %Distance value:
        current_scan_data.distance = distance;
        %Age:
        current_scan_data.new = true;
        
        %add the value to the struct vec
        scan_data_vec = updateScanData(current_scan_data, scan_data_vec);
        
        %filter the data
        scan_data_vec = spikeFilter(scan_data_vec, kbuffer_length, kmidpoint_size, kspike_threshold);
        
        %update the plot with the new data
        pp.RData = [scan_data_vec.distance];
        pp.ThetaData = [scan_data_vec.angleRad];
        
        %this is needed so that the graph has time to update
        pause(.0001);
        
        %for debuging purposes
        %fprintf('Angle: %d Distance: %d\n', current_scan_data.angleDeg, current_scan_data.distance);
        
    end
    
    
end
