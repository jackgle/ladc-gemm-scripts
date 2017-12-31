function [dur] = dur_95intsty(sig,Mode,Fs)

if strcmp(Mode,'squared')
    dur = range(find(normalizeData(sig.^2) > .05));
elseif strcmp(Mode,'teag')
    dur = range(find(normalizeData(abs(teager(sig))) > .05));
else
    error('Wrong Mode input: ''squared'', or ''teag''');
end

dur =dur/Fs*10^6;