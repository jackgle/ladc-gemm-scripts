function [entropy] = renyi_entropy(x,alpha)

% x = interp(x,5);
x=double(x(:));
% nbins = round(range(x)/((2*iqr(x)/nthroot(length(x),3)))); % Freedman-Diaconis
p = hist(x,50);
p = p/sum(p);

entropy = (1/(1-alpha))*log2(sum(p.^alpha));