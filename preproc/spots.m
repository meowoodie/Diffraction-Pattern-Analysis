function [ bright_spots, bright_spots_stat ] = spots(mats, ...
                                                     rad_ind_range, rad_start, ...
                                                     rad_step, ang_step)
%SPOTS Summary of this function goes here
%   Detailed explanation goes here

    %% Extract the bright spots
    bright_spots = [];
    for rad_ind=rad_ind_range        
        % basic configuration
        frame_ts  = 1/25; % second
        dark_thre = 50;
        % extract one row from data
        num_mats  = size(mats, 3);
        len_row   = size(mats, 2);
        rows      = squeeze(mats(rad_ind,:,:));
        % threshold
        uni_set    = rows(:);
        valid_inds = uni_set > dark_thre;
        uni_set    = uni_set(valid_inds);
        pd    = fitdist(uni_set,'Normal');
        mu    = pd.mu;
        sigma = pd.sigma;
        threshold = mu + 3.5 * sigma;
        fprintf('Row: %d\tMean: %f\tStd: %f\tThreshold: %f\n', ...
                rad_ind, mu, sigma, threshold);
        % Binarization        
        for i=1:num_mats
            for j=1:len_row
                if rows(j,i) < threshold
                    rows(j,i) = 0;
                end
            end
        end
%         figure; imshow(rows);

        % Extract bright spots
        % The data structure for one bright spot:
        % 1.radius(ind), 2.angle(ind), 3.start time(ind), 4.end time(ind)
        for ang_ind=1:len_row
            % fprintf('Processing angle %d ...\n', (ang_ind-1)*ang_step-180);
            last_pixel = 0;
            cur_spot   = [-1, -1, -1, -1];
            % Check the duration for every bright spot
            for t_ind=1:num_mats % which is the index for the time
                % fprintf('ang %d\tt %d\tlast %d\tcur %d\n', ang_ind, t_ind, last_pixel, row(ang_ind, t_ind));
                if last_pixel == 0 && rows(ang_ind, t_ind) ~= 0
                    cur_spot = [rad_ind, ang_ind, t_ind, -1];
                elseif last_pixel ~= 0 && rows(ang_ind, t_ind) == 0
                    cur_spot(4) = t_ind;
                    bright_spots = [bright_spots; cur_spot];
                end
                last_pixel = rows(ang_ind, t_ind);
            end
        end
        % % Reconstruct the row matrix by bright_spots
        % recon_row = zeros(size(row));
        % for i=1:size(bright_spots, 1)
        %     ang_ind     = bright_spots(i, 2);
        %     start_t_ind = bright_spots(i, 3);
        %     end_t_ind   = bright_spots(i, 4);
        %     recon_row(ang_ind, start_t_ind:end_t_ind) = 1;
        % end 
        % figure; imshow(recon_row);
    end

    %% Calculate other attributes for each of the bright spots

    % The data structure for the attributes of one bright spot:
    % 1. radius, 2. angle, 3. duration, 4. frequency, 5. average lightness
    len_spots = size(bright_spots, 1);
    bright_spots_stat = zeros(5, len_spots);
    for i=1:len_spots
        % Radius
        bright_spots_stat(1, i) = (bright_spots(i, 1) - 1) * rad_step + rad_start;
        % Angle
        bright_spots_stat(2, i) = (bright_spots(i, 2) - 1) * ang_step - 180;
        % Duration
        bright_spots_stat(3, i) = (bright_spots(i, 4) - bright_spots(i, 3)) * frame_ts;
        % Frequency
        bright_spots_stat(4, i) = 1 / bright_spots_stat(3, i);
        % Average Lightness
        bright_spots_stat(5, i) = mean( ...
            rows(bright_spots(i, 2), bright_spots(i, 3):bright_spots(i, 4)));
    end
    bright_spots = bright_spots';
end

