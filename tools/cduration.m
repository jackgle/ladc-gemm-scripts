function [ dur ] = cduration( click, noise, const, graph, time )

% function to calculate the duration of an echolocation click
%
% const is chosen such that its product with the peak amplitude of a
% click of common SNR is equal to 3. I chose example_C_lc as the reference
% signal.
%
% Fs is chosen here for EARS data: 192 kHz

Fs = 192000;

click = click(:)';

click_en = teager(click);

noise_t = teager(noise);

thresh = const*max(click_en)*(mean(noise_t)+3*std(noise_t));

dur = range(find(click_en >= thresh));
                
dur = (dur/Fs)*10^6; % give answer in microseconds

if exist('graph','var') && strcmp(graph, 'graph')
    clf
    if exist('time','var')
%         plot(time,normr(click));
        hold on
        plot(time,click_en);
        thsh_line(1:length(click)) = thresh;
        plot(time,thsh_line);
    else
%         plot(normr(click));
        hold on
        plot(click_en);
        thsh_line(1:length(click)) = thresh;
        plot(thsh_line);
    end
    hold off
end

end

