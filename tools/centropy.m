function [entropy] =  centropy(idx,idx_true,k)

if length(idx)~=length(idx_true)
   error('unequal index array lengths');
end

E = zeros(k,1);
n = zeros(k,1);
p = zeros(k, length(unique(idx_true)));
numclasses = length(unique(idx_true));
numdatapts = length(idx_true);

for j = 1:k
    
    cluster = idx_true(idx==j);
    n(j) = length(cluster);
    for i = 1:numclasses
        p(j,i) = numel(find(cluster==i))/n(j);
    end
    for i = 1:numclasses
        if p(j,i) == 0
        else
            E(j) = E(j) - p(j,i)*log10(p(j,i));
        end
    end
end 

entropy=0;
for j = 1:k
    entropy = entropy + E(j)*n(j)/numdatapts;
end