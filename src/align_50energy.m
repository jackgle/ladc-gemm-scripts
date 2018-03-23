function [sig_centered] = align_50energy(sig)

% Centers a windowed transient based on the time of 50% accumulated energy

sig_c = cumsum(sig.^2);
mx=max(sig_c);
midpt=mx*50/100;
tmp_mid=abs(sig_c-midpt);
[~, idxmid] = min(tmp_mid);

diff = idxmid-median(1:length(sig));

sig_centered = circshift(sig,diff);
