function [cs] = click_extract(signal, time, method, dB_thresh, frame_size, filename)

% NAME: click_extract (v2.3)
% 
% INPUTS: (1) signal : 1xn Input signal
%
%         (2) time : Time array of signal
%
%         (3) method : If == 'Amp', voltage amplitude threshold will be used, if == 'TK',
%                      Teager-Kaiser amplitude threshold will be used, if an array is input,
%                      matched filtering will be used
%
%         (4) dB_thresh : Decibel level of the detection threshold
%
%         (5) frame_size : The frame size in number of samples to extract
%                           for each click. If an even number is input, it
%                           will automatically be incremented by one. The
%                           detected peak will correspond to the center 
%                           sample of the frame
%
%         (6) filename : String containing source file name
%
% OUTPUT: The function outputs a structure array with each struct containing
%         information about a detected click. Currently the subfields for
%         each click contain:
%
%                       (1) .sig :          The framed signal containing
%                                           the click.
%
%                       (2) .sample_pk :    The sample number of the
%                                           frame's detected peak.
%
%                       (3) .time_pk :      The time array value of the 
%                                           frame's detected peak.
%
%                       (4) .time :     The time array of the frame.
%
%                       (5) .sample :   The sample number array of the
%                                           frame
%                       (6) .filename :     EARS file name
%
%                       (7) .noise :        noise estimate collected as
%                                           first 3-13 ms of signal
%
%
% NOTES: 
%       
%       If a short signal for matched filtering is provided, this program takes 
%       the cross correlation of the given short
%       signal and the given long signal, keeping the long signal stationary.
%       Segments of the long signal are extracted in frames where there
%       are local maxima in the cross-correlation. The cross-correlation
%       oscillates as the given click passes in and out of phase with
%       clicks in the signal. The algorithm extracts centered on the maximum of each
%       of these peak clusters.
%
%       Here is an example of iterating through the structure fields created
%       by this program:
%
%           for i = 1:len(cs)
%               soundsc(cs(i).sig, Fs*0.01);
%               pause(1);
%           end
%
% AUTHOR: Jack LeBien, 08/2016
%
% MODIFICATIONS:
%
%       v2.0, 11/6/16, Jack LeBien - Framed clicks can now be extracted based on
%       local maxima of the cross-correlation with a given framed
%       click.
%       
%       v2.1, 11/8/16, Jack LeBien - Fixed a minor user interface bug. Changed
%       frame plot navigation keys.
%
%       v2.2, 03/26/17, Jack LeBien - Now has option to detect by
%       Teager-Kaiser energy
%
%       v2.3, 05/12/17, Jack LeBien - Updated notes, added noise estimate
%       output

if iscolumn(signal)
    signal=signal';
end

if nargin==4 || isempty(time)
    time = 1:size(signal,2);
end

version = 'v2.3';
fprintf('\n\n\t\tclick_extract %s', version);
fprintf('\n\nWorking...');

% Ensure the frame size is odd so that the click can be centered
if (mod(frame_size,2)==0)
    frame_size = frame_size+1;
end

%% Apply 10-pole Butterworth bandpass filter (15-95 kHz) before detection
[B,A] = butter(5, [(15000*2)/192000 (95000*2)/192000]);
signal = filtfilt(B,A,signal);

%% Find the values and locations of all local maxima
if ~isempty(method)
    if strcmp(method,'TKE')
        sig_T = teager(signal,2);
        [pks, locs] = findpeaks(abs(sig_T));
        ystring = 'Teager-Kaiser Energy (dB)';
    elseif isnumeric(method)
        sig_T = xcorr(signal, method);
        sig_T = sig_T((size(signal,2)-round(frame_size/2)):(end-round(frame_size/2)));
        [pks, locs] = findpeaks(real(20*log10(sig_T)));
        ystring = 'Cross Correlation Level (dB)';
        sig_T=real(20*log10(sig_T));
    elseif strcmp(method,'Amp')
        sig_T = signal;
        [pks, locs] = findpeaks(real(20*log10(sig_T)));
        ystring = 'Amplitude (dB)';
        sig_T=real(20*log10(sig_T));
    else
        error('Incorrect method argument. Options: ''Amp'', ''Cross'', ''TKE''');
    end
else
    error('Empty methods input');
end
%% Get the locations of maxima with amplitudes above the given threshold
slocs = locs(pks>dB_thresh);
fprintf('\n\nNumber of significant peaks detected: %i\n',size(slocs,2));

%% Interface for checking click detection threshold
fprintf('\n------------------------------------------\nEnter 1 if you wish to check the threshold.\nOtherwise, press RETURN.\n\n')
fprintf('\t');
i = input('');
if ~isempty(i) && i~=1
    error('Invalid input.')
end

if ~isempty(i)
    clf;
    plot(sig_T,'Color',[0 0.4470 0.7410]);
    axis tight
    hold on
    xlabel('Sample');
    ylabel(ystring);
    fig = gcf;
    figure(fig);
    pkCIHi(1:size(sig_T,2)) = dB_thresh;
    plot(pkCIHi,'--m');
    hold off
    fprintf('\n------------------------------------------------------------\nIf you wish to change the threshold, type a new value and press RETURN.\nOtherwise, press RETURN.\n\n');
    fprintf('\t');
    dB_thresh = input('');
    while(~isempty(dB_thresh))
        slocs = locs(pks>dB_thresh);
        fprintf('\nNumber of peaks detected: %i\n\n',size(slocs,2));
        clf;
        plot(sig_T,'Color',[0 0.4470 0.7410]);
        axis tight
        hold on
        xlabel('Sample');
        ylabel(ystring);
        fig = gcf;
        figure(fig);
        hold on
        pkCIHi(1:size(sig_T,2)) = dB_thresh;
        plot(pkCIHi,'--m');
        hold off
        fprintf('\t');
        dB_thresh = input('');
    end
    close(fig);
end
    
%% Attempt to filter out all peak locations of given click but that of the max peak

i = 2;
slocs_temp=slocs(1);
slocs_out=[];
while 1
    if slocs(i)<(slocs(i-1)+(floor((frame_size/2))))
        if i == size(slocs, 2)
            slocs_out = [slocs_out,slocs_temp(sig_T(slocs_temp)==max(sig_T(slocs_temp)))];
            slocs_temp=[];
        end
        slocs_temp=[slocs_temp,slocs(i)];
    elseif size(slocs_temp,2)>0
        slocs_out = [slocs_out,slocs_temp(sig_T(slocs_temp)==max(sig_T(slocs_temp)))];
        slocs_temp=[];
    end
    i = i + 1;
    if i > size(slocs,2)
        break;
    end
end

% s_len = size(slocs_out,2); % length of unfiltered structure
% cstruct = zeros(s_len);
cs = struct();
%% Create the new data structure, and noise estimate
for i = 1:size(slocs_out,2)
    
    if slocs_out(i)+((frame_size/2)-0.5) > size(signal,2)
        cs(i).sig = signal(slocs_out(i)-((frame_size/2)-0.5):end);
        cs(i).sample_pk = slocs_out(i);
        cs(i).time_pk = time(slocs_out(i));
        cs(i).time = time(slocs_out(i)-((frame_size/2)-0.5):end);
        cs(i).sample = slocs_out(i)-((frame_size/2)-0.5):size(signal,2);
    elseif slocs_out(i)-((frame_size/2)-0.5) < 1
        cs(i).sig = signal(1:slocs_out(i)+((frame_size/2)-0.5));
        cs(i).sample_pk = slocs_out(i);
        cs(i).time_pk = time(slocs_out(i));
        cs(i).time = time(1:slocs_out(i)+((frame_size/2)-0.5));
        cs(i).sample = 1:slocs_out(i)+((frame_size/2)-0.5);
    else
        cs(i).sig = signal(slocs_out(i)-((frame_size/2)-0.5):slocs_out(i)+((frame_size/2)-0.5));
        cs(i).sample_pk = slocs_out(i);
        cs(i).time_pk = time(slocs_out(i));
        cs(i).time = time(slocs_out(i)-((frame_size/2)-0.5):slocs_out(i)+((frame_size/2)-0.5))';
        cs(i).sample = slocs_out(i)-((frame_size/2)-0.5):slocs_out(i)+((frame_size/2)-0.5);
    end
    cs(i).filename = filename;
    cs(i).noise = signal(.003*192000:round(.013*192000)); % First 3-13 ms of file collected as noise estimate
end

len = length(cs);

fprintf('Number of frames extracted: %i\n\n',len);

fprintf('------------------------------------------------\nPress the left and right arrow keys to navigate through\nplotted frames.\n\nTo discard signals, enter the plot numbers of\nthe undesired signals in the terminal, each followed by\nRETURN. Single quotes are not needed.\n\nPress ESC in the figure when finished.\n\n');

%% Interface for filtering unwanted signals from the structure
i=1;
j=1;
clf;
while(1)
    if i == 1
        for j = 1:4
            if (i-1)+j > len
                break;
            end
%             fields{(i-1)+j} = char(fields((i-1)+j));
            subplot(2,2,j);
            plot(cs((i-1)+j).time,cs((i-1)+j).sig);
            axis tight
            title((i-1)+j,'FontSize',14);
            xlabel('Time');
        end
    else
        k = waitforbuttonpress;
        switch k
            case 1
                key = get(k,'currentcharacter');
%                 modifier = get(k,'currentModifier');
                switch key
                    case 28
                        if i<9
                            continue;
                        end
                        i = i - 8;
                        for j = 1:4
                            subplot(2,2,j);
                            plot(cs((i-1)+j).time,cs((i-1)+j).sig);
                            axis tight
                            title((i-1)+j,'FontSize',14);
                            xlabel('Time')
                        end
                    case 29
                        if ((i-1)+j) > len && mod(len,4)==0
                            continue;
                        end
                        if  i > len
                            continue;
                        end
                        if ((i-1)+j) > len-4
                            clf;
                        end
                        for j = 1:4
                            if ((i-1)+j) > len
                                break;
                            end
                            subplot(2,2,j);
                            plot(cs((i-1)+j).time,cs((i-1)+j).sig);
                            axis tight
                            title((i-1)+j,'FontSize',14);
                            xlabel('Time')
                        end
                    case 27
                        break;
                    otherwise
                        continue;
                end
            otherwise
                continue;
        end
    end
    i = i + 4;
end
close(k);

discard = '\0';
delv=[];
while ~isempty(discard)
    if ~strcmp(discard,'\0')
        if isnumeric(discard) && discard>length(cs)
            fprintf('\n%s was not a valid index.\n',discard)
        else
            delv=[delv,discard];
        end
    end
    discard = input('');
end

cs(delv)=[];

fprintf('Thank you. Goodbye. \n\n');





