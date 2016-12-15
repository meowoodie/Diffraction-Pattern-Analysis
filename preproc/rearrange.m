function [ ring_masks, sector_masks, rearranged_mat ] = ...
    rearrange( mats, center, rings_range, ...
               ring_width, angle_step )
% REARRANGE 
% It would convert each of the 2d matrixs in mats to a new matrix according
% to the polar coordinate. It would return the ring masks and the sector
% masks which are used to rearrange the zones. 
% - mats: a 3d matrix
% - center: the location of the center of the polar coordinate
% - rings_range: 

    % Init basic parameters
    shape    = size(mats(:,:,1)); % The shape of a 2d matrix
    center_x = center(1);
    center_y = center(2);
    max_radius = rings_range(2);
    min_radius = rings_range(1);
    
    % Cropping parameters
    rings_num  = (max_radius-min_radius)/ring_width;
    sec_num    = 360/angle_step;
    inner_rads = linspace(min_radius, max_radius-ring_width, rings_num);
    outer_rads = linspace(min_radius+ring_width, max_radius, rings_num);
    start_angs = linspace(-180, 180-angle_step, sec_num);
    end_angs   = linspace(-180+angle_step, 180, sec_num);
    
    % Init the list of the masks
    ring_masks   = [];
    sector_masks = [];
    % Create rings masks for each of the rings
    fprintf('Creating the masks for each of the rings ...\n');
    for i = 1:rings_num
        fprintf('Creating the masks, radius ranges from %f to %f\n', ...
            inner_rads(i), outer_rads(i));
        cur_r_mask = crop_ring(shape, center_x, center_y, ...
                               outer_rads(i), inner_rads(i));
        ring_masks = cat(3, ring_masks, cur_r_mask);
    end
    fprintf('Creating the masks for each of the sectors ...\n');
    % Create sector masks for each of the sectors
    for i = 1:sec_num
        fprintf('Creating the masks, angles ranges from %f to %f\n', ...
            start_angs(i), end_angs(i));
        cur_s_mask = crop_sector(shape, center_x, center_y, ...
                                 start_angs(i), end_angs(i));
        sector_masks = cat(3, sector_masks, cur_s_mask);
    end
    
    fprintf('Rearranging the images ...\n');
    rearranged_mat = zeros([rings_num, sec_num, length(mats(1,1,:))]);
    % For each of the matrixs
    for k = 1:length(mats(1,1,:))
        fprintf('Processing matrix %d\n', k);
        % For each of the rings
        for i = 1:rings_num
            for j = 1:sec_num
                unit_area = mats(k) .* ...
                            ring_masks(:,:,i) .* sector_masks(:,:,j);
                rearranged_mat(i,j,k) = sum(unit_area(:)) / ...
                                        length(find(unit_area));
            end
        end
    end
    
%     % Calculate the distances between the list of the screened pixels and the 
%     % center of the ring
%     dist_screened2center = pdist2( ...
%         screened_m(:, 1:2), ... % The list of the locations of the screened pixels
%         [center_x, center_y], ... % The location of the center of the ring
%         'euclidean'); % The type of the distance


    %     fprintf('max: %f\tmin %f\n', max(mat(:)), min(mat(:)));
    %     
    %     % visualization
    %     gray_pixels = mat2gray(mat);
    %     J = imadjust(gray_pixels, [0, 0.1]);
    %     img_path = sprintf('%s/realval_%d.png', resDir, i);
    %     imwrite(J, img_path);

%     figure; imshow(new_mat); imcontrast(gca);
    %     break;

end

