% logistic regression on features 527 & 528
clear all;
load('Labels');
load('train_reconstructed_matrix_NonCVX2.mat');

Set = reconstructed_matrix(:,[527,528]);
labels(labels>0) = 1;

% take the one that has defaults:
addMatX = Set(labels == 1,:);
addMatY = labels(labels==1);

% part of data we use:
perc= 0.1;
part=round(perc*length(Set));
Set = Set(1:part,:);

shuffle = randperm(length(Set));
N = round(0.85*length(Set));
TrainX = Set(shuffle(1:N),:);
TrainX = [TrainX ; addMatX];
TrainY = labels(shuffle(1:N));
TrainY = [TrainY; addMatY];
TrainY = TrainY + 1;
TestX = Set(shuffle(N+1:end),:);
TestY = labels(shuffle(N+1:end));
TestY = TestY+1;

display('Start mrnfit')
B = mnrfit(TrainX,TrainY,'model','hierarchical','link','probit');

display('Start eval')
pihat = mnrval(B, TestX);

[zob, res] = max(pihat,[],2);

error = sum((res-TestY).^2)/length(TestY)