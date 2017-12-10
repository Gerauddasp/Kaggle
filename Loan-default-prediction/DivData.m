load('wsppca.mat')
load('LABELS.mat')

zerosLab = find(labels==0);
nonzerosLab = find(labels>0);

ra0 = randperm(length(zerosLab));

NewLabels = [labels(labels>0);labels(ra0(1:nnz(labels>0)))];
NewG = [G(labels>0,:); G(ra0(1:nnz(labels>0)),:)];

NewLabels(NewLabels>0) = 1;

LabelsForNN = zeros(length(NewLabels),2);
for i=1:length(NewLabels)
    LabelsForNN(i,NewLabels(i)+1) = 1;
end

% shuffle

randl = randperm(length(LabelsForNN));

NewG = NewG(randl,:);
LabelsForNN = LabelsForNN(randl,:);