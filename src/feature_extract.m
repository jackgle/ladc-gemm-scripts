function [ fmat ] = feature_extract( struct_in, noise, const, kvect, norm)

% Buffers and constants for spectral analysis
b =        6; % WPD levels
N_FFT =     1024; % Length of FFT
click_fft = zeros(length(struct_in), N_FFT);
click_psd = zeros(length(struct_in), N_FFT/2);
% L =         size(struct_in(1).sig,2);
Fs =        192000;
fVals =     Fs*(0:(N_FFT/2)-1)/N_FFT;
global noise_t
noise_t = teager(noise);

%     fmat =      zeros(length(struct_in),2^b+3);
    fmat =      zeros(length(struct_in),2);

for i = 1:length(struct_in)
    
    click_cur = struct_in(i).sig;
    
%     win = hann(length(click_cur));
%     click_win = click_cur.*win';
    
%     click_cur = normalizeData(click_cur);
    
    L = length(click_cur);
    
    click_fft(i,:) = fft(click_cur, N_FFT);
    click_psd(i,:) = click_fft(i,1:N_FFT/2).*conj(click_fft(i,1:N_FFT/2))/(N_FFT*L);
    click_psd(i,2:end-1) = 2*click_psd(i,2:end-1);
    click_psd(i,:) = 10*log10(click_psd(i,:));
%     click_psd(i,:) = pwelch(click_cur,hann(20),98*(1/5),1024);
%     
%     plot(fVals,click_psd);
    
    %% Peak frequency
%     fmat(i,3) = fVals(click_psd(i,:)==max(click_psd(i,:)));
    %% -3 dB Bandwidth
%     fmat(i,3) = length(click_psd(i,(click_psd(i,:) >= ...
%                                      max(click_psd(i,:))-3)));
    %% -20 dB center frequency
    fmat(i,3) = mean(fVals((click_psd(i,:) >= ...
                                     max(click_psd(i,:))-20)));
    %% Spectral centroid
%     fmat(i,3) = sum(fVals.*click_psd(i,:))/sum(click_psd(i,:));
    %% Duration                           
    fmat(i,1) = cduration(click_cur,const);
%     fmat(i,1) = ((range(find(normalizeData(click_cur.^2) > .05)))/192000)*10^6;
%     fmat(i,1) = (length(click_cur)/192000)*10^6;
    %% Bad Duration
%     fmat(i,1) = dur_95E(click_cur,noise);
    %% HFD
    kmax = find_kmax(click_cur, kvect(1:17));
    fmat(i,2) = hfd(click_cur,1:kvect(kvect==kmax));
    %% KFD
%     fmat(i,2) = kfd(click_cur);
    %% ABD
%     fmat(i,2) = abfd(click_cur);
    %% Correlation Dimension
%     fmat(i,2) = corr_dim(click_cur,3);
    %% MFD
%     fmat(i,2) = mfd(click_cur);
    %% Max Amplitude
%     fmat(i,3) = max(click_cur);
    %% Wavelet Packet Decomposition
    
    % Wavelet decomposition
%     [C, L] = wavedec(click_cur,b,'db4');
%     A = appcoef(C,L,'db4',b);
%     D = detcoef(C,L,b);
%     fmat(i,1:2*length(A)) = [A, D];

    % Wavelet packet decomposition
%     T = wpdec(click_cur,b,'db4');
%     T = bestlevt(T);
%     fmat(i,:)  = wenergy(T);
%     temp = wpcoef(T,2);
%     fmat(i,1:length(temp)) = temp;
%     fmat = fmat(:,1:2^treedpth(T));
    
    % Maximal overlap discrete wavelet packet transform
%     [~,~,~,~,fmat(i,4:end)] = modwpt(click_cur,b,'fk18');
end

% fmat = fmat(:,1:2*length(A));

% plot(T);

% [~, fmat] = pca(fmat);
% fmat = fmat(:,1:3);

% mdl = fscnca(fmat,idx_true);
% fmat = fmat(find(mdl.FeatureWeights > ___));

if nargin == 5 && strcmp(norm,'norm')
    fmat_norm = normalizeData(fmat');
    fmat = fmat_norm';
end

end

function [ dur ] = cduration( click, const )
global noise_t
% function to calculate the duration of an echolocation click
%
% const is chosen such that its product with the peak amplitude of a
% click of modal SNR is equal to 3. I chose example_C_lc as the reference
% signal.
%
% Fs is chosen here for EARS data: 192 kHz

Fs = 192000;
click = click(:)';
click_t = teager(click);
thresh = const*max(click_t)*(mean(noise_t)+3*std(noise_t));
dur = range(find(click_t > thresh));               
dur = (dur/Fs)*10^6; % give answer in microseconds

end
