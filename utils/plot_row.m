function plot_row( mat, res_dir, file_prefix )
%PLOT_ROW Summary of this function goes here
%   Detailed explanation goes here
    
    len = size(mat, 2);
    for i=1:len
        fprintf('Plotting %d row ...\n', i);
        f = figure('Visible','off');
        x_axis = linspace(-180, 180, size(mat, 1));
        plot(x_axis, mat(:,i), 'r');
        t = sprintf('T=%d', i);
        title(t);
        xlabel('Angle (degree)'); 
        ylabel('lightness'); 
        myboldify(f);
        img_path = sprintf('%s/%s.%d.png', res_dir, file_prefix, i);
        saveas(f, img_path);
    end
    
end

