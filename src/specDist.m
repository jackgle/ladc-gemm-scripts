function D = specDist(x,y) 
% x = x/sum(x);
% for ii = 1:size(y,1)
%     y(ii,:) = y(ii,:)/sum(y(ii,:));
% end
y=y';
    D = zeros(size(y,2),1);
    for ii = 1:size(y,2)
%         D(ii) = 1-((x-mean(x))*(y(:,ii)-mean(y(:,ii))))/(sqrt((x-mean(x))*(x-mean(x))')*sqrt((y(:,ii)-mean(y(:,ii)))'*(y(:,ii)-mean(y(:,ii)))));
%         D(ii) = max(xcorr(x,y(:,ii)));
        tmp=corrcoef(x,y(:,ii));
        D(ii)=tmp(1,2);
%         D(ii) = sum(mscohere(x,y(:,ii)));

    end
end