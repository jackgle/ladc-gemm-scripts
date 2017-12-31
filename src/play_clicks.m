function play_clicks(cstruct)
Fs = 192000;

for i = 1:length(cstruct)
  soundsc(cstruct(i).sig, Fs*0.01);
  pause(1);
end