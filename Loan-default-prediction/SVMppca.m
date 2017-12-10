clear all; close all;
addpath('/Users/gerauddaspremont/MathWorks/libsvm-3.17/matlab');
addpath('/Users/gerauddaspremont/Dropbox/cw2 (1)');
addpath('/Users/gerauddaspremont/MathWorks/ppca_missingdata');
addpath(genpath('/Users/gerauddaspremont/MathWorks/drtoolbox'));

load('reconstructed_PCA_Train.mat');
load('LABELS.mat');

% Set = reconstructed_matrix(:,1:end-1);
% 
% 
% [Set, S, V] = fsvd(Set,700,2);
G = Set;
% Find all data above benchmarck
bench = 50;
plop = find(labels>bench);
addMatSet = G(plop(1:round(0.85*length(plop))),:);
addMatLabel = labels(plop(1:round(0.85*length(plop))));

smallordering = randperm(length(G));
% percentage data we are using
perc = 0.1;
plop = round(perc * length(G));
G = G(smallordering(1:plop),:);

% Divide Train and Test
ordering = randperm(length(G));
labels = labels(ordering);

% change labels
addMatLabel(addMatLabel<bench) = 0;
addMatLabel(addMatLabel>0) = 1;
newlabels = labels;
newlabels(labels<bench) = 0;
newlabels(labels>0)=1;

% dividing
Set = G(ordering,:);
sizeT = round(0.85*length(G));
TrainSet = Set(1:sizeT,:);
TrainLabels = newlabels(1:sizeT);
TestSet = Set(sizeT+1:end,:);
TestLabels = newlabels(sizeT+1:end);
TrueTestLabels = labels(sizeT+1:end);

ToDelete = find(TrainLabels == 0);
perc = 0.1;
plop = round(perc*length(ToDelete));
TrainLabels(ToDelete(1:plop)) = [];
TrainSet(ToDelete(1:plop),:) = [];

% Add the positive examples to the training
TrainSet = [TrainSet; addMatSet];
TrainLabels = [TrainLabels; addMatLabel];

% Train SVM
param.s = 2; 					% epsilon SVR
param.C = max(labels) - min(labels);	% FIX C based on Equation 9.61
param.t = 3; 					% RBF kernel
param.g = 2.^-4;				% gamma parameter
param.e = 5;        % epsilon parameter
param.d = 5;        % degree of polynom
param.r = 1.005e-04^(1/5);   %-1000;        % coef0

param.libsvm = ['-s ', num2str(param.s), ' -t ', num2str(param.t), ...
    ' -c ', num2str(param.C), ' -g ', num2str(param.g), ...
    ' -p ', num2str(param.e),' -d ', num2str(param.d),' -r ', num2str(param.r) ...
    ];

model = svmtrain(TrainLabels, TrainSet, param.libsvm);

[prediction, Accuracy, Decision] = svmpredict(TestLabels, TestSet, model);

% double check

Acc = sum((TestLabels - prediction).^2);

fprintf('The accuracy is: %d\n', Acc);


res = [TestLabels(TestLabels==1), prediction(TestLabels == 1)];
TP = (nnz(prediction(TestLabels == 1) == TestLabels(TestLabels==1))/nnz(TestLabels==1))*100;
FN = (nnz(prediction(TestLabels == 0) ~= (TestLabels(TestLabels==0)-1))/nnz(TestLabels==0))*100;

fprintf('\nTrue Positive: %2.1f\nFalse Negative: %2.1f\n', TP, FN);
fprintf('\nTrain\nNumber of defaults: %i\nNumber of non-default: %i\n',nnz(TrainLabels==1),nnz(TrainLabels==0));
fprintf('\nTest\nNumber of defaults: %i\nNumber of non-default: %i\n',nnz(TestLabels==1),nnz(TestLabels==0));

fprintf('\nTrue FN: %2.1f\n', (nnz(prediction(TrueTestLabels == 0) == TrueTestLabels(TrueTestLabels==0)+1)/nnz(TrueTestLabels==0))*100);

