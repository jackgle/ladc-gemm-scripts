function [ dur ] = dur_noisestat( sig, noise)

Fs=192000;
sig=teager(sig);
l=length(sig);
noise=teager(noise(1:l));

thresh = mean(noise) + 2*std(noise);
dur = range(find(sig>=thresh));
dur = (dur/Fs)*10^6; % give answer in microseconds

% shg
% clf
% hold on
% plot(sig)
% plot(noise(1:401))
% thresh(1:401) = thresh;
% plot(thresh);
% hold off

if isempty(dur)
    dur = 0;
end

end
