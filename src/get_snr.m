function [ snratio ] = get_snr( cstruct )

l=length(cstruct(1).sig);
snratio=zeros(length(cstruct),1);
for i=1:length(cstruct)
    snratio(i) = snr(cstruct(i).sig,cstruct(i).noise(1:l));
end


end

