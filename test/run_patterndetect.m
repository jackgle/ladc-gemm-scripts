% Run pattern detection and extraction
cs = click_extract(signal,target,-103,401,time,'test_file');
% Plot and highlight extracted frames
plot_extracts(cs,signal,time);