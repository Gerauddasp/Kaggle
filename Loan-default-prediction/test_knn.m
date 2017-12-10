

load('centroidsFinalTest.mat');
%load('results/FinalParamsNew.mat');

load('test_reconstructed_matrix_NonCVX.mat');

% Divide the indices from the data...
complete_data_index = reconstructed_matrix(:,1);
complete_data = reconstructed_matrix(:,2:end);

[Z,mu,sigma] = zscore(complete_data);

complete_data = normalize(complete_data, mu, sigma)*100;

clear reconstructed_matrix;

%Use the values for svd to get the reduced matrix...
complete_data = complete_data/V'/S;

disp('Testing...');
tic

%Test using knn with the centroids...
k_nn = 10;
closest_centroid_ind = knnsearch(centroids(:,1:700),complete_data, 'K', k_nn, 'Distance', 'cityblock');
labels = reshape(centroids(closest_centroid_ind, end), k_nn, size(complete_data,1));
%Take the most common closest label as the correct one...
labels = max(labels)';
labels(labels<50) = 0;
results = [complete_data_index labels];
toc

% Save results...
tic
disp('Saving results...');
fileID = fopen('firstresults.csv','w');
fprintf('id, loss\n');
fprintf(fileID,'%6.2f,%12.8f\n',results);
fclose(fileID);
toc

disp('Done.');
