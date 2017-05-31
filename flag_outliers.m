function [struct,d] = flag_outliers(struct,fmat,plt)

% This program adds a field to a click structure with a binary value that either flags an
% observation as an outlier (1) or not (0)

fmat_norm = normalizeData(fmat');
fmat = fmat_norm';

eva = evalclusters(fmat,'kmeans','DaviesBouldin','KList',1:10);
k=eva.OptimalK;

[~,~,~,d]=kmedoids(fmat,k);

mind=zeros(length(d),1);
for i=1:length(d)
    mind(i) = min(d(i,:));
end
d = mind;

for i=1:length(struct)
    if abs(log(d(i)))>2*std(abs(log(d)))
        struct(i).outlier=1;
    else
        struct(i).outlier=0;
    end
end

if nargin==3 && strcmp(plt,'plot')
    idx_test(1:length(struct)) = 1;
    for i=1:length(struct)
        if struct(i).outlier==1
            idx_test(i)=2;
        end
    end
    plot_space(fmat,idx_test);
end