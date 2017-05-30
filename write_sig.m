function [] = write_sig(signal)

fileID = fopen('sig_out.dat','w');

for i = 1:length(signal)
    fprintf(fileID,'%.12f\n',signal(i));
end

fclose(fileID);