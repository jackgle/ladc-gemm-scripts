function [max_corrs] = corr_s( struct, testsig )

% function to take cross correlation against normalized structure signals

if ~isrow(testsig) % make sure it's a row
    testsig = testsig';
end

% fields = fieldnames(struct);

max_corrs = zeros(length(struct),1);
for i = 1:length(struct)
%     y = xcorr(norm_var(struct(i).sig,-1,1),norm_var(testsig,-1,1));
    y = xcorr(normr(struct(i).sig),normr(testsig));
    max_corrs(i) = max(y);
end

stem(1:length(struct),max_corrs);

end

function normalized = norm_var(array, x, y)

     % Normalize to [0, 1]:
     m = min(array);
     range = max(array) - m;
     array = (array - m) / range;

     % Then scale to [x,y]:
     range2 = y - x;
     normalized = (array*range2) + x;
end

