function [idx, C] = jclassify(fmat,C0,method,fmat_seed,idx_seed)

k=3;

[idx] = cluster_extracts(fmat,method,k);

[C] = centroids(fmat,idx);

catC = [C0;C];

catC = normalizeData(catC')';

[idx_c, d] = dsearchn(catC(1:size(C0,1),:),catC(size(C0,1)+1:end,:));

for i=1:k
%     if d(i) <= mean(pdist(catC(1:size(C0,1),:)))
    if d(i)==0
        idx(idx==i)=idx_c(i);
    else
        idx(idx==i)=max(idx_seed)+1;
    end     
end

C = centroids([fmat_seed;fmat],[idx_seed;idx]);

end