function [spec_dist] = corr_distance(cstruct)

% Computes the pairwise correlation coefficients 

if isstruct(cstruct)
    all_sig=zeros(length(cstruct),length(cstruct(1).sig));
    for i = 1:length(cstruct)
        all_sig(i,:) = cstruct(i).sig;
    end
elseif ismatrix(cstruct)
    all_sig = cstruct;
else
    error('Input must be matrix or structure array')
end

spec_dist = pdist(all_sig,@specDist);
% spec_dist = 1-corr(all_sig');
% spec_dist = pdist(all_sig,'correlation');
spec_dist = squareform(spec_dist);
spec_dist = exp(-spec_dist);
spec_dist(spec_dist==1)=0;
% spec_dist = triu(spec_dist);
end