function TestCSV
Ndata = 300000;

Images = imptrainIm('test/', Ndata);

for i = 1:Ndata
grayimage = rgb2gray(Images{i});
TestSet1(i,:) = grayimage(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hsv histogram of h
scaleImage = cast(Images{i},'single')/255;
hsvImage = rgb2hsv(scaleImage);
MatH = hsvImage(:,:,1);
VecH = MatH(:);
xvalues = (0:0.1:1);
[nelements, centers] = hist(VecH, xvalues);
TestSet2(i,:) = nelements;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% concatenate everything together
TestSet = [TestSet1, TestSet2];
TestSet = double(TestSet);
%TestSet = {1,TestSet'};
Tcell{1,1}=TestSet';

Results = myNeuralNetworkFunction1(Tcell);
Results = Results{1};

[zob I] = max(Results);

%%%%%%%%%%%%%%%%%%%%%%
% write the csv file
FileID = fopen('Submit.csv','w');
fprintf(FileID,'%s,%s\n','id','label');

for i=1:Ndata
    switch I(i)
        case 1
          fprintf(FileID,'%d,%s\n',i,'airplane');
        case 2
            fprintf(FileID,'%d,%s\n',i,'automobile');  
        case 3
            fprintf(FileID,'%d,%s\n',i,'bird');  
        case 4
            fprintf(FileID,'%d,%s\n',i,'cat');  
        case 5
            fprintf(FileID,'%d,%s\n',i,'deer'); 
        case 6
            fprintf(FileID,'%d,%s\n',i,'dog');  
        case 7
            fprintf(FileID,'%d,%s\n',i,'frog'); 
        case 8
            fprintf(FileID,'%d,%s\n',i,'horse'); 
        case 9
            fprintf(FileID,'%d,%s\n',i,'ship');
        case 10
            fprintf(FileID,'%d,%s\n',i,'truck'); 
    end

end
fclose(FileID);
end

function [Images] = imptrainIm(FolderPath, N)
Images = cell(1,N);
name = strcat(FolderPath,'%d.png');
for i = 1:N
    Images{i}=imread(sprintf(name,i));
end
end