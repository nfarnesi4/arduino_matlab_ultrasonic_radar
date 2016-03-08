function [scan_data_vec] = updateScanData( new_data, scan_data_vec )
%check to see if the angle is already in the vec
index = find([scan_data_vec.angleDeg] == new_data.angleDeg);

%the value is in the vector so update it
if length(index) > 0
    %the data is new
    if scan_data_vec(index).distance ~= new_data.distance
        scan_data_vec(index) = new_data;
        scan_data.vec(index).new = true;
        
        %the data is not new
    else
        scan_data_vec(index).new = false;
    end
    
    %the value is not in the vector add it
else
    scan_data_vec = [scan_data_vec, new_data];
end

end

