function [img1] = myImageFilter(img0, h)

[m, n] = size(img0); % find dimensions of image
[k, l] = size(h); % find dimensions of convolution filter
img1 = zeros(m, n); % initialize output image with zeros

% take care of boundary problem by replicating elements 
padded_img0 = padarray(img0, [(k-1)/2, (l-1)/2], 'replicate');
h_conv = zeros(k,k); % create convolution filter by flipping vertically and horizontally

for i = 1:k
    for j = 1:k
        h_conv(i,j) = h(k+1-i, k+1-j); % k is max dimension of filter
    end
end

for i = 1:m
    for j = 1:n
        storage_term = (double(padded_img0(i:i+k-1, j:j+l-1))).*h_conv; % type cast for image
        img1(i, j) = sum(storage_term(:)); % sum for convolution
    end
end
    
end
