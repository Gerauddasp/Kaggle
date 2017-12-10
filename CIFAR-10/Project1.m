function  Project1
clear all

Ndata = 50000;

% import labels
% labels = openlabel;
% labels = convertlabels(labels, Ndata);


% import train images
Images = imptrainIm('train/', Ndata);

for i = 1:Ndata
grayimage = rgb2gray(Images{i});
Train1(i,:) = grayimage(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hsv histogram of h
scaleImage = cast(Images{i},'single')/255;
hsvImage = rgb2hsv(scaleImage);
MatH = hsvImage(:,:,1);
VecH = MatH(:);
xvalues = (0:0.1:1);
[nelements, centers] = hist(VecH, xvalues);
Train2(i,:) = nelements;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% concatenate everything together

Train = [Train1, Train2];



end


function [res] = convertlabels(input,N)
res = zeros(N,10);
for i=1:N
    test = input{i,2};
    if strcmp(test,'airplane')
        res(i,1) = 1;
    elseif strcmp(test, 'automobile')
        res(i,2) = 1;
    elseif strcmp(test, 'bird')
        res(i,3) = 1;
    elseif strcmp(test, 'cat')
        res(i,4) = 1;
    elseif strcmp(test, 'deer')
        res(i,5) = 1;
    elseif strcmp(test, 'dog')
        res(i,6) = 1;
    elseif strcmp(test, 'frog')
        res(i,7) = 1;
    elseif strcmp(test, 'horse')
        res(i,8) = 1;
    elseif strcmp(test, 'ship')
        res(i,9) = 1;
    elseif strcmp(test, 'truck')
        res(i,10) = 1;
    end
end

end
function [Images] = imptrainIm(FolderPath, N)
Images = cell(1,N);
name = strcat(FolderPath,'%d.png');
for i = 1:N
    Images{i}=imread(sprintf(name,i));
end
end
function [trainLabels] = openlabel
filename = '/Users/gerauddaspremont/Machine Learning/Applied ML/Project 1/trainLabels.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%f%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
dataArray(1) = cellfun(@(x) num2cell(x), dataArray(1), 'UniformOutput', false);
trainLabels = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end