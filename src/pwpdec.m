
function [T, pfv] = pwpdec(sig,centr,fs,wv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will produce a perceptual wavelet packet
% decomposition tree as presented in (Algorithm 3):
%
%   Towsey et al. 2015 "Acoustic feature extraction using perceptual wavelet 
%   packet decomposition for frog call classification"
%
% INPUTS:
%
%   sig - input signal to decompose using PWPD (optional)
%   centr - array of centroidal dominant frequency values of each class
%   fs - sampling frequency (Hz)
%   wv - base wavelet (e.g. 'db4')
%
% OUTPUTS:
%
%   T - perceptually motivated wavelet packet decomposition tree
%
% NOTE:
%
%   If you are only interested in determining the structure of the WPD tree
%   sig can be empty, and a dummy signal of zeros will be used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if isempty(sig)
    sig = zeros(100,1);
end

ny = fs/2; % Get half fs (maximum resolvable frequency)
pfv = 0; % Initialize perceptual frequency vector

T = wpdec(sig,1,wv); % Perform first level decomposition

% Get distances between neighboring centroids
centr_sort = sort(centr); 
D = zeros(length(centr)-1,1);
for ii = 2:length(centr)
    D(ii-1) = centr_sort(ii)-centr_sort(ii-1);
end

while(1)
    
    [~,tmp] = otnodes(T); % Get terminal node indices (in frequency order)
    
    for ii = 1:size(tmp,1) % Loop through terminal nodes        
        
        [l,n] = ind2depo(2,tmp(ii)); % Get depth/pos of current node
        
        tmp2 = frqord([2^l-1:2*(2^l-1)]'); % Get frequency-order of nodes (of a full tree) at level of current node
        bandNo = find(tmp2==n+1)-1; % Get the band index associated with the current node
        
        lo = (ny/(2^l))*bandNo;
        hi = (ny/(2^l))*(bandNo+1);

        if length(find(centr>lo & centr<hi))>1 % If multiple centroids lie within the band
            if (hi-lo) > min(D) % And if resolution of band is less minimum distance b/w centroids
                T = wpsplt(T,[l,n]); % Decompose the band
            end
        end
        
    end
    
    [~,tmp2] = otnodes(T);
    
    if isequal(tmp2,tmp) % If the tree has not changed since last iteration (no bands split)
        
        if nargin > 1
            % Store the PWPD frequency bands in a vector
            for ii = 1:size(tmp,1)      
                [l,n] = ind2depo(2,tmp(ii));
                tmp2 = frqord([2^l-1 : 2*(2^l-1)]');
                bandNo = find(tmp2==n+1)-1;
                pfv = [pfv,(ny/(2^l))*(bandNo+1)];
            end
        end
        
        return; % End function
    end
end
        

    