function plot_mat( mats, res_dir, file_prefix )
%PLOT_MAT Summary of this function goes here
%   Detailed explanation goes here

    len = size(mats, 3);
    for i=1:len
        fprintf('Plotting %d mat ...\n', i);
        gray_pixels = mat2gray(mats(:,:,i));
        J = imadjust(gray_pixels, [0, 1]);
        img_path = sprintf('%s/re_mat.%s.%d.png', res_dir, file_prefix, i);
        imwrite(J, img_path);
    end
end

