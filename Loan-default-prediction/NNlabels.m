clear all; close all;
load('wsppca.mat');
Set =load('train_dataDouble.mat');
labels = Set.data_points(:,end);

 

% for i=1:length(G)
%     if rem(i,10000) == 0
%         fprintf('iteration num: %i\n',i)
%     end
%     l = labels(i);
%     if l < 10
%         labelsforNN(i,1) = 1;
%     elseif (l>=10 && l<20)
%         labels(i,2) = 1;
%     elseif (l>=20 && l<30)
%         labels(i,3) = 1;
%     elseif (l>=30 && l<40)
%         labels(i,4) = 1;
%     elseif (l>=40 && l<50)
%         labels(i,5) = 1;
%     elseif (l>=50 && l<60)
%         labels(i,6) = 1;
%     elseif (l>=60 && l<70)
%         labels(i,7) = 1;
%     elseif (l>= 70 && l<80)
%         labels(i,8) = 1;
%     elseif (l>=80 && l<90)
%         labels(i,9) = 1;
%     elseif (l>=90 && l<=100)
%         labels(i,10) = 1;
%     else
%         display('error');
%     end
%         
% end

NewG = G(labels<10,:);
labelsforNN = zeros(length(NewG),10);
NewLabels = labels(labels<10);

for i=1:length(NewG)
    if rem(i,10000) == 0
        fprintf('iteration num: %i\n',i)
    end
    labelsforNN(i,(NewLabels(i)+1)) = 1;
end