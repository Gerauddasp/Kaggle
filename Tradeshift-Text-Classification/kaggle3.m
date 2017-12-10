clear all;
tic
filename = 'train.csv';

fid = fopen(filename);

zobounet = fgetl(fid);

TrainSet = spalloc(2.4e6,1e6,1e10);
TrainLabels = spalloc(2.4e6,3.5e5,1e7);

hil = zeros(1e8,1);
hjl = zeros(1e8,1);
hsl = zeros(1e8,1);
hif = zeros(1e9,1);
hjf = zeros(1e9,1);
hsf = zeros(1e9,1);

i=0;
labelcount = 1;
featurescount = 1;
zobounet = fgetl(fid);
while ischar(zobounet)
    i=i+1;
    if rem(i,10000) == 0;
        fprintf('iteration: %i\n',i);
        toc
    end
    
    k = strfind(zobounet, ':');
    labelstr = zobounet(1:k(1)-1);
    
    k2 = strfind(labelstr,' ');
    labelstr = labelstr(1:k2(end));
    
    label = str2num(labelstr)';
    hil(labelcount:labelcount+length(label)-1) = i * ones(size(label,1),1);
    hjl(labelcount:labelcount+length(label)-1) = label;
    hsl(labelcount:labelcount+length(label)-1) = ones(size(label,1),1);
    
    labelcount = labelcount + length(label);
    
    %TrainLabels(i,label) = 1;
    
    
    featuresstr = zobounet(k2(end)+1:end);
    featuresstr = strrep(featuresstr, ':',',');
    featuresstr = strrep(featuresstr, ' ',';');
    
    features = str2num(featuresstr);
    hif(featurescount:featurescount+length(features)-1) = i * ones(size(features,1),1);
    hjf(featurescount:featurescount+length(features)-1) = features(:,1);
    hsf(featurescount:featurescount+length(features)-1) = features(:,2);
    
    featurescount = featurescount + length(features);
   
    
    %TrainSet(i,features(:,1))= features(:,2);
    zobounet = fgetl(fid);
    
end

x = find(hil==0);
hil = hil(1:x(1)-1);

x = find(hjl==0);
hjl = hjl(1:x(1)-1);

x = find(hsl==0);
hsl = hsl(1:x(1)-1);

x = find(hif==0);
hif = hif(1:x(1)-1);

x = find(hjf==0);
hjf = hjf(1:x(1)-1);

x = find(hsf==0);
hsf = hsf(1:x(1)-1);
    
TrainLabels = sparse(hil,hjl,hsl);
TrainSet = sparse(hif,hjf,hsf);
toc
    