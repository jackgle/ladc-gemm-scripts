function [ accuracy ] = cpurity(idx, idx_true, k)

errors = 0;

if range(idx)+1<k
    error('Empty clusters');
end
modes=nan(1,k);

for i = 1:k
    M = idx_true==i;
    if ~ismember(mode(idx(M)),modes)
        errors = errors + length(find(idx(M)~=mode(idx(M))));
        modes(i) = mode(idx(M));
    else
        sprintf('%s','Warning: Non-unique modal classes');
        num = setdiff(modes,mode(idx(M)));
        errors = errors + length(find(idx(M)~=num(1)));
        modes(i) = num(1);
    end
end
l = length(idx);
accuracy = (l-errors)/l;


end

