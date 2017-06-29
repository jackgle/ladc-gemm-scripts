function [fmat_clean] = reduce_data(fmat)

% Removes outliers in N-dimensional space based on 
% 4-nearest neighbors.

[~,Dnear]=knnsearch(fmat,fmat,'K',4);
[~,Dfar]=knnsearch(fmat,fmat,'K',20);
Dnear(:,1)=[];
Dfar(:,1)=[];
ok=ones(size(fmat,1),1);
for i=1:size(fmat,1)
    if mean(Dnear(i,:)) > mean(Dfar(i,:))
        ok(i)=0;
    end
end
fmat_clean=fmat(logical(ok));
