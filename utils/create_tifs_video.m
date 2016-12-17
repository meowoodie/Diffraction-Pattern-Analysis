% Define the working directory where the images store.
workingDir = '/Users/woodie/Desktop/IT0_D10_rearranged_res';
% Define the file name of output video.
videoName = 'IT0_D10_patterns1_rearranged';
% Locate the directory of the image files.
imageNames = dir(fullfile(workingDir, '*.png'));
imageNames = {imageNames.name}';
imageNames = sort_nat(imageNames);
% Create the video instance
outputVideo = VideoWriter(fullfile(workingDir, videoName));
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,imageNames{ii}));
   writeVideo(outputVideo,img)
end