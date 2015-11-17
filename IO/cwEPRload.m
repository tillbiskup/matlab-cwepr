function [dataset,warning] = cwEPRload(filename)
% CWEPRLOAD Read ZIP-compressed XML file and data (if available).
%
% Usage:
%   [dataset,warning] = cwEPRLoad(filename)
%   [dataset,warning] = cwEPRLoad(filename,<parameters>)
%
%   filename   - string
%                name of the ZIP archive containing the XML (and data)
%                file(s)
%
%   dataset    - struct
%                content of the XML file
%                data.data holds the data read from the ZIP archive
%
%   warning    - cell array
%                Contains warnings if there are any, otherwise empty
%
% SEE ALSO cwEPRSave

% Copyright (c) 2015, Till Biskup
% 2015-11-17

% Assign default output
dataset = logical(false);
warning = cell(0);

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('filename', @(x)ischar(x) || iscell(x));
    p.parse(filename);
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

[dataset,warning] = commonLoad(filename,...
    'precision','real*8',...
    'extension','.xbz');
end