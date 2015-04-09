function dataset = cwEPRdatasetMapInfo(dataset,info,format)
% CWEPRDATASETMAPINFO Puts information in info into dataset
%
% Usage
%   dataset = cwEPRdatasetMapInfo(dataset,info)
%
%   dataset - stucture
%             Dataset complying with specification of toolbox dataset
%             structure
%
%   info    - struct
%             Info structure as returned by cwEPRinfofileLoad
%
%   format  - struct
%             Format of the info file as returned by cwEPRinfofileLoad
%
% SEE ALSO: cwEPRdatasetCreate, cwEPRinfofileLoad, commonDatasetCreate,
% commonInfofileLoad 

% Copyright (c) 2015, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2015-04-09

dataset = commonDatasetMapInfo(dataset,info,format);

end
