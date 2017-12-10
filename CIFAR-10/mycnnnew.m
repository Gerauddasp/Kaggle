clear all; close all; clc;

addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/DBN')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/CNN')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/util')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/CAE')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/data')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/NN')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/SAE')
addpath('/Users/Aaron/Documents/MATLAB/rasmusbergpalm_DeepLearnToolbox_45ef96cGIT/rasmusbergpalm-DeepLearnToolbox-45ef96c/tests')

% addpath('../data');
% load mnist_uint8;

load 'labelsflip.mat'


load 'Trainmeanflipnoorder.mat'

% not divided by 255
train_x = double(Trainmeanflipnoorder(:,:,1:80000));
test_x = double(Trainmeanflipnoorder(:,:,80001:end));
train_y = double(labelsflip(1:80000,:)');
test_y = double(labelsflip(80001:end,:)');

% train_x = double(Trainmeancent(:,:,1:25000))/255;
% test_x = double(Trainmeancent(:,:,25001:end))/255;
% train_y = double(labels(1:25000,:)');
% test_y = double(labels(25001:end,:)');

% load 'Traincnn.mat'
% 
% train_x = double(Train(:,:,1:25000))/255;
% test_x = double(Train(:,:,25001:end))/255;
% train_y = double(labels(1:25000,:)');
% test_y = double(labels(25001:end,:)');

%% ex1 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

cnn.layers = {
    struct('type', 'i') %input layer
%     struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
%     struct('type', 's', 'scale', 2) %sub sampling layer
    % included one extra
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1; % WAS 1
opts.batchsize = 50; % WAS 50
opts.numepochs = 5;

cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
plot(cnn.rL);
%show test error
disp([num2str(er*100) '% error']);