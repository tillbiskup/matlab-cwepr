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
% NOTE: To map vendor-specific parameters, there exists an automatic
% mechanism: Place a file named "cwEPRmappingTable<format>" in the
% "private" directory of the directory this function is residing in, where
% "<format>" is the string returned by EPRimport in the field
% "vendor.fileFormat" with the option "vendorFields" set to true. The
% format of this mappingTable is identical to those for the info files.
%
% The parameters contained in the vendor.parameters structure will
% overwrite those read from the infofile. The reasoning behind is that it
% is more plausible that a user forgot to change a parameter in the info
% file rather than the vendor parameter file contains wrong values.
%
% SEE ALSO: EPRimport

% Copyright (c) 2015, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2015-11-23

% Create dataset
dataset = cwEPRdatasetCreate;

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('filename', @(x)ischar(x));
    p.addParameter('loadInfo',true,@islogical);
    p.addParameter('RGnorm',true,@islogical);
    p.addParameter('SCnorm',true,@islogical);
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
    EPRdataset = EPRimport(filename,'vendorFields',true);
catch %#ok<CTCH>
    warning('Unknown file format. Nothing loaded!'); %#ok<*WNTAG>
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

% Map vendor parameters to dataset structure, thus overwriting info file
% values, if they were loaded.
mappingTableName = ['cwEPRmappingTable' dataset.vendor.fileFormat];
if exist(mappingTableName,'file')
    mappingFun = str2func(mappingTableName);
    mapping = mappingFun();
    dataset = commonStructMap(dataset,dataset.vendor.parameters,mapping);
end

% Remove vendor fields
dataset = rmfield(dataset,'vendor');

% Perform receiver gain normalisation
if p.Results.RGnorm && ~isnan(dataset.parameters.signalChannel.receiverGain)
    dataset = cwEPRnormaliseReceiverGain(dataset);
end

% Perform normalisation for number of scans
if p.Results.SCnorm
    dataset = cwEPRnormaliseScans(dataset);
end

end
