function [entropy] = shannon_entropy(x)

% x = interp(x,5);
x=double(x(:));
% nbins = round(range(x)/((2*iqr(x)/nthroot(length(x),3)))); % Freedman-Diaconis
p = hist(x,50);
p = p/sum(p);

entropy = -sum(p.*log2(p+eps));