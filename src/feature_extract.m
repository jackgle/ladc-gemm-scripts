function [ fmat, fVals, click_fft ] = feature_extract(struct_in)


% Buffers and constants for spectral analysis
N_FFT =     512; % Length of FFT
click_fft = zeros(length(struct_in), N_FFT);
pxx = zeros(length(struct_in), N_FFT/2);
Fs =        192000;
fVals =     Fs*(0:(N_FFT/2)-1)/N_FFT;
fbinsz =    fVals(2)-fVals(1);
% b =        7; % WPD levels

interpFactor=5;
nfeatures = 1;

fmat = zeros(length(struct_in),nfeatures);
tic
for i = 1:length(struct_in)
    
    click_cur = normr(struct_in(i).sig); % Normalize signal to an energy of 1
    
    % The below lines would be used to truncate the signal to the edges of
    % the -10 dB duration
%     env = abs(hilbert(click_cur));
%     mx=max(env);
%     mx_dB = 20*log10(mx);
%     thresh = 10^((mx_dB-10)/20);
%     click_cur = click_cur(find(env>=thresh, 1 ):find(env>=thresh, 1, 'last' ));
    
    click_interp = interp(click_cur,interpFactor);
   
    click_fft(i,:) = fft(click_cur, N_FFT);
    L = length(click_cur);
    pxx(i,:) = click_fft(i,1:N_FFT/2).*conj(click_fft(i,1:N_FFT/2))/(N_FFT*L);
    pxx(i,2:end-1) = 2*pxx(i,2:end-1);
    pxx(i,:) = 10*log10(pxx(i,:));
    cfft = abs(click_fft(i,1:N_FFT/2));

%     [pxx(i,:),fVals] = pwelch(click_cur,[],[],N_FFT,Fs);
%     fmat(i,:) = abs(pxx(i,:));
%     plot(fVals,pxx);

    %% Spectral;
    % Peak frequency
    fmat(i,1) = fVals(pxx(i,:)==max(pxx(i,:)))+fbinsz/2;

    % -10 dB Bandwidth
    fmat(i,2) = powerbw(click_cur,Fs,[],10);
    
    % -3 dB Bandwidth
    fmat(i,3) = powerbw(click_cur,Fs,[],3);
                                 
%     -20 dB center frequency
    fmat(i,4) = mean(fVals((pxx(i,:) >= max(pxx(i,:))-20)))+fbinsz/2;
    
    % Spectral centroid
    fmat(i,5) = (sum(fVals.*cfft)/sum(cfft))+fbinsz/2;
    %% Duration                           
    fmat(i,6) = dur_95intsty(click_cur,'teag',Fs);
    fmat(i,7) = dur_95intsty(click_cur,'squared',Fs);
    fmat(i,8) = dur_db(click_cur,Fs,10);
    fmat(i,9) = dur_db(click_cur,Fs,3);
    fmat(i,10) = dur_95e(click_interp,Fs*interpFactor);
%     fmat(i,1) = dur_95t(click_interp,Fs);
%     fmat(i,8) = (length(click_cur)-40)/Fs*10^6; % For if the click has already been truncated to -10 dB endpoints
    %% Fractal Dimension
    fmat(i,11) = hfd(click_interp,1:75);
    % KFD
    fmat(i,12) = kfd(click_interp);
    % ABD
    fmat(i,13) = abfd(click_interp);
%     MFD
    fmat(i,14) = mfd(click_interp);
    % Correlation Dimension
%     fmat(i,12) = corr_dim(click_cur,3);
    %% Entropy
    fmat(i,15) = shannon_entropy(click_cur);
    fmat(i,16) = renyi_entropy(click_cur,3);
    fmat(i,17) = wentropy(click_cur,'shannon');
    fmat(i,18) = wentropy(click_cur,'log energy');
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
end