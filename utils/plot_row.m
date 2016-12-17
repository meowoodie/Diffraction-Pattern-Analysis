function plot_row( row )
%PLOT_ROW Summary of this function goes here
%   Detailed explanation goes here

    x_axis = linspace(-180, 180, length(row));
    f = figure;
    plot(x_axis, row, 'r'); xlabel('Angle (degree)'); ylabel('lightness'); 
    myboldify(f);
    
end

