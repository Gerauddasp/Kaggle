function [Centers] = KmeansforImage(Train, labels)
% This function find centers for each category.
% Input: training set (Sample x Dimensions)
%        The labels as 1 for airplane and 10 for truck
% Output: a 10 x dim vector with each line representing the center of one
% category of object, ordered as on the webpage.

Train = double(Train);
[IDX, C] = kmeans(Train, 10);

for i=1:10
    I = mode(IDX(labels==i));
    Centers(i,:) = C(I,:);
end

end

