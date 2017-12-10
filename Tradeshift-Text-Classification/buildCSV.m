
fid = fopen('testcsv.csv','w');
fprintf(fid,'Id,Predicted');
for i=1:length(VarName2)
    answer=unique(str2num(VarName2{i}));
    fprintf(fid,'\n%i,',VarName1(i));
    fprintf(fid,'%i',answer(1));
    fprintf(fid,' %i', answer(2:end));
end