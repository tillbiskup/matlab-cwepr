function dataset = cwEPRimport(filename)
% CWEPRIMPRT imports diffrent kind of cw-EPR datas: spc, par, txt, dat files
%
% Loading EPR spectra (*.spc,*.par,*.txt,*.dat Format)
% Usage
%   dataset = cwEPRimport(filename)
%
% filename - string
%            name of a valid filename 
%
% dataset  - struct
%            structure containing data and additional fields
%

% Copyright (c) 2015, Till Biskup, Deborah Meyer, Simona Huwiler 
% 2015-03-11

% Create dataset
dataset = cwEPRdatasetCreate;

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
        warning('Unknown file format. Nothing loaded!')
        return;
    end
end

% Check whether we have loaded something, if not, complain and exit
if ~exist('B0','var')
    warning('File %s not found - nothing loaded',filename)
    return;
end


% Put Spectrum and B0 into dataset
dataset.data = spectrum;
dataset.axes(1).values = B0;

    

% Set other parameters in dataset
dataset.axes(1).measure = 'magnetic field';
dataset.axes(1).unit = 'mT';
if min(size(dataset.data)) >1
    dataset.axes(2).measure = '';
    dataset.axes(2).unit = '';
    dataset.axes(3).measure = 'intensity';
    dataset.axes(3).unit = 'a.u.';
else
    dataset.axes(2).measure = 'intensity';
    dataset.axes(2).unit = 'a.u.';
end

end