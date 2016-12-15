function [ cropping_mask ] = crop_sector( shape, center_x, center_y, ...
                                       start_angle, end_angle )
% CROP ANGLE
    
    cropping_mask = zeros(shape);
    x1 = 1; y1 = 0; % relative coordinate location of 0 degree.
    % For each of the elements of the matrix
    for y = 1:shape(1)
        for x = 1:shape(2)
            x2 = x - center_x; y2 = y - center_y;
            % The angle between from current element and the zero degree
            % element
            angle = atan2d(y2,x2) - atan2d(y1,x1);
            if abs(angle) > 180
                angle = angle - 360*sign(angle);
            end
            
            if angle <= start_angle || angle > end_angle
                cropping_mask(y, x) = 0;
            else
                cropping_mask(y, x) = 1;
            end
        end
    end
    

end

