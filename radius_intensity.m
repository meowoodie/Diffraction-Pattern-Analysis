clear all;
close all;
clc;

%% Add lib path

addpath(genpath('reader/'));
addpath(genpath('preproc/'));
addpath(genpath('utils/'));

%% Read data and other preliminary work

top_dir = '/Users/woodie/Desktop/ISyE/data/ITO_D10_patterns1';
minuteRange = 0:1;
secondRange = 0:59;

% Read data from DM4 file folder
[stack3D,xv,yv] = K2importDM4(top_dir, minuteRange, secondRange);
mats = stack3D(:,:,1:1500);

% Check the result dir, if it didn't exist, then create it.
res_dir = '/Users/woodie/Desktop/IT0_D10_rearranged_res';
if ~exist(res_dir, 'dir')
    mkdir(res_dir);
end

% Init parameter
shape  = [1024, 1024];
center = [525 520];
radius_range = [0, 500];
ring_width   = 2;
angle_step   = 360;

%% Create new masks
 
[ring_masks, sector_masks] = ...
    masks(shape, center, ...
          radius_range, ring_width, ... % Ring masks paras
          angle_step);                  % Sector masks para

%% Get the radius-intensity matrix for each of the frame

mats_size  = 500; % size(mats, 3);
masks_size = size(ring_masks, 3);
radius_intensity_mat = ones(mats_size, masks_size);
for i=1:mats_size
    for j=1:masks_size
        fprintf('Processing %d mat and %d ring\n', i, j);
        ring = mats(:,:,i) .* ring_masks(:,:,j);
        radius_intensity_mat(i,j) = mean(ring(:));
    end
end
mean_r_i = mean(radius_intensity_mat);
x_axis   = 0:2:500;

figure; 
plot(x_axis, mean_r_i); 
xlabel('Radius (pixels)'); 
ylabel('Average Intensity');
% figure; imshow(ring_masks());