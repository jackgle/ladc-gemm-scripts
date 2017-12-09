function [KFD] = kfd(ts)

%Function to compute the Katz Fractal Dimension (KFD).
%
%INPUT:
%    ts: 1-D time series array
%
%OUTPUT:
%    KFD: the KFD of the set
%
%AUTHOR: Jack LeBien, 01/2017, LADC-GEMM

if isempty(ts)
	fprintf('The given time series is empty.\n');
    return
end

%--- Compute L
L = 0;
N = length(ts);
n = N - 1;
for i = 1:(N - 1)
    tmp = sqrt(1 + ((ts(i) - ts(i+1))^2));
    L = L + tmp;
end

%--- Compute d
dist = NaN(1,N-1);
for i = 2:N
    dist(i) = sqrt(((1 - i)^2) + ((ts(1) - ts(i))^2));
end
d = max(dist);

KFD = log10(n)/(log10(n) + log10(d/L));