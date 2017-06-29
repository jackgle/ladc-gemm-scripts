% Run pattern detection and extraction
cs = click_extract(signal,time, target,-103,401,'test_file');
% Plot and highlight extracted frames
plot_extracts(cs,signal,time);