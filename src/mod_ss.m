function [ nr_spectrogram ] = mod_ss( signal )

l = length(signal)/500;

s = spectrogram(signal,hann(l),floor((85*l)/100),1024);

for i = 1:size(s,1)
    
h = histogram(abs(s(i,:)));
x = h.Values;
x = movmean(x,7);

end

