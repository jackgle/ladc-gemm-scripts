function [dim] = corr_dim(data, emb_dim, tau, rvect)

%   PURPOSE: This function will estimate the correlation dimension of a
%   one-dimensional signal by the Grassberger-Procaccia algorithm
%
%   IN:     - data      - a one-dimensional signal
%           - emb_dim   - integer embedding dimension
%           - tau       - integer sample interval for embedding
%           - rvect     - vector array of distance r values to sweep
%   
%   OUT:    - dim       - estimated correlation dimension of the signal
%
%   VERSION: v1.1, 03/24/2017, Jack LeBien, LADC-GEMM

data = data(:);

n = length(data);

% Parse input
if ~exist('tau','var')
    tau = 1;
end
if ~exist('rvals','var')
    sd = std(data,1);
    rvect = generate_r(0.1*sd, 0.5*sd, 1.03);
end


% Embed time series
orbit = zeros(n-emb_dim+1, emb_dim);
for i = 1:n-emb_dim+1
    orbit(i,:) = data(i:tau:i+emb_dim-1);
end

% Get distance matrix
dists = pdist(orbit);

% Correlation sum
csums = zeros(1,length(rvect));
for i = 1:length(rvect)
    csums(i) = (2.0/(n*(n-1)))*sum(dists < rvect(i));
end
%csums = csums(csums~=0);
%rvals = rvals(csums~=0);

% Fit polyline
if isempty(csums)
    poly = [];
else
    poly = polyfit(log(rvect), log(csums), 1);
end
dim = poly(1);

% Plot log(r) vs log(C(N,r)) and polyfit
clf;
plot(log(rvect), log(csums), '*', log(rvect), polyval(poly,log(rvect),'-'));
grid on
xlabel('ln(r)');
ylabel('ln(C(N,r))');
annotation('textbox', [.15 .8 .1 .1], 'String', ...
                ['Slope of fit: ',num2str(poly(1))]);

end

function [log_r] = generate_r(min_r, max_r, fact)
% 	Creates a list of values by successively multiplying a minimum value min_r by
% 	a fact > 1 until a maximum value max_r is reached.
% 
% 	Args:
% 		min_r (float): minimum value (must be < max_r)
% 		max_r (float): maximum value (must be > min_r)
% 		fact (float): fact used to increase min_r (must be > 1)
% 
% 	Returns:
% 		list of floats: min_r, min_r * fact, min_r * fact^2, ... min_r * fact^i < max_r

assert(max_r > min_r)
assert(fact > 1)
max_i = round(floor(log(1.0 * max_r / min_r) / log(fact)));
log_r = zeros(1,max_i + 1);
for i = 1:max_i+1
    log_r(1,i) = min_r*(fact^(i-1));
end
end