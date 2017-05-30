function varargout=readEARS(filename,startRecord,duration_sec)
% - Reads EARS binary files into MATLAB variables and/or .dat files
% - Original file viewEARSfile by Chris Tiemann 
% - Modified by Dr. J Ioup and Kirk Bienvenu and Kendal Leftwich 2016
% - Stripped by Jack LeBien 2017

if nargin==0
    [filename, pathname]=uigetfile('*.*','Select EARS file');
    filename=[pathname filename];
end
if nargin<2,startRecord=1;end
if nargin<3,duration_sec=[];end


%Data constants
datareclen = 250; %Length of data record in samples NOT including 12 byte header
reclen = 512;     %Length of record in bytes INCLUDING 12 byte header
nrecblk = 16384;  %Number of records per file
Fs = 192000;      %sampling frequency (Hz)
nbit = 16;        %Bit resolution of A/D
vfs = 4.;	      %Full-scale voltage range of A/D 
adc = 2^nbit / vfs; 

%Noise filter parameters
attenSB = 20;                   % stopband attenuation
fcuts = [3000 3500];            % band edge frequencies, Hz, ascending
mags = [0 1];                   % amplitude at band edges
devs = [0.01 10^(-attenSB/20)]; % max deviation or ripple (linear)


%Open EARS data file
fprintf('Loading %s \n',filename)
fid0 = fopen(filename, 'r', 'b');
if fid0==-1
    disp('Bad file ID; check filename exists')
    return
end    

%Optionally skip over initial records
fseek(fid0,reclen*(startRecord-1),0);		 

%Read timestamp header of starting record  
header=fread(fid0,12,'uchar');
fseek(fid0,-12,0);
[~, yeardayvector]=EARStimeheader_to_datenumber(header);
%5timeStamp=[num2str(yeardayvector(2)) ':' num2str(yeardayvector(3)) ':' num2str(yeardayvector(4))];

%Initialize signal vector
if isempty(duration_sec)
    %If undefined, read from start record to end of file
    numsamplestoread=datareclen*(nrecblk-startRecord+1);
else
    %Check that samples to read will not exceed end of file
    numsamplestoread=duration_sec*Fs;
    if (startRecord-1)*datareclen+numsamplestoread > nrecblk*datareclen
        numsamplestoread=nrecblk*datareclen - (startRecord-1)*datareclen;
    end
end    
signal=zeros(numsamplestoread,1);

%Read data samples, skipping headers at start of each block
countsum=0;
numblockstoread=floor(numsamplestoread/datareclen);
for j = 1:numblockstoread
    fseek(fid0,12,0); %skip over header
    if feof(fid0)
        %disp(['Reached end of file after reading ' num2str(countsum) ' samples.'])
        break
    end    
    [signal((j-1)*datareclen+1:j*datareclen,1),counttemp]=fread(fid0,datareclen,'int16');
    countsum=countsum+counttemp;
end
%If need to read a partial last block
if countsum<numsamplestoread && ~feof(fid0)
    fseek(fid0,12,0); %skip over header
    signal(j*datareclen+1:j*datareclen+(numsamplestoread-countsum))=...
        fread(fid0,numsamplestoread-countsum,'int16');
    %disp(['Samples read: ' num2str(length(signal))])
end
%disp(['Samples in signal excerpt: ' num2str(length(signal))])

fclose(fid0);
signal = signal./adc;

%disp('Applying noise filter:')
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,Fs);
h = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
%fprintf('%d dB attenuation in 0-3 kHz with filter length %d\n',attenSB,n)
signal=filter(h,1,signal);

signalsize=size(signal);
deltat=1/Fs;
time=(yeardayvector(4):deltat:deltat*(signalsize-1)+yeardayvector(4)).';
%timesize=size(time);
varargout={};
if nargout==1
  varargout={signal};
elseif nargout==2
  varargout={time,signal};
end

%   write out signal for later processing - JWI addition
%fileout=[filename(end-11:end),'.dat']
%fid=fopen(fileout,'w');
%fprintf(fid,'%g %g \n',[time,signal]');
%fprintf(fid,'%g \n',signal);
%fclose(fid);

function [datenumber, yeardayvector]=EARStimeheader_to_datenumber(header)
%This function will convert a 12 byte EARS timestamp header
%(appears before every 250 samples in EARS data)
%into a Matlab date number.  It will also return a vector with
%with EARS yearday of format: [yearday hour min sec]
%Note that NO clock drift corrections are applied here;
%this is the nominal timestamp as known by the instrument.


%Decode timestamp
dum = bitshift(header(7),-4);
dum = bitshift(dum,4);         % get rid of low bits of byte 7  
dum=bitcmp(dum,'uint8');       % take complement
a = bitand(dum,header(7));    

timecode = header(12) + header(11)*2^8 + header(10)*2^16 + header(9)*2^24 + header(8)*2^32 + a*2^40;

%rawtimecode=timecode;           % this is the RAW BINARY timestamp value
timecode = timecode / 32000.;	%convert from 32kHz clock to ABSOLUTE seconds

%Decode day for year determination
timecode = timecode / (60*60*24);	%variable "timecode" is now in ABSOLUTE days
jday0 = fix(timecode);

%variable "jday0" is number of days from 0000Z Jan 1 2000
%convert jday0 to Year and Julian day (variables "jyear" and "jday")
%Note that correction for day of year starting at 1 instead of 0 will
%occur later.
jyear = fix(jday0/365);   %number of years since 1 Jan 2000
dumyear = jyear + 2;
datyear = mod(dumyear,4); %flag: 0 for data year = leap year
leap = fix(dumyear/4);    %number of leap years (counting data year)

%data year is a leap year: do not count as a leap year past
if  datyear == 0
 leap = leap - 1;
end

dum=rem(jday0,365);	%maximum Julian day of data year

%Calculate actual year and Julian day
if leap < dum
  jyear = 2000 + jyear;
  jday = dum - leap;
else %Account for Julian day near beginning of data year if necessary
  jyear = 2000 + jyear -1;
  if (datyear + 1) == 1 %year before data year is leap year
     jday = dum - leap + 366;
  else
     jday = dum - leap + 365;
  end
end


timecode = (timecode - jday0)*24;      %timecode is now in hours OF THE DAY
timecode = (jday *24 + timecode)*3600; %convert to seconds OF THE YEAR
  
%To apply clock drift corrections, need to have values for: 
% toffset (should be in sec at this point) 
% synctime (in sec since epoch) 
% tottime in sec
%SKIPPING TIME CORRECTION UNTIL ADJUSTMENTS ARE KNOWN  
%if 0  5
%  sensorStr = filename(end-2:end-1);         %which sensor (string, 'n1', 's3', etc)
%  sensorNum = find(strcmp(sensorStr,names)); %which sensor (integer in [1-6])
%  correction = toffsets(sensorNum)*(timecode-synctimes(sensorNum))/tottimes(sensorNum);
%  timecode = timecode - correction; %do adjustment
%end

%Decode day
timecode = timecode / (60*60*24); %variable "timecode" is now in days OF THE YEAR
jday = fix(timecode);

%Decode hours
timecode = (timecode - jday)*24;  %now in hours OF THE DAY
jhour = fix(timecode);

%Decode minutes
timecode = (timecode - jhour)*60; %now in minutes OF THE HOUR
jmin = fix(timecode);

%Decode seconds
jsec = (timecode - jmin)*60;      %now in seconds OF THE HOUR

%Make initial jday == 1 NOT == 0 !!!
jday = jday +1;

%Prepare output vector with yearday matching EARS file naming convention
yeardayvector=[jday jhour jmin jsec];

%Convert yearday into Gregorian calendar date string
%Note that in this function Julian day numbering starts at 0
%so need to subtract 1 day. Hours will be zero since not passing
%fractional day to function.
[gtime]=num2date(jday-1,jyear);
datevector=datevec(gtime);
%Replace zeros with real hour/min/sec
datevector(4:6)=[jhour jmin jsec];
%Make Matlab format date number
datenumber=datenum(datevector);
