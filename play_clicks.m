Fs = 192000;

fields = fieldnames(click_struct);
for i = 1:size(fields,1)
  soundsc(click_struct.(fields{i}).sig, Fs*0.01);
  pause(1);
end