function [ fmat, fVals, click_fft ] = feature_extract(struct_in)


% Buffers and constants for spectral analysis
% b =        7; % WPD levels
N_FFT =     512; % Length of FFT
click_fft = zeros(length(struct_in), N_FFT);
% pxx = zeros(length(struct_in), N_FFT/2+1);
pxx = zeros(length(struct_in), N_FFT/2);
Fs =        192000;
fVals =     Fs*(0:(N_FFT/2)-1)/N_FFT;
fbinsz =    fVals(2)-fVals(1);

% T = wpdec(struct_in(1).sig,b,'db4');
% %     T = besttree(T);
% T = wp2wtree(T);
% temp = wpcoef(T,2);

% nfeatures = N_FFT/2+1;2
% nfeatures = b+1;
nfeatures = 3;

fmat = zeros(length(struct_in),nfeatures);
tic
for i = 1:length(struct_in)
    
    click_cur = struct_in(i).sig/max(abs(struct_in(i).sig));
    
%     env = abs(hilbert(click_cur));
%     mx=max(env);
%     mx_dB = 20*log10(mx);
%     thresh = 10^((mx_dB-10)/20);
%     click_cur = click_cur(find(env>=thresh, 1 ):find(env>=thresh, 1, 'last' ));
    
    click_interp = interp(click_cur,5);
%     click_norm = normalizeData(click_cur);
   
    click_fft(i,:) = fft(click_cur, N_FFT);
    L = length(click_cur);
    pxx(i,:) = click_fft(i,1:N_FFT/2).*conj(click_fft(i,1:N_FFT/2))/(N_FFT*L);
    pxx(i,2:end-1) = 2*pxx(i,2:end-1);
    pxx(i,:) = 10*log10(pxx(i,:));

%     [pxx(i,:),fVals] = pwelch(click_cur,[],[],N_FFT,Fs);
%     fmat(i,:) = abs(pxx(i,:));
%     plot(fVals,pxx);

    %% Spectral;
    % Peak frequency
%     fmat(i,2) = fVals(pxx(i,:)==max(pxx(i,:)))+fbinsz/2;

    % -10 dB Bandwidth
%     fmat(i,1) = length(pxx(i,(pxx(i,:) >= ...
%                                      max(pxx(i,:))-10)))*fbinsz;
                                 
%     -20 dB center frequency
%     fmat(i,2) = mean(fVals((pxx(i,:) >= max(pxx(i,:))-20)))+fbinsz/2;
    
    % Spectral centroid
    cfft = abs(click_fft(i,1:N_FFT/2));
    fmat(i,3) = (sum(fVals.*cfft)/sum(cfft))+fbinsz/2;
%     fmat(i,3) = (sum(fVals.*pxx(i,:))/sum(pxx(i,:)))+fbinsz/2;
    %% Duration                           
%     fmat(i,1) = dur_95intsty(click_cur,'teag',Fs);
%     fmat(i,1) = dur_95intsty(click_cur,'squared',Fs);
    fmat(i,1) = dur_10db(click_cur,Fs);
%     fmat(i,4) = dur_3db(click_cur,Fs);
%     fmat(i,1) = dur_95e(click_interp,Fs*5);
%     fmat(i,1) = dur_95t(click_interp,Fs);
%     fmat(i,8) = (length(click_cur)-40)/Fs*10^6;
    %% Fractal Dimension
    fmat(i,2) = hfd(click_interp,1:75);
    % KFD
%     fmat(i,2) = kfd(click_interp);
    % ABD
%     fmat(i,3) = abfd(click_interp);
%     MFD
%     fmat(i,4) = mfd(click_interp);
    % Correlation Dimension
%     fmat(i,12) = corr_dim(click_cur,3);
    %% Entropy
%     fmat(i,6) = shannon_entropy(click_cur);
%     fmat(i,6) = renyi_entropy(click_cur,3);
%     fmat(i,1) = wentropy(click_cur,'shannon');
    %% Max Amplitude
%     fmat(i,14) = max(click_cur);
    %% Wavelet Packet Decomposition
    
    % Wavelet decomposition
%     [C, L] = wavedec(click_cur,b,'db4');
%     A = appcoef(C,L,'db4',b);
%     D = detcoef(C,L,b);
%     fmat(i,1:2*length(A)) = [A, D];
%     fmat =fmat(:,1:2*length(A));

    % Wavelet packet decomposition
%     T = wpdec(click_cur,b,'sym4');
%     T = besttree(T);
%     T = wp2wtree(T);
%     fmat(i,:) = wpcoef(T,2);
%     fmat(i,:)  = wenergy(T);
%     temp = wpcoef(T,2);
%     fmat(i,1:length(temp)) = temp;
%     fmat = fmat(:,1:2^treedpth(T));
    
    % Maximal overlap discrete wavelet packet transform
%     [~,~,~,~,fmat(i,1:end)] = modwpt(click_cur,b,'db8');
end
toc
% [~, fmat] = pca(fmat);
% fmat = fmat(:,1:3);

% mdl = fscnca(fmat,idx_true);
end
