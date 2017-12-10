% Deep CNN
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

BigTrain = Train(:,:,1:80000);
BigTest = Train(:,:,80001:90000);

trainend = 90000;


label=load('Labels.mat');
label = label(1).labels;

BigLabeltrain = cat(1,label(1:40000,:),label(1:40000,:));
BigLabeltest = label(40001:end,:);

train_x = double(BigTrain);
train_y = double(BigLabeltrain');
test_x = double(BigTest);
test_y = double(BigLabeltest');

%% ex1 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

cnn.layers = {
    struct('type', 'i') %input layer
%     struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
%     struct('type', 's', 'scale', 2) %subsampling layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer    
};
cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 5;

cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
plot(cnn.rL);
%show test error
disp([num2str(er*100) '% error']);