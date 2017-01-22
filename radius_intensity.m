clear all;
close all;
clc;

%% Add lib path

addpath(genpath('reader/'));
addpath(genpath('preproc/'));
addpath(genpath('utils/'));

%% Read data from ITO

% top_dir = '/Users/woodie/Desktop/ISyE/data/ITO_D10_patterns1';
% minuteRange = 0:1;
% secondRange = 0:59;
% 
% % Read data from DM4 file folder
% [stack3D,xv,yv] = K2importDM4(top_dir, minuteRange, secondRange);
% mats = stack3D(:,:,1:1500);
% 
% % Check the result dir, if it didn't exist, then create it.
% res_dir = '/Users/woodie/Desktop/IT0_D10_rearranged_res';
% if ~exist(res_dir, 'dir')
%     mkdir(res_dir);
% end

% % Init parameter
% shape  = [1024, 1024];
% center = [525 520];
% radius_range = [0, 500];
% ring_width   = 2;
% angle_step   = 360;

%% Read data from tifs images

% Define the working directory where the images store.
workingDir = '/Users/woodie/Desktop/ISyE/material_oldversion/tifs';
% Locate the directory of the image files.
imageNames = dir(fullfile(workingDir, '*.tif'));
imageNames = {imageNames.name}';
imageNames = sort_nat(imageNames);

mats = [];
for i=1:length(imageNames)
    img = imread(fullfile(workingDir, imageNames{i}));
    mats = cat(3, mats, img);
end

% Init parameter
shape  = [512, 512];
center = [275, 249];
radius_range = [0, 200];
ring_width   = 2;
angle_step   = 360;

%% Create new masks
 
[ring_masks, sector_masks] = ...
    masks(shape, center, ...
          radius_range, ring_width, ... % Ring masks paras
          angle_step);                  % Sector masks para

%% Get the radius-intensity matrix for each of the frame

mats_size  = size(mats, 3);
masks_size = size(ring_masks, 3);
radius_intensity_mat = ones(mats_size, masks_size);
for i=1:mats_size
    for j=1:masks_size
        fprintf('Processing %d mat and %d ring\n', i, j);
        ring = int16(mats(:,:,i)) .* int16(ring_masks(:,:,j));
        radius_intensity_mat(i,j) = mean(ring(:));
    end
end
mean_r_i = mean(radius_intensity_mat);
x_axis   = 0:2:198;

figure; 
plot(x_axis, mean_r_i); 
xlabel('Radius (pixels)'); 
ylabel('Average Intensity');
% figure; imshow(ring_masks());