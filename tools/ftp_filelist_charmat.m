function [] = ftp_filelist( charmat, remotepath, localpath, quotes )

% Here is a function to write a filelist file for the ftp retrieval script
%
%
%      
%
%   NOTE: Include ending '/' on file paths (as in e.g. above)
%
%   VERSION: v1.0, 03/25/2017, Jack LeBien, LADC-GEMM

if ~exist('quotes','var')
    quotes='';
elseif ~strcmp(quotes, 'quotes')
    error('Invalid input');
end

fileID = fopen(fullfile('/Users/ownermac/Google Drive/LADC-GEMM Data/','events_filelist.txt'),'w');


if isempty(quotes)
    for i = 1:size(charmat,1)
        
        path_init = strcat(remotepath,'Buoy0',charmat(i,end-1),'_DISK');
        fprintf(fileID, '%s %s\n', strcat(path_init,...
                                        charmat(i,end),'/',...
                                        charmat(i,:)), ...
                                        ...
                                        strcat(localpath,charmat(i,:)));
    end
else
    for i = 1:size(charmat,1)

        path_init = strcat(remotepath,'Buoy0',charmat(i,end-1),'_DISK');
        fprintf(fileID, '%s %s\n', strcat(path_init,...
                                        charmat(i,end),'/',...
                                        charmat(i,:)), ...
                                        ...
                                        strcat('"',localpath,charmat(i,:),'"'));
    end
end

fclose(fileID);
    
    
end
