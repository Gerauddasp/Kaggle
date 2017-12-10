

warning('off','all');

disp('Loading data...');
load('LABELS');
load('train_reconstructed_matrix_NonCVX.mat')
labels = reconstructed_matrix(:,end);
%NA = double( str2double(NA) );

disp('Preprocessing...');
%Find the rows that dont contain the value of NA...
%     [row,col] = find(data_points==NA);
%     missing_data_ind = unique(row);
%     complete_data = data_points;
%     complete_data(missing_data_ind, :) = [];

%Get labels and data points of the actual complete data...
complete_data_labels = labels; % name my labels like that
complete_data = Set;

% play here
min_label = 0;
max_label = 100;
%Take only the values with the percentages between min_label and
%max_label...
ind = find(complete_data_labels >= min_label & complete_data_labels <= max_label);

%get rid of first (index) and last (label) column...
complete_data =  complete_data(ind,1:end);
complete_data_labels = complete_data_labels(ind);

%Get mean and std...
%     [Z,mu,sigma] = zscore(complete_data);
%
%     %Normalize the whole data set...
%     complete_data = normalize(complete_data, mu, sigma)*100;


%     %Perform fast PCA algorithm...
%     disp('Performing PCA...');
%     tic
%     %Perform fast PCA on data...
%     k = 700; % # dims
%     i = 2;  % # power
%     [U,S,V] = fsvd(complete_data, k, i);
%     %Verify reconstruction error...
%     X2 = U*S*V';
%     reconstruction_err = norm(complete_data(:)-X2(:))
%     toc

%Replace data with data after PCA...
%     complete_data = U;

no_iters = 1;

%Array to store the centroids created after 100 runs...
centroids_100_runs = cell(no_iters,1);
MAE_100_runs = zeros(no_iters,1);

%Repeat the same thing 100 times to get the best results of that
%cycle...
for iter = 1:no_iters
    %Shuffle data...
    disp('Shuffling data...');
    reordering = randperm(length(complete_data));
    complete_data = complete_data(reordering,:);
    complete_data_labels = complete_data_labels(reordering);
    
    %divide data between train and test...
    perc = floor( size(complete_data,1)*0.85 );
    train_x = complete_data(1:perc,:);
    train_y = complete_data_labels(1:perc);
    
    test_x = complete_data(perc+1:end,:);
    test_y = complete_data_labels(perc+1:end);
    
    %For every label, take the values from the training data that have that
    %label and do k means...
    K = 300;
    opts = statset('Display','final', 'MaxIter', 50);
    
    %Matrix to store the results of k means clustering... last column
    %indicates the label of each cluster...
    centroids = zeros(K*(max_label - min_label + 1), size(complete_data,2)+1);
    counter = 0;
    disp('Performing kmeans for every class...');
    
    tic
    for i=min_label:max_label
        disp(['- Going through label: ' num2str(i) '...']);
        counter = counter+1;
        %get the data with the current label...
        indices = find(train_y == i);
        %Check if this class has no data...
        if isempty(indices)
            %if it does, label those entries to get rid of them later...
            disp('- - No data for this element...');
            centroids((counter-1)*K+1:counter*K, end) = -1;
        else
            i_data = train_x(indices,:);
            %check if the data has enough points to perform kmeans...
            if i ~= 0
                while size(i_data,1) < K
                    disp('- - Duplicating data size...');
                    %if not, double the number of datapoints until we get enough
                    %(might need a better way to do this...)
                    i_data = repmat(i_data,2,1);
                end
            end
            %Perform kmeans...
            [IDX,centroid] = kmeans(i_data, K, 'emptyaction', 'singleton', 'Options',opts);
            %Store results..
            centroids((counter-1)*K+1:counter*K, :) = [centroid repmat(i,K,1)];
        end
    end
    toc
    
    %Get rid of "centroids" that have no data...
    indices_to_remove = find(centroids(:,end) == -1);
    centroids(indices_to_remove,:) = [];
    
    %Get rid of nan and inf centroids...
    centroids(any(isnan(centroids),2),:)=[];
    centroids(any(not(isfinite(centroids)),2),:)=[];
    
    %Get rid of repeated centroids...
    [q,i,j]=unique(centroids,'rows');
    [h,b]=histc(j,.5:size(centroids,1)-.5);
    idx=ismember(j,find(h>1));
    centroids(idx,:)=[];
    
    %Store the centroids for this run...
    centroids_100_runs{iter} =  centroids;
    
    %Begin testing...
    disp(' ');
    disp('Testing...');
    tic
    %Test using knn with the centroids...
    k_nn = 40;
    closest_centroid_ind = knnsearch(centroids(:,1:end-1),test_x, 'K', k_nn);
    labels = reshape(centroids(closest_centroid_ind, end), k_nn, size(test_x,1));
    %Take the most common closest label as the correct one...
    labels = sort(labels,'descend')';
    labels = mode(labels(1:15));
    labels(labels<20) = 0;
    toc
    disp('Getting results...');
    MAE = mean( abs( labels - test_y) )
    MAE_100_runs(iter) = MAE;
    disp('Done.');
end
