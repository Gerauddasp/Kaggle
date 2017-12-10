addpath('/Users/gerauddaspremont/MathWorks/rasmusbergpalm_DeepLearnToolbox_45ef96c/rasmusbergpalm-DeepLearnToolbox-45ef96c/CNN');
addpath('/Users/gerauddaspremont/MathWorks/rasmusbergpalm_DeepLearnToolbox_45ef96c/rasmusbergpalm-DeepLearnToolbox-45ef96c/data');
addpath('/Users/gerauddaspremont/MathWorks/rasmusbergpalm_DeepLearnToolbox_45ef96c/rasmusbergpalm-DeepLearnToolbox-45ef96c/util');
%load mnist_uint8;

train=load('ImagesCell.mat');
train = train(1).Images;
for i=1:length(train)
    Train2(:,:,i)= rgb2gray(train{i});
end

for i=1:size(Train2,3)
    Train3(:,:,i) = flipdim(Train2(:,:,i),2);
end

Train = cat(3,Train2, Train3);
av = mean(Train, 3);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for Aaron: import your cnn structure and also addpath to all functions of
% the toolbox.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here I loop to write the CSV file
FileID = fopen('Submit.csv','w');
fprintf(FileID,'%s,%s\n','id','label');
for i=1:50000:300000
    for j=1:50000
        name = strcat('test/','%d.png');
        Images=imread(sprintf(name,(i+j)-1));
        Images = rgb2gray(Images);
        test_x(:,:,j) = double(Images);
    end
    av = mean(test_x,3);
    
    for j=1:50000
        test_x(:,:,j) = test_x(:,:,j) - av;
    end
        
    
    net = cnnff(cnn, test_x);
    [~, I] = max(net.o);
    
    for j=1:50000
        z = (i+j)-1;
        switch I(j)
            case 1
                fprintf(FileID,'%d,%s\n',z,'airplane');
            case 2
                fprintf(FileID,'%d,%s\n',z,'automobile');
            case 3
                fprintf(FileID,'%d,%s\n',z,'bird');
            case 4
                fprintf(FileID,'%d,%s\n',z,'cat');
            case 5
                fprintf(FileID,'%d,%s\n',z,'deer');
            case 6
                fprintf(FileID,'%d,%s\n',z,'dog');
            case 7
                fprintf(FileID,'%d,%s\n',z,'frog');
            case 8
                fprintf(FileID,'%d,%s\n',z,'horse');
            case 9
                fprintf(FileID,'%d,%s\n',z,'ship');
            case 10
                fprintf(FileID,'%d,%s\n',z,'truck');
        end
    end
end

fclose(FileID);
%[er, bad] = cnntest(cnn, test_x, test_y);


%plot mean squared error
plot(cnn.rL);
%show test error
%disp([num2str(er*100) '% error']);