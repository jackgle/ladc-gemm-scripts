function [mean_maxf, max_fv] = mean_maxf(signals,Fs)

% signals can be either a struct or an array;

if isstruct(signals)
    fields = fieldnames(signals);

    max_fv = zeros(length(fields),1);
    for i = 1:length(fields)
        [pxx, f]= periodogram(signals.(fields{i}).sig,[],[],Fs);
        max_fv(i) = f(pxx==max(pxx));
    end
        mean_maxf = mean(max_fv);
else
    [pxx, f]= periodogram(signals,[],[],Fs);
    mean_maxf = f(pxx==max(pxx));


end

