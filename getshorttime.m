function [shorttime] = getshorttime(time, Fs)

deltat = 1/Fs;
timeLength=length(time);
shorttime = zeros(1,length(time));
shorttime(1)=time(1);

for i=2:timeLength+1
    
    shorttime(i)=shorttime(i-1) + deltat;
    
end

shorttime = shorttime(2:end);
