%% Add lib path

addpath(genpath('reader/'));
addpath(genpath('preproc/'));
addpath(genpath('utils/'));

%% Read data and other preliminary work

top_dir = '/Users/woodie/Desktop/Georgia-Tech-ISyE-Intern/data/ITO_D10_patterns1';
minuteRange = 0:1;
secondRange = 0:59;

% Read data from DM4 file folder
[stack3D,xv,yv] = K2importDM4(top_dir, minuteRange, secondRange);

% Check the result dir, if it didn't exist, then create it.
res_dir = '/Users/woodie/Desktop/IT0_D10_rearranged_res';
if ~exist(res_dir, 'dir')
    mkdir(res_dir);
end

% Init parameter
shape  = [1024, 1024];
center = [525 520];
radius_range = [50, 100];
ring_width   = 1;
angle_step   = 3;

%% Create new masks
 
[ring_masks, sector_masks] = ...
    masks(shape, center, ...
          radius_range, ring_width, ... % Ring masks paras
          angle_step);                  % Sector masks para

% Save the masks
saved_mask_name = sprintf('mask.rad%d-%d.rw%d.as%d.%s.mat', ...
                          radius_range(1), radius_range(2), ...
                          ring_width, angle_step, date);
save(saved_mask_name, 'ring_masks', 'sector_masks');
          
%% Load saved masks

% saved_mask_name = 'mask.rad30-100.rw1.as3.28-Dec-2016.mat'; % CHECK IT EVERY TIME YOU RUN IT!
% vars = load(saved_mask_name);
% ring_masks   = vars.ring_masks;
% sector_masks = vars.sector_masks;

%% Rearrange the matrix

rearranged_mat = rearrange(stack3D(:,:,1:1500), ...
                           ring_masks, sector_masks);

% Plot the results
file_prefix = 'all'; % CHECK IT EVERY TIME YOU RUN IT!
plot_mat(rearranged_mat, res_dir, file_prefix);

% Save the results
saved_file_name = sprintf('%s.rearr.mat', date);
save(saved_file_name, 'rearranged_mat');