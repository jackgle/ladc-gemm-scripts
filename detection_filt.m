function [ events_flt ] = detection_filt( struct, type_codes, nclick_thresh )

% Here is a simple function to return a filtered structure array from the
% detection results ('events')
%
%   INPUTS: struct          - detection results ('events') structure array
%           
%           bands           - an array of integers in the range 1-7 representing
%                             which band combinations you wish to keep in the filtering process
%
%           nclick_thresh   - an integer value of the minimum number of
%                             clicks detected for an event to be of interest. Elements of the structure
%                             array with 'numclicks' < nclick_thresh will be omitted.
%
%
%   OUTPUT: events_flt      - a structure array containing only elements from
%   the original array with desired values
%
%   BANDS INFO: 
%
%       band 1 (low) = 3-20 kHz
%       band 2 (medium) = 25-55 kHz
%       band 3 (high) = 60-90 kHz
%
%       Type codes (low, medium, and high bands):
%       1 = L
%       2 = M
%       3 = L M
%       4 = H
%       5 = H L
%       6 = H M
%       7 = H M L 
%
%   EXAMPLE: 
%
%       If we are interested in beaked whales, we may choose the type codes
%       containing the medium band: 2,3,6,7.
%
%       Say we want to filter an 'events' array to look for elements
%       containing type codes [2,3,6,7] and at least 10 clicks detected:
%
%           events_flt = detection_filt(events, [2,3,6,7], 10);
%
%   VERSION: v1.0, 03/25/2017, Jack LeBien, LADC-GEMM
%          

m = arrayfun(@(x)find(x.type==type_codes & x.numclicks >= nclick_thresh), struct, 'uniformoutput', false);
ix = cellfun(@isempty,m);
events_flt = struct(~ix);

end

