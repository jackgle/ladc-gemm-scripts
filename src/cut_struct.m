function [ structp ] = cut_struct( structp, noise, adj )

% Cuts structure field signals to detected duration

L = length(structp(1).sig);

for i = 1:length(structp)
    
    locs = cduration_edit(structp(i).sig,noise,adj);
    
    if locs(1)-10 > 0 && locs(end)+10 < L
        structp(i).sig = structp(i).sig(locs(1)-10:locs(end)+10);
        win = hann(length(structp(i).sig))';
        structp(i).sig = structp(i).sig.*win;
        
        if isfield(structp(i),'time_win')
            structp(i).time_win =  structp(i).time_win(locs(1)-10:locs(end)+10);
        end
        if isfield(structp(i),'sample_win')
            structp(i).sample_win =structp(i).sample_win(locs(1)-10:locs(end)+10);
        end
    end
end
    
end

function [ locs ] = cduration_edit(click, noise, const)

% function to calculate the duration of an echolocation click
%
% const is chosen such that its product with the peak amplitude of a
% click of common SNR is equal to 3. I chose example_C_lc as the reference
% signal.
%
% Fs is chosen here for EARS data: 192 kHz

% Fs = 192000;

click = click(:)';
click_t = teager(click);
noise_t = teager(noise);
thresh = const*max(click_t)*(mean(noise_t)+3*std(noise_t));
locs = find(click_t > thresh);
                
% dur = (dur/Fs)*10^6; % give answer in microseconds

end

