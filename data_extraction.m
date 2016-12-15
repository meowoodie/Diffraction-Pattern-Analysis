%% Add lib path
addpath(genpath('reader/'));
addpath(genpath('preproc/'));

%% Read data and other preliminary work
topDir = '/Users/woodie/Desktop/Georgia-Tech-ISyE-Intern/ITO_D10_patterns1';
minuteRange = 0:1;
secondRange = 0:1;
% Read data from DM4 file folder
[stack3D,xv,yv] = K2importDM4(topDir, minuteRange, secondRange);
% Check the result dir, if it didn't exist, then create it.
resDir = '/Users/woodie/Desktop/Georgia-Tech-ISyE-Intern/IT0_D10_res';
if ~exist(resDir, 'dir')
    mkdir(resDir);
end

%% Preprocessing 
% Init parameter
shape  = [1024, 1024];
center = [525 520];
radius_range = [60, 100];
ring_width   = 4;
angle_step   = 3;

[ring_masks, sector_masks, rearranged_mat] = ...
    rearrange(stack3D, center, radius_range, ...
              ring_width, angle_step);
% Save the results
save('rearranged.mat', 'rearranged_mat');


