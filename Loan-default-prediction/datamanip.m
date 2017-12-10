clear all; close all;
addpath('/Users/gerauddaspremont/MathWorks/libsvm-3.17/matlab');
addpath('/Users/gerauddaspremont/Dropbox/cw2 (1)');
addpath('/Users/gerauddaspremont/MathWorks/ppca_missingdata');
addpath(genpath('/Users/gerauddaspremont/MathWorks/drtoolbox'));
% load the data
Set =load('test_dataDouble.mat');
display('Data loaded');

% Build Training and testing set
Set = Set.data_points;

l = 0;
% Removing colums with 0 std
for i=1:size(Set,2)
    TempVec = Set(:,i);
    I = find(TempVec==-4321);
    TempVec(I) = [];
    test = std(TempVec);
    TempVecNorm = (TempVec - mean(TempVec))/test;
    %TempVecNorm = TempVecNorm / norm(TempVEcNorm);
    sel = ones(length(Set),1);
    sel(I,1) = 0;
    sel = logical(sel);
    Set(sel,i) = TempVecNorm;
    if test == 0
        l = l+1;
        ToDelete(l) = i;
    end
end
Set(:,ToDelete) = [];

Train = Set(:,2:(end-1));
%Test = Set(:,end);

Train(Train == -4321) = NaN;
%Train = Train(1:500,:);

disp('Start PPCA')
tic
%[coeff,score,pcvar,mu] = ppca(Train,700);
options.numemloops = 5;
options.plot = 1;
init = [];
[E,lambda,b,sigma2,proj,L,G]=pPCA(Train,700,options,init);
mapped_data = G * proj;
%mapped_data = compute_mapping(Train, 'ProbPCA',700, 10);
display('Total time for PCA:')
toc



 


