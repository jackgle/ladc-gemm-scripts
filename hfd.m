function [ hfdx ] = hfd( X, kvect, graph )

N = length(X);
j=1;
L_k = zeros(1,length(kvect));
errors = zeros(1,length(kvect));

for k = kvect
    
    L_m_k=zeros(k,1);

    for m = 1:k

        L_m1=0;
        for i = 1:floor((N-m)/k)
            L_m1 = L_m1 + abs(X(m+(i*k))-X(m+((i-1)*k)));
        end
    
        L_m_k(m) = (L_m1*((N-1)/((floor((N-m)/k))*k)))/k;
    
    end
    
    L_k(j) = mean(L_m_k);
    errors(j) = std(log(L_m_k));
    j = j+1;

end

plyfit = polyfit(log(kvect),log(1./L_k),1);
hfdx = plyfit(1);

if exist('graph','var') && strcmp(graph,'graph')
    clf;
    errorbar(log(kvect),log(L_k),errors,'ro');
    hold on
    plot(log(kvect), polyval(-plyfit, log(kvect)));
    axis tight
    grid on
    xlabel('ln(k)');
    ylabel('ln<L(k)>');
end
    

end

