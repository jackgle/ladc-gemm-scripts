function [] = compare_list( signals, winsize )

% signals is a cell array of array name strings

if ~exist('winsize','var')
    winsize = 15;
end

nsig = length(signals);

for i = 1:nsig
    setGlobalx(signals{i});
end

clf
for i = 1:2:2*nsig
    varName = evalin('base', signals{round(i/2)});
    subplot(nsig,2,i);
    plot(norm_var(varName,-1,1));
    subplot(nsig,2,i+1);
    spectrogram(varName,hann(winsize),floor((98*winsize)/100),1024,'yaxis');
end

colormap( 1-gray.^3 ); %gamma-scaling

end

function normalized = norm_var(array, x, y)

     % Normalize to [0, 1]:
     m = min(array);
     range = max(array) - m;
     array = (array - m) / range;

     % Then scale to [x,y]:
     range2 = y - x;
     normalized = (array*range2) + x;
end

function setGlobalx(val)
global x
x = val;
end

