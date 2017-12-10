% HOC

for i=1:50000
    imagename = strcat('test/','%d.png');
    image = imread(sprintf(imagename,i));
    Train(i,:) = extractHOGFeatures(image);
end