function [dur] = dur_95t(sig,Fs)

% Computes a modified 95% energy duration measure by Madsen & Wahlberg 2007
% using the cumulative Teager-Kaiser energy.

sig_c = cumsum(abs(teager(sig)));
mx=max(sig_c);
strtpt=mx*2.5/100;
ndpt=mx*97.5/100;

tmp_strt=abs(sig_c-strtpt);
tmp_nd=abs(sig_c-ndpt);

[~,idxstrt] = min(tmp_strt);
[~,idxnd] =min(tmp_nd);

dur=idxnd-idxstrt;

dur =dur/Fs*10^6;