function [ accuracy, nmclass ] = cpurity(idx, idx_true, k)

errors = 0;

if length(unique(idx))<k
    error('Empty clusters');
end
modes=nan(1,k);
nmclass=0;

for i = 1:k
    M = idx_true==i;
    if ~ismember(mode(idx(M)),modes)
        errors = errors + length(find(idx(M)~=mode(idx(M))));
        modes(i) = mode(idx(M));
    else
        disp('Warning: Non-unique modal classes');
        beep
        nmclass=1;
        num = setdiff(modes,mode(idx(M)));
        errors = errors + length(find(idx(M)~=num(1)));
        modes(i) = num(1);
    end
end
l = length(idx);
accuracy = (l-errors)/l;


end

