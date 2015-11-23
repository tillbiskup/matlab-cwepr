function table = cwEPRmappingTableBrukerSPC()
% CWEPRMAPPINGTABLEBRUKERSPC Mapping table for mapping Bruker SPC format
% (used with EMX/ESP) vendor-specific parameters to cwEPR dataset.
%
% Usage
%   table = cwEPRmappingTableBrukerSPC
%
%   table - cell (nx3)
%           1st column: field of info structure returned by
%           EPRimport in field "vencor.parameters" with option
%           "vendorFields" set to true
%
%           2nd column: corresponding field in dataset structure as
%           returned by cwEPRdatasetCreate
%
%           3rd column: modifier telling commonStructMap how to modify the
%           field from the info file to fit into the dataset
%
%           Currently allowed (case insensitive) modifiers contain:
%           join, joinWithSpace, splitValueUnit, str2double
%
%           Furthermore, you can add arbitrary anonymous functions
%           that start with "@" - and you're entirely responsible
%           for the result... (although there is a try-catch around
%           and catch will make a plain copy of the field).
%
%           See the source code of commonStructMap for more info
%
% NOTE: You can add as many fields as you like in the first two columns, as
% the function "commonStructMap" will check for the existence of the
% respective fields in the corresponding structure.
%
% SEE ALSO: cwEPRimport, commonStructMap

% Copyright (c) 2015, Till Biskup
% 2015-11-23

table = {...
    'JEX','parameters.experiment.type',''; ...
    'JSD','parameters.signalChannel.accumulations',''; ...
    'RMF','parameters.signalChannel.modulation.frequency.value',''; ...
    'RMA','parameters.signalChannel.modulation.amplitude.value',''; ...
    'RRG','parameters.signalChannel.receiverGain',''; ...
    'RCT','parameters.signalChannel.modulation.conversionTime.value',''; ...
    'RTC','parameters.signalChannel.modulation.timeConstant.value',''; ...
    'RPH','parameters.signalChannel.modulation.phase.value',''; ...
    };

end
