Centers = load('CentersWithSift.mat');
Centers = Centers.Centers;

for i=1:300000
    imagename = strcat('test/','%d.png');
    image = imread(sprintf(imagename,i));
    image = siftForSmall(image);
    image = double(image);
    D = pdist2(Centers,image);
    [zob I] = min(D);
end
    