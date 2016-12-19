function plot_row( mat, res_dir, file_prefix )
%PLOT_ROW Summary of this function goes here
%   Detailed explanation goes here
    
    len = size(mat, 2);
    for i=1:len
        fprintf('Plotting %d row ...\n', i);
        f = figure('Visible','off');
        % Create x axis
        x_axis = linspace(-180, 180, size(mat, 1));
        % Plot
        plot(x_axis, mat(:,i), 'r');
        % Set the x,y axis limits
        axis([-180,180,-100,2000]);                                                                                                                                                         
        % Title
        t = sprintf('T=%d', i);
        title(t);
        % X,Y axis labels
        xlabel('Angle (degree)'); 
        ylabel('lightness'); 
        % Format the figure
        myboldify(f);
        % Save the figure
        img_path = sprintf('%s/%s.%d.png', res_dir, file_prefix, i);
        saveas(f, img_path);
    end
    
end

