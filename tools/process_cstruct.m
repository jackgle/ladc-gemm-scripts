function [struct_out] = process_cstruct( struct_in, plot_prcs )

% This function performs Hann windowing on the signals of the extracted
% structure array

[B,A] = butter(5, [10000 95000]/96000);

% if nargin == 1 || isempty(win)
    win = hann(length(struct_in(1).sig))';
% end
if nargin < 2
    plot_prcs = '';
end

if nargin > 1 && ~strcmp(plot_prcs,'plot')
    error('The optional third argument must be ''plot'' if used.');
end
struct_out = struct_in;
for i = 1:length(struct_in)
    
    if strcmp(plot_prcs,'plot')
        shg
        plot(struct_out(i).sig);
        axis tight
        pause(2);
    end
    struct_out(i).sig = struct_out(i).sig.*win;
    if strcmp(plot_prcs,'plot')
        plot(struct_out(i).sig);
        pause(2);
    end
    struct_out(i).sig = filtfilt(B,A,struct_out(i).sig);
    if strcmp(plot_prcs,'plot')
        plot(struct_out(i).sig);
        axis tight
        pause(2);
    end
%     struct_out(i).sig = wden(struct_out(i).sig,'modwtsqtwolog','s','mln',6,'fk8');
%     if strcmp(plot_prcs,'plot')
%         plot(struct_out(i).sig);
%         pause(2);
%     end
end

end