function dataset = cwEPRdatasetMapInfo(dataset,info)
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
%             Info structure as returned by commonInfofileLoad
%
% SEE ALSO: cwEPRdatasetCreate, cwEPRinfofileLoad, commonDatasetCreate,
% commonInfofileLoad 

% Copyright (c) 2015, Till Biskup
% 2015-03-06

dataset = commonDatasetMapInfo(dataset,info);

end
