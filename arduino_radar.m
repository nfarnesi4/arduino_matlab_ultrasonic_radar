clear all
clc
%Const vars:
data_file_path = 'data_files/data_2.csv';



%read the data in from the file
data = csvread(data_file_path);
%convert degrees to radians for ploting
data(:,1) = data(:,1)*(pi/180);

%coords = pol2cart(data(:,1), data(:,2));

%plot(coords);

%plot the data
%figure
polar(data(1,1), data(1,2));

%for i = 1:70
   % polar(data(i,1), data(i,2)); 
    %drawnow
    %hold on
    %m(i) = getframe();
%end

num = 1;
fps = 5;
%movie(m,num,fps);


%function average_values