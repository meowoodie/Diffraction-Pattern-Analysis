function [ rearranged_mat ] = rearrange( mats, ring_masks, sector_masks, ...
                                         x_range, y_range) 
                                         % In order to speed up the
                                         % computation, we only compute the
                                         % elements in the specific range.
% REARRANGE 
% It would convert each of the 2d matrixs in mats to a new matrix according
% to the polar coordinate. It would return the rearranged 3d matrix with
% shape ([rings_num, sec_num, mat_num])
% - mats: a 3d matrix
% - ring_masks: a set of ring masks
% - sector_masks: a set of sector masks
    
    mat_num   = length(mats(1,1,:));
    rings_num = length(ring_masks(1,1,:));
    sec_num   = length(sector_masks(1,1,:));
    
    % Preliminary for masks
    % For the purpose of speeding up the whole process, it would calculate
    % the final mask (ring_mask * sector_mask) for each element of the 
    % rearranged matrix in ahead.
    fprintf('Preparing the masks ...\n');
    mat_width  = size(mats, 1);
    mat_height = size(mats, 2);
    mask_mat = zeros(mat_width, mat_height, rings_num, sec_num);
    for i = 1:rings_num
        for j = 1:sec_num
            mask_mat(:,:,i,j) = ring_masks(:,:,i) .* sector_masks(:,:,j);
        end
    end
    
    fprintf('Rearranging the images ...\n');
    rearranged_mat = zeros([rings_num, sec_num, mat_num]);
    % For each of the matrixs
    for k = 1:mat_num
        fprintf('Processing matrix %d\n', k);
        % For each of the rings
        for i = 1:rings_num
            for j = 1:sec_num
                unit_area = mats(y_range(1):y_range(2), ...
                                 x_range(1):x_range(2),k) .* ...
                            mask_mat(y_range(1):y_range(2), ...
                                     x_range(1):x_range(2),i,j);
                % unit_area = mats(:,:,k) .* mask_mat(:,:,i,j);
                %             ring_masks(:,:,i) .* sector_masks(:,:,j);
                rearranged_mat(i,j,k) = sum(unit_area(:)) / ...
                                        length(find(mask_mat( ...
                                           y_range(1):y_range(2), ...
                                           x_range(1):x_range(2),i,j)));
                                        % valid value in unit area includes
                                        % 0, so it uses mask_mat to count
                                        % the number of valid values.                      
            end
        end
    end
    
%     % Calculate the distances between the list of the screened pixels and the 
%     % center of the ring
%     dist_screened2center = pdist2( ...
%         screened_m(:, 1:2), ... % The list of the locations of the screened pixels
%         [center_x, center_y], ... % The location of the center of the ring
%         'euclidean'); % The type of the distance

%     figure; imshow(new_mat); imcontrast(gca);
    
end

