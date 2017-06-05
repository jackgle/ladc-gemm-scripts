function [] = compare( winsize, signal1, signal2, signal3)

% signals is a cell array of array name strings

if ~isempty(winsize)
    winsize = 15;
end

clf 

n = nargin-1;
    
subplot(n,2,1);
plot(norm_var(signal1,-1,1));
axis tight
subplot(n,2,2);
spectrogram(signal1,hann(winsize),floor((98*winsize)/100),1024,'yaxis');
subplot(n,2,3);
plot(norm_var(signal2,-1,1));
axis tight
subplot(n,2,4);
spectrogram(signal2,hann(winsize),floor((98*winsize)/100),1024,'yaxis');
if nargin > 3
    subplot(n,2,5);
    plot(norm_var(signal3,-1,1));
    axis tight
    subplot(n,2,6);
    spectrogram(signal3,hann(winsize),floor((98*winsize)/100),1024,'yaxis');
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

