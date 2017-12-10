load 'Traintop.mat'

% Geraud, you don't have to center when it's in grayscale I believe
% set to double
%Traintop = im2double(Traintop);

% calc mean
out = mean(Traintop,3);

for i=1:50000
    Trainmeancenttiled(:,:,i) = Traintop(:,:,i) - out;
    
    
end