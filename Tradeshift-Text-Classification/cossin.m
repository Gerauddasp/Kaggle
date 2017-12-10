clear all;
addpath('/Users/gerauddaspremont/MathWorks/mtimesx_20110223');
display('loading data...')
load('VectorsForSparse');
load('IFIDF');
display('done');

display('building IFIDF')
TFIDF = sparse(hif,hjf,hnewf);
LABELS = sparse(hil, hjl, hsl);
clear hif hil hjf hjl hnewf hsl hsf;
display('done')

% t = templateTree('minleaf',5);
% tic
% knn = fitcknn(TFIDF,LABELS,'NumNeighbors',5,'Distance','cosine');
% toc

SHUFFLE = randperm(size(LABELS,1));

%subdividing Validation and Train Set
LABELS = LABELS(SHUFFLE,:);
TFIDF  = TFIDF(SHUFFLE,:);

selected = zeros(size(LABELS,2),1);
tic
for col=1:size(LABELS,2)
    row = find(LABELS(:,col) ~= 0,1);
    if not(isempty(row))
        selected(col) = row;
    end
end

selected = selected(find(selected~=0));

VALIDATIONLABELS = LABELS(selected,:);
VALIDATION = TFIDF(selected,:);
LABELS(selected,:) = [];
TFIDF(selected,:) =[];

toc
clear selected row SHUFFLE;

display('Start KNN');
% number of knn

k = 70;
NORMTFIDF = sqrt(sum(TFIDF.^2, 2));
COSSIM = zeros( [size(VALIDATION,1),1],'single');
KNNind = zeros([size(VALIDATION,1),k],'single');
KNNval = zeros([size(VALIDATION,1),k],'single');

if matlabpool('size') == 0 
   matlabpool('open',4) ;
end
tic

parfor i=1:100%size(VALIDATION,1)
    if rem(i,1e4) == 0;
        display(i)
        toc
    end
    normdi = norm(VALIDATION(i,:));
    %did = TFIDF*VALIDATION(i,:)';
    did = TFIDF*VALIDATION(i,:)';
    normd = bsxfun(@times,normdi,NORMTFIDF);
    COSSIM = did ./ normd;
    [C, I] = sort(COSSIM,'descend');
    C = full(C(1:k));
    KNNval(i,:) = single(C);
    KNNind(i,:) = I(1:k);
end

toc





