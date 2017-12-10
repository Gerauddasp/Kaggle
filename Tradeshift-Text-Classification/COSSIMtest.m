clear all;
addpath('/Users/gerauddaspremont/MathWorks/mtimesx_20110223');
display('loading data...')
load('VectorsForSparse');
load('IFIDF');
display('done');

display('building IFIDF')
% TFIDF = sparse(hif,hjf,hnewf);
% LABELS = sparse(hil, hjl, hsl);
Partf = 1000;
Partv = 2000;
If = find(hif==Partf,'first');
Iv = find(hif==Partv,'first');
Ifl = find(hil==Partf,'firt');
vhif = hif(If+1:Part+1000);
vhjf = hjf(Part+1:Part+1000);
vhsf = hnewf(Part+1:Part+1000);
vhil = hil(Part+1:Part+1000);
vhjl = hjl(Part+1:Part+1000);
vhsl = hsl(Part+1:Part+1000);

hif = hif(1:Part);
hjf = hjf(1:Part);
hsf = hnewf(1:Part);
hil = hil(1:Part);
hjl = hjl(1:Part);
hsl = hsl(1:Part);

TFIDF = sparse(hif,hjf,hsf);
LABELS = sparse(hil, hjl, hsl);
VALIDATION = sparse(vhif, vhjf, vhsf);
VALIDATIONlab = sparse(vhil, vhjl, vhsl);

clear hnewf;

%clear hif hil hjf hjl hnewf hsl hsf I;
display('done')

% SHUFFLE = randperm(size(LABELS,1));
% 
% subdividing Validation and Train Set
% LABELS = LABELS(SHUFFLE,:);
% TFIDF  = TFIDF(SHUFFLE,:);
% 
% selected = zeros(size(LABELS,2),1);
% tic
% for col=1:size(LABELS,2)
%     row = find(LABELS(:,col) ~= 0,1);
%     if not(isempty(row))
%         selected(col) = row;
%     end
% end
% 
% selected = selected(find(selected~=0));
% 
% VALIDATIONLABELS = LABELS(selected,:);
% VALIDATION = TFIDF(selected,:);
% LABELS(selected,:) = [];
% TFIDF(selected,:) =[];
% toc



clear selected row SHUFFLE;

display('Start KNN');
tic
% number of knn

k = 70;

if matlabpool('size') == 0 
   matlabpool('open',4) ;
end

VALIDATION = VALIDATION';
display('dividing norm validation...')
NORMVAL = sqrt(sum(VALIDATION.^2));
VALIDATION = bsxfun(@rdivide,VALIDATION,NORMVAL);
clear NORMVAL
display('dividing norm TFIDF...');

% problem here!
NORMTFIDF = sqrt(sum(TFIDF.^2, 2));
TFIDF(hifs,hjfs) = bsxfun(@ldivide,TFIDF,NORMTFIDF);
clear NORMTFIDF
display('Calulating COSSIM...')
COSSIM = zeros( [size(VALIDATION,1),1],'single');
COSSIM = TFIDF*VALIDATION;
display('done!')
clear TFIDF VALIDATION;

% I will be way to big!
[C, I] = sort(COSSIM,1,'descend');
KNNval = C(:,1:k);
KNNind = I(:,1:k);

% find labels corresponding to I

toc

% Now Cross-validation
