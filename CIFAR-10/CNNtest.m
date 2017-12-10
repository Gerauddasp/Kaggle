clear all; close all; clc;

addpath('/Users/gerauddaspremont/MathWorks/rasmusbergpalm_DeepLearnToolbox_45ef96c/rasmusbergpalm-DeepLearnToolbox-45ef96c/CNN');
addpath('/Users/gerauddaspremont/MathWorks/rasmusbergpalm_DeepLearnToolbox_45ef96c/rasmusbergpalm-DeepLearnToolbox-45ef96c/data');
addpath('/Users/gerauddaspremont/MathWorks/rasmusbergpalm_DeepLearnToolbox_45ef96c/rasmusbergpalm-DeepLearnToolbox-45ef96c/util');
%load mnist_uint8;

train=load('ImagesCell.mat');
train = train(1).Images;
for i=1:length(train)
    Train2(:,:,i)= rgb2gray(train{i});
end

for i=1:size(Train2,3)
    Train3(:,:,i) = flipdim(Train2(:,:,i),2);
end

Train = cat(3,Train2, Train3);
av = mean(Train, 3);

for i = 1:size(Train);
    Train(:,:,i) = double(Train(:,:,i)) - av;
end


label=load('Labels.mat');
label = label(1).labels;
label=cat(1,label,label);

train_x = double(Train);
train_y = double(label');


%% ex1 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = ;

cnn = cnntrain(cnn, train_x, train_y, opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for Aaron: import your cnn structure and also addpath to all functions of
% the toolbox.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here I loop to write the CSV file
FileID = fopen('Submit.csv','w');
fprintf(FileID,'%s,%s\n','id','label');
for i=1:50000:300000
        name = strcat('test/','%d.png');
        Images=imread(sprintf(name,(i+j)-1));
        Images = rgb2gray(Images);
        test_x(:,:,j) = double(Images);
end
    
    for j=1:50000
        test_x(:,:,j) = test_x(:,:,j) - av;
    end
        
    
    net = cnnff(cnn, test_x);
    [~, I] = max(net.o);
    
    for j=1:50000
        z = (i+j)-1;
        switch I(j)
            case 1
                fprintf(FileID,'%d,%s\n',z,'airplane');
            case 2
                fprintf(FileID,'%d,%s\n',z,'automobile');
            case 3
                fprintf(FileID,'%d,%s\n',z,'bird');
            case 4
                fprintf(FileID,'%d,%s\n',z,'cat');
            case 5
                fprintf(FileID,'%d,%s\n',z,'deer');
            case 6
                fprintf(FileID,'%d,%s\n',z,'dog');
            case 7
                fprintf(FileID,'%d,%s\n',z,'frog');
            case 8
                fprintf(FileID,'%d,%s\n',z,'horse');
            case 9
                fprintf(FileID,'%d,%s\n',z,'ship');
            case 10
                fprintf(FileID,'%d,%s\n',z,'truck');
        end
    end
end

fclose(FileID);
%[er, bad] = cnntest(cnn, test_x, test_y);


%plot mean squared error
plot(cnn.rL);
%show test error
%disp([num2str(er*100) '% error']);