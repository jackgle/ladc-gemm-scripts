function [C] = centroids(fmat,idx)
    
k = length(unique(idx));
C = zeros(k,size(fmat,2));
for i = 1:k
    C(i,:) = mean(fmat(idx==i,:));
end