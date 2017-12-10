% function Project3
clear all;
display('loading...');
tic
load('VectorsForSparse');

display('done');
display('Creating matrices...');

%TrainLabels = sparse(hil,hjl,hsl);
TrainSet = sparse(hif,hjf,hsf);
display('done');
toc

clear hil hjl hsl ;


nt = sum(spones(TrainSet))+1;
n = size(TrainSet,1);

idft = log(n ./ nt);

% matrix of precalculated results
%results = zeros(max(max(TrainSet)), size(idft,2),'single');
% Create a vector containing the log of every number between 1 and 1700
logvals = single( log(1:max(max(TrainSet))+1) );
MaxTrain = max(max(TrainSet)) + 1;
clear TrainSet;
% The first loop should take around 160 s...
% display('Precalculating all values...');
% tic
% for row=1:MaxTrain
%     results(row,:) = logvals(row)*idft;
%     if rem(row,5)==0
%         display(row)
%     end
% end
% toc
% display('done');

% The second loop should take around 80 mins...
display('Filling matrix...');
tic
hnewf = hsf;

for ind =1: size(hsf)
    hnewf(ind) = logvals(hsf(ind)+1) * idft(hjf(ind));
    %hnewf(ind) = results(hsf(ind)+1,hjf(ind)); 
    if rem(ind,1e7) == 0
        display(ind)
        toc
    end
end
toc
display('done');

TFIDF = sparse(hif,hjf,hnewf);