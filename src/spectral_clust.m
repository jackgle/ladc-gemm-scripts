function [idx,A] = spectral_clust(fmat,graphType,opt,k)

fmat = normalize_fmat(fmat);

if nargin<4
%     fmat_rdc = reduce_data(fmat);
%     [~,~,~,k] = kmeans_opt(fmat);
    eva = evalclusters(fmat,'kmeans','daviesbouldin','KList',2:10);
    k=eva.OptimalK;
end

switch graphType
    
    case 'pctile'
        A = SimGraph_Pctile(fmat',opt);
    case 'knn'
        opt = round(length(fmat(:,1))*(opt/100));
        A = SimGraph_NearestNeighbors(fmat',opt,1,1);  
    case 'epsilon' 
        A = SimGraph_Epsilon(fmat',opt);
end

[idx, ~, other, other2] = SpectralClustering(A,k,1);
