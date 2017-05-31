% Generate vector of k values for Higuchi FD algorithm in feature
% extraction
k_hfd = generate_k(100);

% Extract features from the pre-processed frames in the structure cs
feature_mat = feature_extract_4test(cs,noise,gamma,k_hfd);

% Cluster the observations based on signal features, and plot the results
[idx,num_clusters] = cluster_extracts(feature_mat,'spectral');
figure
plot_space(feature_mat,idx);
view(-45,45);
xlabel('Pattern Duration (ms)');
ylabel('Higuchi FD')
zlabel('-20 dB Center Frequency (Hz)');
xlim([0 800]);
hold on; scatter(feature_mat(:,1),feature_mat(:,2),'o','MarkerEdgeColor',[.7 .7 .7]);
accuracy = class_accuracy(idx,idx_true,num_clusters);
