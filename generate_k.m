function [k] = generate_k(max);

k = [1,2,3,4];
i = 11;

while floor(2^((i-1)/4)) <= max
    k(i-6) = floor(2^((i-1)/4));
    i=i+1;
end

k = k(k<=max);