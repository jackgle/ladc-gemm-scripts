function [mfd] = mfd(signal)

% Here the Katz-Castiglioni fractal dimension is calculated

n = length(signal);
d = range(signal);
L = 0;
for i = 1:n-1
    L = L + abs(signal(i+1)-signal(i));
end

mfd = log(n-1)/(log(n-1) + log(d/L));