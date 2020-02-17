function dataset = cwEPRproject(dataset,varargin)
% cwEPRproject Project 2D data in one dimension.
%
% Useful/necessary for datasets recorded on Bruker machines where every
% scan is recorded as trace in a 2D dataset ("Field Delay" experiment).
%
% The data are divided afterwards by the number of "traces" to normalise.
%
% Usage
%   dataset = cwEPRproject(dataset)
%   dataset = cwEPRproject(dataset, 'axis', 1)
%
%   dataset  - stucture
%              Dataset complying with specification of toolbox dataset
%              structure
%
% Optional parameters
%
%   axis    - integer
%             Number of the axis to average over
%             Default: 2 (aka: y axis)

% Copyright (c) 2020, Till Biskup
% 2020-02-17

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addOptional('axis',2,@(x)isscalar(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

number_of_traces = size(dataset.data, p.Results.axis);
dataset.data = sum(dataset.data, p.Results.axis) / number_of_traces;

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Projection';
history.purpose = 'Summation of multidimensional data along one axis.';
history.parameters = {p.Results.axis};
dataset.history{end+1} = history;

end