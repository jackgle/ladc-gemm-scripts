function [ fmat ] = feature_extract( struct_in, kvect, norm)

% Buffers and constants for spectral analysis
b =        10; % WPD levels
N_FFT =     1024; % Length of FFT
click_fft = zeros(length(struct_in), N_FFT);
click_psd = zeros(length(struct_in), N_FFT/2);
% L =         size(struct_in(1).sig,2);
Fs =        192000;
fVals =     Fs*(0:(N_FFT/2)-1)/N_FFT;

%     fmat = [];
%     fmat =      zeros(length(struct_in),2^b);
    fmat =      zeros(length(struct_in),3);

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
    %% -10 dB Bandwidth
%     fmat(i,3) = length(click_psd(i,(click_psd(i,:) >= ...
%                                      max(click_psd(i,:))-10)));
    %% -20 dB center frequency
%     fmat(i,3) = mean(fVals((click_psd(i,:) >= max(click_psd(i,:))-20)));
    %% Spectral centroid
    fmat(i,3) = sum(fVals.*click_psd(i,:))/sum(click_psd(i,:));
    %% Duration                           
%     fmat(i,1) = dur_95intsty(click_cur,'teag',Fs);
    fmat(i,1) = dur_10db(click_cur,Fs);
%     fmat(i,1) = dur_95e(click_cur,Fs);
%     fmat(i,1) = dur_95t(click_cur,Fs);
    %% HFD
%     kmax = find_kmax(click_cur, kvect(1:17));
%     fmat(i,2) = hfd(click_cur,1:kvect(kvect==kmax));
    %% KFD
%     fmat(i,3) = kfd(click_cur);
    %% ABD
    fmat(i,2) = abfd(click_cur);
    %% Correlation Dimension
%     fmat(i,2) = corr_dim(click_cur,3);
    %% MFD
%     fmat(i,4) = mfd(click_cur);
    %% Max Amplitude
%     fmat(i,14) = max(click_cur);
    %% Wavelet Packet Decomposition
    
    % Wavelet decomposition
%     [C, L] = wavedec(click_cur,b,'db4');
%     A = appcoef(C,L,'db4',b);
%     D = detcoef(C,L,b);
%     fmat(i,1:2*length(A)) = [A, D];

    % Wavelet packet decomposition
%     T = wpdec(click_cur,b,'db8');
%     T = bestlevt(T);
%     fmat(i,:)  = wenergy(T);
%     temp = wpcoef(T,2);
%     fmat(i,1:length(temp)) = temp;
%     fmat = fmat(:,1:2^treedpth(T));
    
    % Maximal overlap discrete wavelet packet transform
%     [~,~,~,~,fmat(i,1:end)] = modwpt(click_cur,b,'db8');
end

% fmat = fmat(:,1:2*length(A));

% plot(T);

% [~, fmat] = pca(fmat);
% fmat = fmat(:,1:3);

% mdl = fscnca(fmat,idx_true);
% fmat = fmat(:,find(mdl.FeatureWeights > ___));

if nargin == 5 && strcmp(norm,'norm')
    fmat_norm = normalizeData(fmat');
    fmat = fmat_norm';
end

end
