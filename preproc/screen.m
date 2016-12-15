function [ eles_list ] = screen( mat, cropping_mask, min_threshold, max_threshold )
% SCREEN 
% Screen every element in the matrix (in the cropping region) according to 
% the indicated threshold, including a minimum threshold and a maximum 
% threshold. If there is no min/max threshold, set it as 'None'
% - mat: The matrix that needs to be screened
% - cropping_mask: the cropping mask that will be used for the matrix
% - min_threshold: The minimum threshold for each of the elements
% - max_threshold: The maximum threshold for each of the elements
    
    eles_list = [];
    shape = size(mat);
    % For each of the elements
    for y = 1:shape(1)
        for x = 1:shape(2)
            % Only detect the cropping region
            if cropping_mask(y, x)
                % Replace the pixel with the brightest one in all over
                % the frame
                if (strcmp(min_threshold, 'None') || mat(y, x) > min_threshold)...
                   && (strcmp(max_threshold, 'None') || mat(y, x) < max_threshold)
                    eles_list = [eles_list; [x, y, mat(y, x)]];
                end
            end
        end
    end
end

