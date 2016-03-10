function [ scan_data_vec ] = spikeFilter(scan_data_vec, buffer_length, midpoint_size, spike_threshold)

%calculate the midpoint which is the point you are checking for a spike
midpoint = median(1:buffer_length);
low_midpoint = (midpoint+1) - midpoint_size;
high_midpoint = (midpoint-1) + midpoint_size;

if length(scan_data_vec) > buffer_length
    
    for index = 1:(length(scan_data_vec)-buffer_length)
        %role the buffer
        buffer = [scan_data_vec(index:index+buffer_length)];
        
        %find the mean of high values and the low, high and mid points
        low_mean = mean([buffer( 1:(midpoint - midpoint_size)).distance]);
        high_mean = mean([buffer( (midpoint + midpoint_size):length(buffer) ).distance ]);
        mid_mean = mean( [buffer( low_midpoint:high_midpoint ).distance] );
        
        
        %average the differnce between the low and midpoints means and
        %the high and midpoint means
        spike_value = mean([abs(low_mean-mid_mean) abs(high_mean-mid_mean)]);
        
        %check if the spike value is greater than the threshold
        if spike_value >= spike_threshold
            %set the midpoint(s) to the average of the high and low means
            high_low_mean = mean([low_mean high_mean]);
            %loop through and edit all the spike points and set them to the
            %average of the high and low points
            for i = index+low_midpoint:index+high_midpoint
                scan_data_vec(i).distance = high_low_mean;
            end
        end
    end
    
else
    %the data is fine so just return without editing any of the data
    scan_data_vec = scan_data_vec;
    
end

end

