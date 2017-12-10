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

for i=1:length(trainLabels)
    test = trainLabels{i,2};
    if strcmp(test,'airplane')
        res(i,1) = 1;
    elseif strcmp(test, 'automobile')
        res(i,1) = 2;
    elseif strcmp(test, 'bird')
        res(i,1) = 3;
    elseif strcmp(test, 'cat')
        res(i,1) = 4;
    elseif strcmp(test, 'deer')
        res(i,1) = 5;
    elseif strcmp(test, 'dog')
        res(i,1) = 6;
    elseif strcmp(test, 'frog')
        res(i,1) = 7;
    elseif strcmp(test, 'horse')
        res(i,1) = 8;
    elseif strcmp(test, 'ship')
        res(i,1) = 9;
    elseif strcmp(test, 'truck')
        res(i,1) = 10;
    end
end