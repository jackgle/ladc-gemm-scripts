% This function will take the cross correlation between a signal 'sig' and a
% template, and shift the signal such that its center sample lies at the
% peak of the cross-correlation.

function [sig_cent] = align_xcorr(template,sig)

tmp = xcorr(template,sig);
[~,ind] = max(tmp);
diff = ind-length(sig);
sig_cent = circshift(sig,diff);
end