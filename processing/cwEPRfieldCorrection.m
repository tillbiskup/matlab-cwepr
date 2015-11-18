function dataset = cwEPRfieldCorrection(dataset,deltaB0,varargin)
% CWEPRFIELDCORRECTION Correct field by value obtained from measured field
% standard.
%
% Usage
%   dataset = cwEPRfieldCorrection(dataset,deltaB0)
%
%   dataset  - stucture
%              Dataset complying with specification of toolbox dataset
%              structure
%
%   deltaB0  - scalar
%              Field difference calculated from spectrum of field standard
%              using the appropriate helper function
%
% See also: cwEPR_fieldStandardLiLiF
 
% Copyright (c) 2015, Till Biskup
% 2015-11-18

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addRequired('deltaB0',@(x)isscalar(x));
    p.parse(dataset,deltaB0,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Assume (for the time being) the first axis to be the field axis
dataset.axes.data(1).values = dataset.axes.data(1).values + deltaB0;

% Write history
history = cwEPRhistoryCreate();
history.functionName = mfilename;
history.kind = 'Field correction';
history.parameters = {p.Results.deltaB0};
dataset.history{end+1} = history;

end
