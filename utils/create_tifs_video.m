% Define the working directory where the images store.
workingDir = '/Users/woodie/Desktop/test_row_35';
% Define the file name of output video.
videoName = 'row_35_over_time';
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