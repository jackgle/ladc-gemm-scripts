function [ pxx, f ] = s_waterfall( struct, range, method )

clear pxx f
% fields = fieldnames(struct);

clf;

if exist('method','var') && strcmp(method,'pwelch')
    for i = 1:length(struct)
        [pxx(i,:),f] = pwelch(normr(struct(i).sig),[],[],[],192000);
    end
elseif ~exist('method','var')
    for i = 1:length(struct)
        [pxx(i,:),f] = periodogram(normr(struct(i).sig),[],[],192000);
    end
else
    error('Invalid input');
end

if ~exist('range','var') || isempty(range)
    range = 1:length(struct);
end

waterfall(f,1:length(struct),10*log10(pxx(range,:)));
xlabel('freq');
ylabel('sample');
zlabel('dB/Hz');
zlim([-160 -60]);
end

