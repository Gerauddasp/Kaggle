clear all; close all;
run('VLFEATROOT/toolbox/vl_setup');
ndata = 50000;

for i=1:ndata
    name = strcat('train/','%d.png');
    image = imread(sprintf(name,i));
    TrainSet(i,:) = siftForSmall(image);
end
