function [] = ftp_filelist( struct, buoy, remotepath, localpath, rows, quotes )

% Here is a function to write a filelist file for the ftp retrieval script
%
%
%   INPUTS: struct      - the filtered events structure array
%           buoy        - integer buoy number of the filtered events array
%           remotepath  - a string of the absolute path to the RAID directory of
%                       interest (e.g. '/Volumes/FirstRAID/')
%           localpath   - a string of the absolute path to the directory
%                       you wish to store the collected files in 
%           numrows     - number of rows of filelist to download, default
%           =size(struct,2)
%           quotes      - If a local directory has spaces in the name,
%           include this argument as 'quotes'
%      
%
%   NOTE: Include ending '/' on file paths (as in e.g. above)
%
%   VERSION: v1.0, 03/25/2017, Jack LeBien, LADC-GEMM

if ~exist('rows','var') || isempty(rows)
    rows = size(struct,2);
end
if ~exist('quotes','var')
    quotes='';
elseif ~strcmp(quotes, 'quotes')
    error('Invalid input');
end

fileID = fopen(fullfile('/Users/ownermac/Google Drive/LADC-GEMM Data/','events_filelist.txt'),'w');


path_init = strcat(remotepath,'Buoy0',num2str(buoy),'_DISK');

if isempty(quotes)
    for i = rows

        fprintf(fileID, '%s %s\n', strcat(path_init,...
                                        struct(i).filename(end),'/',...
                                        struct(i).filename), ...
                                        ...
                                        strcat(localpath,struct(i).filename));
    end
else
    for i = rows

        fprintf(fileID, '%s %s\n', strcat(path_init,...
                                        struct(i).filename(end),'/',...
                                        struct(i).filename), ...
                                        ...
                                        strcat('"',localpath,struct(i).filename,'"'));
    end
end

fclose(fileID);
    
    
end
