function [enhanced_signal] = spectral_subtract(sig)

% [sig,~] = readEARS(file);
fs=192000;
NFFT = 1024;
WINLEN = 1024/fs; %frame length in ms
WINSTEP = 0.001;
frames = frame_sig(sig, WINLEN*fs, WINSTEP*fs, @hamming);
cspec = fft(frames,NFFT,2); % complex spectrum
pspec = abs(cspec).^2; % power spectrum of noisy signal
phase = angle(cspec);
 
% do spectral subtraction, produce modified_pspec
noise_est = mean(pspec(1:3,:)); % noise_est is estimated from first three frames
clean_spec = pspec - repmat(noise_est,size(pspec,1),1); % subtract noise_est from pspec
clean_spec(clean_spec < 0) = 0; % negative power spectrum is not allowed
 
reconstructed_frames = ifft(sqrt(clean_spec).*exp(phase),NFFT,2);
reconstructed_frames = real(reconstructed_frames(:,1:WINLEN*fs)); % sometimes small complex residuals stay behind
enhanced_signal = deframe_sig(reconstructed_frames,length(sig),WINLEN*fs,WINSTEP*fs,@hamming);
 
% soundsc(enhanced_signal,fs); % listen to our enhanced signal