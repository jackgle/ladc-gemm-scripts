% Centers windowed transients based on median sample index over the 10 dB
% threshold

function [sig_cent] = align_env(sig)

env = abs(hilbert(sig));
mx=max(env);
mx_dB = 20*log10(mx);
thresh = 10^((mx_dB-10)/20);
subind = find(env>=thresh);
midind = round(median(subind));

diff = round(median(1:length(sig)))-midind;

sig_cent = circshift(sig,diff);


% z = hilbert(subsig);
% instfreq = fs/(2*pi)*diff(unwrap(angle(z)));
% 
% f = polyfit(1:length(instfreq),instfreq,1);
% f = polyval(f,1:length(instfreq));

% f_med = median(f);

