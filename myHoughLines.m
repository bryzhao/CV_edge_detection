function [rhos, thetas] = myHoughLines(H, nLines)

rhos = zeros(nLines, 1); % contain rho parameters for lines found in image (indices)
thetas = zeros(nLines, 1); % contain theta parameters for lines found in image (indices)
H_nms = H; % create copy of accumulator for non-maximal suppression
H_padded= padarray(H_nms, [1, 1], 'replicate'); % take care of boundary problem for NMS by padding with boundary replicates
[rows, cols] = size(H_nms); % size of hough accumulator
%% implement non-maximal suppression
for i = 2:rows-1 % to account for padding
    for j = 2:cols-1
        if any(find((H_padded(i-1:i+1, j-1:j+1) > H_padded(i,j)))) > 0 % if any of the neighbors are greater than center pixel
            H_nms(i-1,j-1) = 0; % non-maximal suppression
        end
    end
end
%% find peaks in hough accumulator
for i = 1:nLines
    maxIdx = max(H_nms(:)); % highest score
    [rhoMaxIdx, thetaMaxIdx] = find(H_nms==maxIdx);
    rhos(i) = rhoMaxIdx(1); % add - 1 term to account for padding an extra row and column (3 by 3 filter)
    thetas(i) = thetaMaxIdx(1);
    H_nms(rhoMaxIdx(1), thetaMaxIdx(1)) = 0; % clear the highest scoring cell, then move on
end


end % end of function!
        