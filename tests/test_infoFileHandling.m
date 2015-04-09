function messages = test_infoFileHandling
% TEST_INFOFILEHANDLING Test routines involved in reading and mapping info
% file to dataset
%
% Usage:
%   test_infoFileHandling();

% Copyright 2015, Till Biskup
% Copyright 2015, Deborah Meyer
% 2015-04-09

% Test results
status = [];
messages = cell(0);

% Create dataset and load info file
dataset = cwEPRdatasetCreate();
[info,format] = cwEPRinfofileLoad('cwepr-v0_1_2.info');

% Perform test: Mapping of info file to dataset
[status(end+1),messages{end+1}] = commonTest(...
    'dataset = cwEPRdatasetMapInfo(dataset,info,format);');


commonTestStatistics(status,messages);

end