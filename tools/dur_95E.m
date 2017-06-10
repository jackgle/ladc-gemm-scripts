function [dur] = dur_95e(sig,Fs)

% Computes the 95% energy duration measure by Madsen & Wahlberg 2007

sig_c = cumsum(sig.^2);
mx=max(sig_c);
strtpt=mx*2.5/100;
ndpt=mx*97.5/100;

tmp_strt=abs(sig_c-strtpt);
tmp_nd=abs(sig_c-ndpt);

[~, idxstrt] = min(tmp_strt);
[~, idxnd] =min(tmp_nd);

dur=idxnd-idxstrt;

dur =dur/Fs*10^6;
