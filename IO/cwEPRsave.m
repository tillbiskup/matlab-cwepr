function [status,exception] = cwEPRsave(filename,struct)
% CWEPRSAVE Save data from the cwEPR toolbox as ZIP-compressed XML files.
%
%
% Usage
%   cwEPRSave(filename,struct)
%   [status] = commonSave(filename,struct)
%   [status,exception] = commonSave(filename,struct)
%
%   filename   - string
%                name of a valid filename
%
%   data       - struct
%                structure containing data and additional fields
%
%   status     - cell array
%                empty if there are no warnings
%
%   exception  - object
%                empty if there are no exceptions
%
%
% See also COMMONSAVE

% Copyright (c) 2015, Till Biskup, Deborah Meyer
% 2015-11-17

% Assign output
status = cell(0);
exception = []; %#ok<NASGU>

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('filename',@ischar);
    p.addRequired('struct', @isstruct);
    p.parse(filename,struct);
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

[status,exception] = commonSave(filename,struct,...
    'precision','real*8',...
    'extension','.xbz');

end
