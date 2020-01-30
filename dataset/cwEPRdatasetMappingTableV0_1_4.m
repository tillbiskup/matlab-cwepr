function table = cwEPRdatasetMappingTableV0_1_4
% CWEPRDATASETMAPPINGTABLEV0_1_4 Mapping table for mapping cwEPR info file 
% (v. 0.1.4) contents to dataset. 
%
% Usage
%   table = cwEPRdatasetMappingTableV0_1_4
%
%   table - cell (nx3)
%           1st column: field of info structure returned by
%           cwEPRinfofileLoad
%
%           2nd column: corresponding field in dataset structure as
%           returned by cwEPRdatasetCreate
%
%           3rd column: modifier telling datasetMapInfo how to modify the
%           field from the info file to fit into the dataset
%
%           Currently allowed (case insensitive) modifiers contain:
%           join, joinWithSpace, splitValueUnit, str2double
%
%           See the source code of cwEPRdatasetMapInfo for more info
%
% NOTE FOR TOOLBOX DEVELOPERS:
% Use cwEPRinfofileMappingTableHelper to create the basic structure of the
% cell array "table" and create your own PREFIXdatasetMappingTable function
% as a copy of this function.
%
% SEE ALSO: cwEPRdatasetMapInfo, cwEPRdatasetCreate, cwEPRinfofileLoad,
% cwEPRinfofileMappingTableHelper

% Copyright (c) 2020, Till Biskup
% 2020-01-30

commonTable = commonDatasetMappingTableV0_2_0;
table = [ ...
    commonTable; ...
    cwEPRdatasetMappingTableV0_1_2; ...
    cwEPRdatasetMappingTableV0_1_3 ...
    ];

end