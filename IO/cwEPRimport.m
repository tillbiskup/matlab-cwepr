function dataset = cwEPRimport(filename,varargin)
% CWEPRIMPRT imports diffrent kind of cw-EPR datas: spc, par, txt, dat files
%
% Loading EPR spectra (*.spc,*.par,*.txt,*.dat Format)
% Usage
%   dataset = cwEPRimport(filename)
%   dataset = cwEPRimport(filename,<param>,<value>)
%
%   filename - string
%              name of a valid filename 
%
%   dataset  - struct
%              structure containing data and additional fields
%
% Optional parameters
%
%   loadInfo - boolean
%              Try to load (and map) accompanying info file
%              Default: true
%
%   RCnorm   - boolean
%              Normalise for receiver gain (RC), aka divide intensities of
%              spectrum by RC value.
%              Default: true
%
%   SCnorm   - boolean
%              Normalise for number of scans, aka divide by this number
%              Default: true
%
% SEE ALSO: EPRimport

% Copyright (c) 2015, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2015-11-17

% Create dataset
dataset = cwEPRdatasetCreate;

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('filename', @(x)ischar(x));
    p.addParamValue('loadInfo',true,@islogical);
    p.addParamValue('RCnorm',true,@islogical);
    p.addParamValue('SCnorm',true,@islogical);
    p.parse(filename,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Remove extension from filename if any
[path,name,~] = fileparts(filename);
filename = fullfile(path,name);

try
    % Loading EPR spectra (*.par, *.spc, Bruker EMX format)
    % command: EPRimport from EPR toolbox
    EPRdataset = EPRimport(filename,'RCnorm',p.Results.RCnorm);
catch
    warning('Unknown file format. Nothing loaded!');
    return;
end

% Put cwEPRdataset into EPRdatset
dataset = commonStructCopy(dataset,EPRdataset);

% Check for info file
if p.Results.loadInfo
    infoFileName = fullfile(path,[name '.info']);
    if exist(infoFileName,'file')
        [info,infoVersion] = cwEPRinfofileLoad(infoFileName);
        dataset = cwEPRdatasetMapInfo(dataset,info,infoVersion);
    else
        warning('Info file %s not found - not mapped',infoFileName);
    end 
end



end