function [kmax, v_hfdx] = find_kmax(X, kvect)

v_hfdx = zeros(length(kvect)-1,1);

for i = 2:length(kvect)
    
    kcut = kvect(1:i);
    
    v_hfdx(i-1) = hfd(X, kcut);
    
end

% clf;
% plot(kvect(2:end), v_hfdx);
% % axis([-50, inf, min(v_hfdx)-(0.5*std(v_hfdx)), max(v_hfdx)+(0.5*std(v_hfdx))]);
% xlabel('Max k');
% ylabel('Higuchi FD');

kmax = kvect(find(v_hfdx==min(v_hfdx))+1);