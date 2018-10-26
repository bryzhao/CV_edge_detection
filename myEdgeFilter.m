function [Im, Io, Ix, Iy] = myEdgeFilter(img, sigma)
%% apply gaussian filter and sobel filters

hsize = 2*ceil(3*sigma) + 1; % size of gaussian filter depends on kernel's standard deviation
h_gaussian = fspecial('gaussian', hsize, sigma); % generate gaussian filter
h_xsobel = [-1 0 1; 
            -2 0 2; 
            -1 0 1]; % by definition (S_x)
h_ysobel = [-1 -2 -1; 
            0 0 0; 
            1 2 1]; % (S_y)

smoothed = myImageFilter(img, h_gaussian); % apply gaussian smoothing to image
Ix = myImageFilter(smoothed, h_xsobel); % apply sobel: x-derivative
Iy = myImageFilter(smoothed, h_ysobel); % apply sobel: y-derivative
Io = atan2(Iy, Ix) .* (180/pi); % convert from radian to degrees (easier to understand)
Im = sqrt(Ix.^2 + Iy.^2); % magnitude of gradient
Im_nms = Im; % create copy of gradient image for NMS later on

%% implement non-maximum suppression (NMS) for thin edge detection
% quantizes angles into four brackets: 0, 45, 90, and 135 degrees.

Io(Io<0) = Io(Io<0) + 180; % map all negative values to [0, 180] degrees
[m, n] = size(Io); % loop variables for num rows and cols
for i = 2:m-1
    for j = 2:n-1
        if Io(i,j) < 22.5 || Io(i,j) > 157.5 % quantization
            Io(i,j) = 0;
            if Im(i, j+1) > Im(i,j) || Im(i, j-1) > Im(i,j) % for 0 degrees (east and west)
                Im_nms(i,j) = 0;
            end
        elseif (Io(i,j) >= 22.5 && Io(i,j) < 67.5)
            Io(i,j) = 45;
            if Im(i-1, j+1) > Im(i,j) || Im(i+1, j-1) > Im(i,j) % for 45 degrees (northeast, southwest)
                Im_nms(i,j) = 0;
            end
        elseif (Io(i,j) >= 67.5 && Io(i,j) < 112.5)
            Io(i,j) = 90;
            if Im(i-1, j) > Im(i,j) || Im(i+1, j) > Im(i,j) % for 90 degrees (north and south)
                Im_nms(i,j) = 0;
            end
        elseif (Io(i,j) >= 112.5 && Io(i,j) <= 157.5)
            Io(i,j) = 135;
            if Im(i-1, j-1) > Im(i,j) || Im(i+1, j+1) > Im(i,j) % for 135 degrees (northwest, southeast)
                Im_nms(i,j) = 0;
                % disp('true!');
            end
        else
            % do nothing
        end
    end
end

Im = Im_nms; % output

% %%

% search for nearest 2 neighbors' values along the same orientation, update
% magnitude matrix
% for i = 2:m-1 % range is 2:m-1 since looking at left and right neighbors
%     for j = 2:n-1
%         if Io(i,j) == 0
%             if Im(i, j+1) > Im(i,j) || Im(i, j-1) > Im(i,j)
%                 Im(i,j) = 0;
%             end
%         elseif Io(i,j) == 45
%             if Im(i-1, j+1) > Im(i,j) || Im(i+1, j-1)
%                 Im(i,j) = 0;
%             end
%         elseif Io(i,j) == 90
%             if Im(i-1, j) > Im(i,j) || Im(i+1, j) > Im(i,j)
%                 Im(i,j) = 0;
%             end
%         elseif Io(i,j) == 135
%             if Im(i-1, j-1) > Im(i,j) || Im(i+1, j+1)
%                 Im(i,j) = 0;
%             end
%         end
%     end
% end
