function [cs] = click_extract(signal, time, method, thresh, frame_size, filename)

% NAME: click_extract (v2.4)
% 
% INPUTS: (1) signal : 1xn Input signal
%
%         (2) time : Time array of signal
%
%         (3) method : If == 'Amp', voltage amplitude threshold will be used, if == 'TKEO',
%                      Teager-Kaiser amplitude threshold will be used, if an array is input,
%                      matched filtering will be used
%
%         (4) thresh : Decibel level of the detection threshold
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
% AUTHOR: Jack LeBien, 08/2016
%
% MODIFICATIONS:
%
%       v2.0, 11/6/16 - Clicks can now be extracted based on
%       local maxima of the cross-correlation with a given template
%       click.
%   
%       v2.1, 11/8/16 - Fixed a user interface bug. Changed
%       frame plot navigation keys.
%
%       v2.2, 03/26/17 - Now has option to detect by
%       Teager-Kaiser energy operator (TKEO)
%
%       v2.3, 05/12/17 - Updated notes, added noise estimate
%       output
%   
%       v2.4, 11/06/17 - Use findpeaks algorithm with MinPeakDistance and
%       MinPeakHeight

if iscolumn(signal)
    signal=signal';
end

if nargin==4 || isempty(time)
    time = 1:size(signal,2);
end

version = 'v2.4';
fprintf('\n\n\t\tclick_extract %s', version);
fprintf('\n\nWorking...');

% Ensure the frame size is odd so that the click can be centered
if (mod(frame_size,2)==0)
    frame_size = frame_size+1;
end

%% Pre-processing

% 10-pole Butterworth bandpass filter before detection
LowFc = 15000;
HiFc = 95000;
[B,A] = butter(5, [(LowFc*2)/192000 (HiFc*2)/192000]);
signal = filtfilt(B,A,signal);
% Wavelet denoising
% signal = wden(signal,'minimaxi','s','sln',5,'sym8');

%% Find the values and locations of all local maxima
if ~isempty(method)
    if strcmp(method,'TKEO')
        sig_p = teager(signal,2);
        ystring = 'Teager-Kaiser Energy';
    elseif isnumeric(method)
        sig_p = xcorr(signal, method);
        sig_p = sig_p((size(signal,2)-round(frame_size/2)):(end-round(frame_size/2)));
        sig_p=real(20*log10(sig_p));
        ystring = 'Cross Correlation Level (dB)';
    elseif strcmp(method,'Amp')
        sig_p = signal.^2;
        ystring = 'Squared-Amplitude';
    else
        error('Incorrect method argument. Options: ''Amp'', ''Cross'', ''TKEO''');
    end
else
    error('Empty methods input');
end

%% Get the locations of maxima with amplitudes above the given threshold
if max(sig_p) < thresh
    fprintf('\n')
    error('Threshold too high')
end
[~,locs] = findpeaks(sig_p,'MinPeakDistance',(frame_size-1)/2,'MinPeakHeight',thresh);    

fprintf('\n\nNumber of clicks detected: %i\n',size(locs,2));

%% Interface for checking click detection threshold
fprintf('\n------------------------------------------\nEnter 1 if you wish to check the threshold.\nOtherwise, press RETURN.\n\n')
fprintf('\t');
i = input('');
if ~isempty(i) && i~=1
    error('Invalid input.')
end

if ~isempty(i)
    clf;
    plot(sig_p,'Color',[0 0.4470 0.7410]);
    axis tight
    if isnumeric(method)
    else
        ylim([0 thresh*2])
    end
    hold on
    xlabel('Sample');
    ylabel(ystring);
    fig = gcf;
    figure(fig);
    pkCIHi(1:size(sig_p,2)) = thresh;
    plot(pkCIHi,'--m');
    hold off
    fprintf('\n------------------------------------------------------------\nIf you wish to change the threshold, type a new value and press RETURN.\nOtherwise, press RETURN.\n\n');
    fprintf('\t');
    thresh = input('');
    while(~isempty(thresh))
        [~,locs] = findpeaks(sig_p,'MinPeakDistance',(frame_size-1)/2,'MinPeakHeight',thresh);   
        fprintf('\nNumber of peaks detected: %i\n\n',size(locs,2));
        clf;
        plot(sig_p,'Color',[0 0.4470 0.7410]);
        axis tight
        if isnumeric(method)
        else
            ylim([0 thresh*2])
        end
        hold on
        xlabel('Sample');
        ylabel(ystring);
        fig = gcf;
        figure(fig);
        hold on
        pkCIHi(1:size(sig_p,2)) = thresh;
        plot(pkCIHi,'--m');
        hold off
        fprintf('\t');
        thresh = input('');
    end
    close(fig);
end
    
%% Create the new data structure

cs = struct();
for i = 1:size(locs,2)
    
    if locs(i)+((frame_size/2)-0.5) > size(signal,2)
        cs(i).sig = signal(locs(i)-((frame_size/2)-0.5):end);
        cs(i).sample_pk = locs(i);
        cs(i).time_pk = time(locs(i));
        cs(i).time = time(locs(i)-((frame_size/2)-0.5):end);
        cs(i).sample = locs(i)-((frame_size/2)-0.5):size(signal,2);
    elseif locs(i)-((frame_size/2)-0.5) < 1
        cs(i).sig = signal(1:locs(i)+((frame_size/2)-0.5));
        cs(i).sample_pk = locs(i);
        cs(i).time_pk = time(locs(i));
        cs(i).time = time(1:locs(i)+((frame_size/2)-0.5));
        cs(i).sample = 1:locs(i)+((frame_size/2)-0.5);
    else
        cs(i).sig = signal(locs(i)-((frame_size/2)-0.5):locs(i)+((frame_size/2)-0.5));
        cs(i).sample_pk = locs(i);
        cs(i).time_pk = time(locs(i));
        cs(i).time = time(locs(i)-((frame_size/2)-0.5):locs(i)+((frame_size/2)-0.5))';
        cs(i).sample = locs(i)-((frame_size/2)-0.5):locs(i)+((frame_size/2)-0.5);
    end
    cs(i).filename = filename;
    cs(i).noise = signal(.003*192000:round(.013*192000)); % First 3-13 ms of file collected as noise estimate
end

len = length(cs);

fprintf('Number of clicks extracted: %i\n\n',len);

fprintf('------------------------------------------------\nPress the left and right arrow keys to navigate through\nplotted clicks.\n\nTo discard clicks, enter the plot numbers of\nthe undesired signals in the terminal, each followed by\nRETURN. Single quotes are not needed.\n\nPress ESC in the figure when finished.\n\n');

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





