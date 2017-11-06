function plot_extracts(cstruct,signal,shorttime,idx)

% This function plots the results of click_extract. The original signal is
% plotted, with extracted segments highlighted.

% Filter signal as in click_extract, so that highlighted extracts align
% with the signal they are overlayed upon

[B,A] = butter(5, [(15000*2)/192000 (95000*2)/192000]);
signal = filtfilt(B,A,signal);

len =length(cstruct);

clf;
shg;
if nargin==4
    
    k=max(idx);
    colors = parula(k);
    
    if isempty(shorttime)
        if ~isempty(signal)
            plot(signal,'Color',[0 0.4470 0.7410]);
        end
        axis tight
        xlabel('Sample');
        hold on
        for i = 1:len
            plot(cstruct(i).sample,cstruct(i).sig,'Color',colors(idx(i),:));
        end
    else
        if ~isempty(signal)
            plot(shorttime,signal,'Color',[0 0.4470 0.7410]);
        end
        axis tight
        xlabel('Time (s)');
        hold on
        for i = 1:len
            plot(cstruct(i).time,cstruct(i).sig,'Color',colors(idx(i),:));
        end
    end
else

    if isempty(shorttime)
        if ~isempty(signal)
            plot(signal,'Color',[0 0.4470 0.7410]);
        end
        axis tight
        xlabel('Sample');
        hold on
        for i = 1:len
            plot(cstruct(i).sample,cstruct(i).sig,'Color','r');
        end
    else
        if ~isempty(signal)
            plot(shorttime,signal,'Color',[0 0.4470 0.7410]);
        end
        axis tight
        xlabel('Time (s)');
        hold on
        for i = 1:len
            plot(cstruct(i).time,cstruct(i).sig,'Color','r');
        end
    end
end
    
%grid on
hold off
% h = zoom;
% h.Motion = 'horizontal';
%h.Enable = 'on';

end

