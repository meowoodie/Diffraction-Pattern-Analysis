%% Add lib path

addpath(genpath('reader/'));
addpath(genpath('preproc/'));
addpath(genpath('utils/'));

%% Load saved rearranged matrix

% basic configuration
rad_ind_range = 1:50;
rad_start = 60;
rad_step  = 2;
ang_step  = 3;

saved_mats_name = '28-Dec-2016.rearr.mat'; % CHECK IT EVERY TIME YOU RUN IT!
vars = load(saved_mats_name);
mats = vars.rearranged_mat;

%% Plotting

% for rad_ind=rad_ind_range
%     prefix  = sprintf('test_row_%d', rad_ind);
%     res_dir = ['/Users/woodie/Desktop/' prefix];
%     if ~exist(res_dir, 'dir')
%         mkdir(res_dir);
%     end
%     plot_row(squeeze(mats(rad_ind,:,:)), res_dir, prefix);
% end

%% Extract spots

[bright_spots, bright_spots_stat] = ...
    spots(mats, rad_ind_range, rad_start, rad_step, ang_step);

saved_file_name = sprintf('%s.spots.mat', date);
save(saved_file_name, 'bright_spots', 'bright_spots_stat');