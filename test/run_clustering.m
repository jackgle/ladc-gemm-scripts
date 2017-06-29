% Generate vector of k values for Higuchi FD algorithm in feature
% extraction
k_hfd = generate_k(100);

% Extract features from the pre-processed frames in the structure cs
feature_mat = feature_extract_fortest(cs);

% Cluster the observations based on signal features, and plot the results
[idx,num_clusters] = cluster_extracts(feature_mat,'spectral');
figure
plot_space(feature_mat,idx);
view(-45,45);
xlabel('Pattern duration (\mus)');
ylabel('Higuchi FD')
zlabel('Spectral centroid (Hz)');
xlim([0 650]);
zlim([2e4,6e4]);
hold on; scatter3(feature_mat(:,1),feature_mat(:,2),ones(size(feature_mat,1),1)*2e4,100,'o','MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7],'MarkerEdgeAlpha',.2,'MarkerFaceAlpha',.2,'LineWidth',1);
accuracy = centropy(idx,idx_true,num_clusters);
