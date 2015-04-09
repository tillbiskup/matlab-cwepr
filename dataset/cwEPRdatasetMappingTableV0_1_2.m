function table = cwEPRdatasetMappingTableV0_1_2
% CWEPRDATASETMAPPINGTABLEV0_1_2 Mapping table for mapping cwEPR info file 
% (v. 0.1.2) contents to dataset. 
%
% Usage
%   table = cwEPRdatasetMappingTableV0_1_2
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

% Copyright (c) 2014-15, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2015-04-09

EPRTable = EPRdatasetMappingTableV0_1_0;

table = {...
    'experiment.type','parameters.experiment.type',''; ...
    'experiment.variableParameter','parameters.experiment.variableParameter',''; ...
    'experiment.increment','parameters.experiment.increment','splitValueUnit'; ...
    'signalChannel.model','parameters.signalChannel.model',''; ...
    'signalChannel.modulationAmplifier','parameters.signalChannel.modulation.amplifier',''; ...
    'signalChannel.accumulations','parameters.signalChannel.accumulations','str2double'; ...
    'signalChannel.modulationFrequency','parameters.signalChannel.modulation.frequency','splitValueUnit'; ...
    'signalChannel.modulationAmplitude','parameters.signalChannel.modulation.amplitude','splitValueUnit'; ...
    'signalChannel.receiverGain','parameters.signalChannel.receiverGain','str2double'; ...
    'signalChannel.conversionTime','parameters.signalChannel.modulation.conversionTime','splitValueUnit'; ...
    'signalChannel.timeConstant','parameters.signalChannel.modulation.timeConstant','splitValueUnit'; ...
    'signalChannel.phase','parameters.signalChannel.modulation.phase','splitValueUnit'; ...
    'background.filename','parameters.background.filename',''; ...
    'background.type','parameters.background.type',''; ...
    };

% Join mapping tables from common and cwEPR datasets
table = [EPRTable; table];

end