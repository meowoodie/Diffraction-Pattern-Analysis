function [ rearranged_mat ] = rearrange( mats, ring_masks, sector_masks)                                         
% REARRANGE 
% It would convert each of the 2d matrixs in mats to a new matrix according
% to the polar coordinate. It would return the rearranged 3d matrix with
% shape ([rings_num, sec_num, mat_num])
% In order to speed up the computation, we only compute the elements in the
% specific range.
% - mats: a 3d matrix
% - ring_masks: a set of ring masks
% - sector_masks: a set of sector masks
    
    % Basic configuration
    sub_mask_wid = 5;

    mat_num   = size(mats, 3);         % length(mats(1,1,:));
    rings_num = size(ring_masks, 3);   % length(ring_masks(1,1,:));
    sec_num   = size(sector_masks, 3); % length(sector_masks(1,1,:));
    
    % Preliminary for masks
    % For the purpose of speeding up the whole process, it would calculate
    % the final mask (ring_mask * sector_mask) for each element of the 
    % rearranged matrix in ahead.
    fprintf('Doing preliminary computation in ahead ...\n');
    mat_y = size(mats, 1);
    mat_x = size(mats, 2);
    mask_mat = zeros([mat_y, mat_x, rings_num, sec_num]);
    x_range  = zeros([2, rings_num, sec_num]);
    y_range  = zeros([2, rings_num, sec_num]);
    num_valid_eles = zeros([rings_num, sec_num]);
    for i = 1:rings_num
        for j = 1:sec_num
            fprintf('%d ring %d sector ...\n', i, j);
            % Preparing the mask
            mask_mat(:,:,i,j) = ring_masks(:,:,i) .* sector_masks(:,:,j);
            % Preparing the range of the sub mask
            % Calculate the center of the valid elememts in the sub mask
            [ys, xs] = find(mask_mat(:,:,i,j));
            avg_x = int16(mean(xs)); avg_y = int16(mean(ys));
            x_range(:,i,j) = [avg_x-sub_mask_wid avg_x+sub_mask_wid]; 
            y_range(:,i,j) = [avg_y-sub_mask_wid avg_y+sub_mask_wid];
            % Calculate the number of the valid elements in the mask
            num_valid_eles(i,j) = length(find(mask_mat( ...
                                  y_range(1,i,j):y_range(2,i,j), ...
                                  x_range(1,i,j):x_range(2,i,j),i,j)));
            if num_valid_eles(i,j) ~= length(ys) || ...
               num_valid_eles(i,j) ~= length(xs)
                error('Error! The width of the sub mask is too small.');
            end
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
                % Do multiplication
                unit_area = mats(y_range(1,i,j):y_range(2,i,j), ...
                                 x_range(1,i,j):x_range(2,i,j),k) .* ...
                            mask_mat(y_range(1,i,j):y_range(2,i,j), ...
                                     x_range(1,i,j):x_range(2,i,j),i,j);
                % unit_area = mats(:,:,k) .* mask_mat(:,:,i,j);
                
                % Average the sum of the value of the valid elements
                rearranged_mat(i,j,k) = sum(unit_area(:)) / ...
                                        num_valid_eles(i,j);
                                        % valid value in unit area includes
                                        % 0, so it uses mask_mat to count
                                        % the number of valid values. 
            end
        end
    end
    
%     % For debugging
%     i = 13; j = 10; k = 1;
%     % Do multiplication
%     unit_area = mats(y_range(1,i,j):y_range(2,i,j), ...
%                      x_range(1,i,j):x_range(2,i,j),k) .* ...
%                 mask_mat(y_range(1,i,j):y_range(2,i,j), ...
%                          x_range(1,i,j):x_range(2,i,j),i,j);
%     figure; imshow(mask_mat(y_range(1,i,j):y_range(2,i,j), ...
%                             x_range(1,i,j):x_range(2,i,j),i,j));
%     figure; imshow(mats(y_range(1,i,j):y_range(2,i,j), ...
%                         x_range(1,i,j):x_range(2,i,j),k));imcontrast(gca);
%     figure; imshow(unit_area);imcontrast(gca);
%     disp(sum(unit_area(:)));
%     disp(x_range(:,i,j));
                          
%     % Calculate the distances between the list of the screened pixels and the 
%     % center of the ring
%     dist_screened2center = pdist2( ...
%         screened_m(:, 1:2), ... % The list of the locations of the screened pixels
%         [center_x, center_y], ... % The location of the center of the ring
%         'euclidean'); % The type of the distance

%     figure; imshow(new_mat); imcontrast(gca);
    
end

