function [max_corrs] = correlate_struct( struct, testsig )

% function to take cross correlation against normalized structure signals

if ~isrow(testsig) % make sure it's a row
    testsig = testsig';
end

% fields = fieldnames(struct);

max_corrs = zeros(length(struct),1);
for i = 1:length(struct)
    y = xcorr(normr(struct(i).sig),normr(testsig));
    max_corrs(i) = max(y);
end

stem(1:length(struct),max_corrs);

end


