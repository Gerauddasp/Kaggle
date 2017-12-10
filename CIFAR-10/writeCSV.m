function writeCSV(i, Class)
% input: i sample that you are testing and your result Class
I = Class;
if i == 1
    FileID = fopen('Submit.csv','w');
    fprintf(FileID,'%s,%s\n','id','label');
end

switch I
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

if i == 300000
    % change here if you want to write less than 300 000
    fclose(FileID);
end

end

