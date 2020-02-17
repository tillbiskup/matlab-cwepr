function dataset = cwEPRalgebra(dataset,varargin)
% cwEPRalgebra Perform simple algebraic operations on a dataset.
%
% Usage
%   dataset = cwEPRalgebra(dataset, 'kind', value)
%
%   dataset  - stucture
%              Dataset complying with specification of toolbox dataset
%              structure
%
%   kind    - string
%             one of 'plus', 'minus', 'multiply', 'divide'
%             Alternatively, the corresponding symbols may be used:
%             '+', '-', '*', '/'

% Copyright (c) 2020, Till Biskup
% 2020-02-17

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addRequired('kind',@(x)ischar(x));
    p.addRequired('value',@(x)isscalar(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

switch p.Results.kind
    case {'plus', '+'}
        dataset.data = dataset.data + p.Results.value;
    case {'minus', '-'}
        dataset.data = dataset.data - p.Results.value;
    case {'multiply', '*'}
        dataset.data = dataset.data .* p.Results.value;
    case {'divide', '/'}
        dataset.data = dataset.data ./ p.Results.value;
    otherwise
        error('Unknown operation "%s"', p.Results.kind);
end

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Algebra';
history.purpose = 'Linear algebraic operation.';
history.parameters = {p.Results.kind, p.Results.value};
dataset.history{end+1} = history;

end