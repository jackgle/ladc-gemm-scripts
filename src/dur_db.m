function [dur] = dur_db(sig,Fs,DB)

% Computes -10 dB duration from a voltage signal

sig = abs(hilbert(sig));
mx=max(sig);
mx_dB = 20*log10(mx);
thresh = 10^((mx_dB-DB)/20);
dur = range(find(sig>=thresh));

dur =dur/Fs*10^6;

