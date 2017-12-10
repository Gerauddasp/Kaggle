function [d] = siftForSmall(image)
%Calcuate 4 frames and the dexriptors for our small images:
% Input: Image
%   Output: the four descriptors.
image = single(rgb2gray(image));
fc = [8,8,24,24;...
    8,24,8,24;...
    5,5,5,5;...
    0,0,0,0];
[f,d] = vl_sift(image, 'frames', fc);
d = d(:)';
end

