clear all
clc
%Const vars:
%data_file_path = 'data_files/data_2.csv';
kupper_angle = 170;
klower_angle = 1;
kscan_step = 1;
ksweep_length = ((kupper_angle - klower_angle) + 1)/kscan_step;

kmax_distance = 400;

polarplot([0 pi], [0 0]);

ax = gca;

ax.ThetaLimMode = 'manual';
ax.ThetaLim = [0 180];
ax.RLimMode = 'manual';
ax.RLim = [0 400]; 
ax.RAxis.Label.String = 'Distance (cm)';
ax.ThetaGrid = 'off';
ax.Title.String = 'Arduino Radar';

%%create the struct that will hold all the information about each point
current_scan_data = struct('angleDeg',[],'angleRad', [], 'distance', [], 'new', true);

%init the scan data vec
scan_data_vec = current_scan_data;

%init the coords variable
%scan_data = [klower_angle:scan_step:kupper_angle; zeros(ksweep_length)];

%the main program loop
%while true
    for current_angle = klower_angle:kscan_step:kupper_angle
        [distance, angle, errormsg] = getDistance(current_angle);
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
        
        
        
        fprintf('Angle: %d Distance: %d\n', current_scan_data.angleDeg, current_scan_data.distance);
        
    end
%end
