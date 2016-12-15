function [ cropping_mask ] = crop_ring( shape, center_x, center_y, ...
                                        outer_radius, inner_radius )
% CROP RING
% According to the location of the center point and the (outer/inner)
% radius, crop a region with ring shape. This function would generate a
% cropping mask. The elements of the cropped region have value 1, and the
% elements of the discarded region have value 0. 
% - shape: The shape of the matrix which needs to be cropped.
% - center_x: The x-axis index of the center of the cropped ring.
% - center_y: The y-axis index of the center of the cropped ring.
% - outer_radius: The radius of the outer circle of the cropped ring.
% - inner_radius: The radius of the inner circle of the cropped ring.

    cropping_mask = zeros(shape);
    % For each of the elements of the matrix
    for y = 1:shape(1)
        for x = 1:shape(2)
            % The distance between from current element and the center
            dist_sqr = (x - center_x) ^ 2 + (y - center_y) ^ 2;
            
            if dist_sqr >= outer_radius ^ 2 || dist_sqr < inner_radius ^ 2
                cropping_mask(y, x) = 0;
            else
                cropping_mask(y, x) = 1;
            end
        end
    end
end

