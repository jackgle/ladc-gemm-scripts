function [idx, other, other2] = cluster_extracts(fmat, method, k, outlier )
%% Normalization
fmat_norm = normalizeData(fmat');
fmat = fmat_norm';

% fmat_var = var(var(fmat,1),1);

if nargin<5
    outlier=[];
end
%% Clustering
switch method
    
    case 'kmeans'
%         if ~isempty(outlier)
%             PVE = zeros(10,1);
%             for i = 1:10
%                 [~, C] = kmeans(fmat, i,'EmptyAction', 'Drop', 'Replicates', 1);
%                 PVE(i) = var(var(C,1),1)/fmat_var;
%             end
% 
%             plot(1:10, PVE);
% 
%             idx = kmeans(fmat, find(PVE==max(PVE)), 'EmptyAction', 'Drop', 'Replicates', 10);
% 
%             data_key = mode(idx);
% 
%             idx(idx~=data_key,:)=max(idx)+1;
% 
%             idx(idx==data_key) = kmeans(fmat(idx==data_key), k, 'EmptyAction', 'Drop', 'Replicates', 10);
%         

        [idx,other] = kmeans(fmat, k,'Replicates', 5);
    case 'kmedoids'
        [idx] = kmedoids(fmat, k,'Replicates', 5);
    case 'SOM'
        if ~isempty(outlier)
            disp('Will not perform outlier detection with SOM method');
        end
        fmat = fmat';
        net = selforgmap([1 k]);
        [net, ~] = train(net, fmat);
        idx = net(fmat);
        idx=idx';
        idx_out = zeros(size(fmat,1),1);
        for i = 1:size(idx,2)
            idx_out(idx(:,i)==1)=i;
        end
        plotsompos(net,fmat);
        idx = idx_out;
        
    case 'spectral'
        W = SimGraph_NearestNeighbors(fmat',15,1,1);
        [idx, ~, other, other2] = SpectralClustering(W,k,2);
        
    case 'dbscan'
%         for i = 0.05:0.02:0.3
            [idx] = DBSCAN(fmat,.20,30);
%         end
        
    otherwise
        error('Invalid input')
end

end

