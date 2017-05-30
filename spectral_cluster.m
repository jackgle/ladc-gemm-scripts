function [ idx, C, x ] = spectral_cluster( mat_C, k )

% Spectral clustering
n = size(mat_C,1);
W = squareform(pdist(mat_C));
W = simGaussian(W, 1);
D = zeros(n);
for i = 1:n
    D(i,i) = sum(W(i,:));
end

L = D - W;

% D = sqrtm(D);
% L = D\A/D;

[x, ~] = eigs(L,k);

[idx, C] = kmeans(x, k, ...
                 'EmptyAction', 'singleton');

end

