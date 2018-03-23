function [S_dn] = mod_spectral_subtract(S)

% Modified Spectral Subtraction (M. Towsey et al. 2010)
% Author: Jack LeBien, Nov. 2017

% S should have frequency over rows and time over columns

nbins=size(S,2);    % Number of bins for histogram
win1 = 7;           % Window size for histogram moving average
win2 = 5;           % Window size for mode intensity array moving ave.

S = abs(S);         
modeVal=zeros(size(S,1),1); % Empty array for mode values

% S_dn = wiener2(S,[3 3]); % Wiener filter spectrogram before noise removal
S_dn=S; % Do this if not wiener filtering

for ii = 1:size(S,1)    % Loop over frequencies and get mode intensities
    [counts,centers] = hist(S(ii,:),nbins);
    counts = movmean(counts,win1);
    modeVal(ii) = mean(centers(counts(1:round(end/2))==max(counts(1:round(end/2)))));
end

modeVal=movmean(modeVal,win2); % Apply moving average to mode intensities

for ii = 1:size(S,1)    % Loop over frequencies and subtract mode intensity
    S_dn(ii,:) = S_dn(ii,:)-modeVal(ii);
end

S_dn(S_dn<0)=0; % Truncate negative amplitudes to 0

   
    