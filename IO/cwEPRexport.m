function cwEPRexport(dataset, filename)
% CWEPREXPORT Export dataset to text
%
% Usage
%   dataset = cwEPRexport(dataset, filename)
%
%   dataset  - struct
%              structure containing data and additional fields
%
%   filename - string
%              name of the file the data should be exported to.
%
% NOTE:
% Currently, only 1D data are supported for export.

% Copyright (c) 2020, Till Biskup
% 2020-02-18

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset', @(x)isstruct(x));
    p.addRequired('filename', @(x)ischar(x));
    p.parse(dataset, filename);
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

if ~is1Ddata(dataset)
    error('Currently, only 1D datasets are supported.');
end

to_export = [ ...
    dataset.axes.data(1).values(:) ...
    dataset.data ...
    ];
commonTextFileWrite(filename, cellstr(num2str(to_export)));

end

function TF = is1Ddata(dataset)

TF = not(all(size(dataset.data) > 1));

end