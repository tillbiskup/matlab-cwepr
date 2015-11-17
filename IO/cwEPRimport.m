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
    % command: eprload
    % For help, type "doc eprload" on the Matlab command line
    [B0,spectrum] = eprload(filename);
    % NOTE: "axes" might be a cell array, if we have more than one
    %       dimension (e.g., power sweep)
    if iscell(B0)
        B0 = B0{1};
    end
    % Convert G => mT
    B0 = B0/10;
catch %#ok<CTCH>
    try
        extensions = {'.txt','.dat'};
        for extension = 1:length(extensions)
            fullfilename = [filename extensions{extension}];
            if exist(fullfilename,'file')
                data = load(fullfilename);
                B0 = data(:,1)';
                spectrum = data(:,2);
                break;
            end
        end
    catch
        warning('Unknown file format. Nothing loaded!');
        return;
    end
end

% Check whether we have loaded something, if not, complain and exit
if ~exist('B0','var')
    warning('File %s not found - nothing loaded',filename);
    return;
end

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

% Put Spectrum and B0 into dataset and into origdata
dataset.data = spectrum';
dataset.origdata = dataset.data;
dataset.axes.data(1).values = B0;

    

% Set other parameters in dataset
dataset.axes.data(1).measure = 'magnetic field';
dataset.axes.data(1).unit = 'mT';
if min(size(dataset.data)) >1
    dataset.axes.data(2).measure = '';
    dataset.axes.data(2).unit = '';
    dataset.axes.data(3).measure = 'intensity';
    dataset.axes.data(3).unit = 'a.u.';
else
    dataset.axes.data(2).measure = 'intensity';
    dataset.axes.data(2).unit = 'a.u.';
end

end