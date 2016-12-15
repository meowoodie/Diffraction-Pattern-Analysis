function [ mat ] = max_mats( mats, cropping_mask )
% MAX MAT
% Get the maximum value for each of the elements over all of the matrix (in
% the cropping region), you can specify the cropping region by indicating 
% a cropping mask.
% - mats: a 3d matrix, which contains multiple 2d matrixs
% - cropping_mask: the cropping mask that will be used for each of the 2d
%                  matrixs

    last_mat = zeros(size(mats(:,:,1))); % Last matrix
    % For each of the matrixs
    for i=1:size(mats, 3)
        cur_mat = mats(:,:,i); % Current matrix
        shape   = size(cur_mat);
        % For each of the elements
        for y = 1:shape(1)
            for x = 1:shape(2)
                % Only detect the cropping region
                if cropping_mask(y, x)
                    % Replace the pixel with the brightest one in all over
                    % the frame
                    if cur_mat(y, x) < last_mat(y, x)
                        cur_mat(y, x) = last_mat(y, x);
                    end
                end
            end
        end
        last_mat = cur_mat;
    end
    mat = last_mat;
end

