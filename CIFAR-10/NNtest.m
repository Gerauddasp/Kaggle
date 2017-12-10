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
BigTrain = cat(3,Train2,Train3);


trainend = 90000;


label=load('Labels.mat');
label = label(1).labels;
BigLabel = cat(1,label,label);

train_x = double(BigTrain(:,:,1:trainend))/255;
train_y = double(BigLabel(1:trainend,:)');
test_x = double(BigTrain(:,:,trainend+1:end))/255;
test_y = double(BigLabel(trainend+1:end,:)');

%%  ex2: Using 100-50 hidden units, learn to recognize handwritten digits
nn = nnsetup([1024 60 30 10]);

nn.lambda = 1e-5;       %  L2 weight decay
nn.alpha  = 1e-0;       %  Learning rate
opts.numepochs =  10;   %  Number of full sweeps through data
opts.batchsize = 100;   %  Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
disp([num2str(er * 100) '% error']);
figure; visualize(nn.W{1}', 1)   %Visualize the weights