function [ structp ] = cut_structv2( structp )

% Cuts structure field signals to detected duration

L = length(structp(1).sig);

for i = 1:length(structp)
    
    [strt, nd] = dur_10db(structp(i).sig);
    
    if strt-10 > 0 && nd+10 < L
        structp(i).sig = structp(i).sig(strt-20:nd+20);
        win = hann(length(structp(i).sig))';
        structp(i).sig = structp(i).sig.*win;
        
        if isfield(structp(i),'time_win')
            structp(i).time_win =  structp(i).time_win(strt-20:nd+20);
        end
        if isfield(structp(i),'sample_win')
            structp(i).sample_win =structp(i).sample_win(strt-20:nd+20);
        end
    end
end
    
end

function [strt, nd] = dur_10db(sig)

% Computes -10 dB duration from a voltage signal

sig = abs(hilbert(sig));
mx=max(sig);
mx_dB = 20*log10(mx);
thresh = 10^((mx_dB-10)/20);
strt = find(sig>=thresh, 1 );
nd = find(sig>=thresh, 1, 'last' );

end


