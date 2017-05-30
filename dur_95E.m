function [ dur ] = dur_95E( sig, noise )

Fs=192000;

thresh = mean(noise.^2) + 2*std(noise.^2);

dur = range(find(sig.^2>thresh));

dur = (dur/Fs)*10^6; % give answer in microseconds

if isempty(dur)
    dur = 0;
end

end

