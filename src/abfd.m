function [D, poly] = abfd(signal, dtv, graph)

% This function computes the adapted box dimension proposed by Henderson et
% al '98 of a given array
%
% VERSION: v1.0, 03/24/2017, Jack LeBien, LADC-GEMM

n = length(signal);

if ~exist('dtv','var') || isempty(dtv)
    dtv = 2:length(signal)/2;
    dtv = dtv';
end

m_exts = zeros(length(dtv),1);
for i = 1:length(dtv)
    exts = zeros(round(length(signal)/dtv(i)-1),1);
    for j = 1:round(length(signal)/dtv(i)-1)
        exts(j) = range(signal(dtv(i)*(j-1)+1:dtv(i)*(j-1)+1+dtv(i)));
    end
    m_exts(i) = mean(exts);
end

poly = polyfit(log(dtv), log(n*m_exts),1);

D = 2 - poly(1);

% Plot log(dt) vs log(E(dt)) and polyfit
if nargin == 3 && strcmp(graph,'graph')
    clf;
    plot(log(dtv), log(n*m_exts), '*', log(dtv), polyval(poly,log(dtv),'-'));
    grid on
    xlabel('ln(dt)');
    ylabel('ln(E(dt))');
    annotation('textbox', [.15 .8 .1 .1], 'String', ...
                    ['D = 2 - slope = ',num2str(2-poly(1))]);
end

end