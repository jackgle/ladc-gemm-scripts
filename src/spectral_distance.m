function [spec_dist] = spectral_distance(cstruct,fs,nfft)

tmp = normalize_spect(cstruct(1).sig,fs,nfft);
pxx = zeros(length(cstruct),length(tmp));
for i = 1:length(cstruct)
    pxx(i,:) = normalize_spect(cstruct(i).sig,fs,nfft);
end

% for i = 1:size(pxx,1)
%     pxx(i,:) = pxx(i,:)-mean(pxx(i,:));
% end

% spec_dist = pdist(pxx,@specDist);
% spec_dist = 1-corr(pxx');
spec_dist = pdist(pxx,'correlation');
spec_dist = squareform(spec_dist);
spec_dist = exp(-spec_dist);
spec_dist(spec_dist==1)=0;
% spec_dist = triu(spec_dist);
end