function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
%Im - grayscale image
%threshold - prevents low gradient magnitude points from being included
%rhoRes - resolution of rhos - scalar
%thetaRes - resolution of theta - scalar

% Im(Im < threshold) = 0.0; % apply threshold
[m, n] = size(Im); % for finding max rho
rhoMax = sqrt(m^2 + n^2); % maximum distance possible
thetaRes = thetaRes * (180/pi); % rescale theta resolution to degrees for now

% bins of accumulator for quantization
rhoScale = ceil(-rhoMax):rhoRes:ceil(rhoMax); % (0, rhoMax)
thetaScale = -90:thetaRes:90; %  (-pi/2, pi/2)
rhoLen = numel(rhoScale); % rows in accumulator
thetaLen = numel(thetaScale); % columns in accumulator
H = zeros(rhoLen, thetaLen); % initialize accumulator

[edge_xIdx, edge_yIdx] = find(Im > threshold); % find non-zero indices of edges in image

% populate accumulator
for i = 1:numel(edge_xIdx)
    for thetaIdx = 1:thetaLen % loop through thetaScale
       rhoCurrent = edge_yIdx(i)*cosd(thetaScale(thetaIdx)) + edge_xIdx(i)*sind(thetaScale(thetaIdx));
       rhoCurrent = floor(rhoCurrent/rhoRes) * rhoRes; % quantize to rho's resolution into bins
       thetaCurrent = floor(thetaScale(thetaIdx)/thetaRes) * thetaRes; % quantize to theta's resolution into bins
       thetaBinIdx = find(thetaScale==thetaCurrent); % find quantized indices
       rhoBinIdx = find(rhoScale==rhoCurrent);
       H( rhoBinIdx, thetaBinIdx ) = H( rhoBinIdx, thetaBinIdx ) + 1; % increment element in accumulator
    end
end
% end of accumulator population

thetaScale = thetaScale .* (pi/180); % convert back to radians for output
        
end