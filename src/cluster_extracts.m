function [idx, k, other, other2] = cluster_extracts(fmat, method, k, eps, minPts)
%% Normalization
fmat_norm = normalizeData(fmat');
fmat = fmat_norm';

% fmat_var = var(var(fmat,1),1);

if nargin<3
%     fmat_rdc = reduce_data(fmat);
    eva = evalclusters(fmat,'kmeans','DaviesBouldin','KList',2:10);
    k=eva.OptimalK;
end

%% Clustering
switch method
    
    case 'kmeans'
        [idx,other] = kmeans(fmat, k,'Replicates', 5);
    case 'kmedoids'
        [idx] = kmedoids(fmat, k,'Replicates', 5);
    case 'SOM'
        fmat = fmat';
        net = selforgmap([8 8],100,3,'gridtop','mandist');
        [net, ~] = train(net, fmat);
        idx_net = net(fmat);
        idx_net = vec2ind(idx_net);
        inwghts = net.IW{1};
        inwghts_flt=inwghts;
        empt=setdiff(1:length(inwghts),idx_net);
        inwghts_flt(empt,:)=NaN;
        warning('off','all');
        idx_km = kmeans(inwghts_flt, k,'Replicates', 5);
        warning('on','all');
        idx=zeros(length(idx_net),1);
        unq=unique(idx_net);
        for i=1:length(unq)
            idx(idx_net==unq(i))=idx_km(unq(i));
        end
    case 'spectral'
        W = SimGraph_NearestNeighbors(fmat',15,1,1);
        [idx, ~, other, other2] = SpectralClustering(W,k,2);
        
    case 'dbscan'
        if nargin < 4
            eps = .05;
            minPts = 30;
        end
        [idx] = DBSCAN(fmat,eps,minPts);
        
    otherwise
        error('Invalid input')
end

end

