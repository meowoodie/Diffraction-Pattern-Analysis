function [ ring_masks, sector_masks] = ...
    masks( shape, center, rings_range, ring_width, angle_step )
% MASKS 
% It would generate two types of masks, one for ring-shaped region, the
% other one for sector-shaped region.
% - mats: a 3d matrix
% - center: the location of the center of the polar coordinate
% - rings_range:

    % Init basic parameters
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

    % Create sector masks for each of the sectors
    fprintf('Creating the masks for each of the sectors ...\n');
    for i = 1:sec_num
        fprintf('Creating the masks, angles ranges from %f to %f\n', ...
            start_angs(i), end_angs(i));
        cur_s_mask = crop_sector(shape, center_x, center_y, ...
                                 start_angs(i), end_angs(i));
        sector_masks = cat(3, sector_masks, cur_s_mask);
    end
end