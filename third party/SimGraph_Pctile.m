function W = SimGraph_Pctile(M, pctile)
% SIMGRAPH_EPSILON Returns epsilon similarity graph
%   Returns adjacency matrix for an epsilon similarity graph
%
%   'M' - A d-by-n matrix containing n d-dimensional data points
%   'epsilon' - Parameter for similarity graph
%
%   Author: Ingo Buerk
%   Year  : 2011/2012
%   Bachelor Thesis

n = size(M, 2);

% Preallocating memory is impossible, since we don't know how
% many non-zero elements the matrix is going to contain
indi = [];
indj = [];
inds = [];

dist=nan(n);

for ii = 1:n
    % Compute i-th column of distance matrix
    dist(ii,:) = distEuclidean(repmat(M(:, ii), 1, n), M);
end

dist(dist > prctile(dist(:),pctile))=0;
% dist = dist - diag(diag(dist));
    
for ii = 1:n  
    % Now save the indices and values for the adjacency matrix
    lastind  = size(indi, 2);
    count    = nnz(dist(ii,:));
    [~, col,val] = find(dist(ii,:)); % JGL Edit 03/19/18 - 'val'
    
    indi(1, lastind+1:lastind+count) = ii;
    indj(1, lastind+1:lastind+count) = col;
    inds(1, lastind+1:lastind+count) = val; % JGL Edit 03/19/18 - 1 (unweighted) -> val (weighted)
end

% Create adjacency matrix for similarity graph
W = sparse(indi, indj, inds, n, n);

W = spfun(@(W) (simGaussian(W, 1)), W); % JGL Edit 03/19/18

clear indi indj inds dist lastind count col v;

end