function dataset = cwEPRsubstractBaseline(dataset, varargin)
% CWEPRSUBSTRACTBASELINE substract for the moment a polynomial baseline 
% from a cw-EPR spectrum and writes history
%
% Usage
%   dataset = cwEPRsubstractBaseline(dataset)
%   dataset = cwEPRsubstractBaseline(dataset,<parameters>)
%
%   dataset  - struct
%              structure containing data and additional fields
%
%
%  parameters    - key-value pairs (OPTIONAL)
%
%  Optional parameters may include:
%
%        kind    - string
%                  Kind of Baseline                               
%                  eather polynomial or exponential 
%                  Default: polynomial
%
%        degree  - scalar
%                  degree of polynomial or exponential 
%                  Default: 2
%                            

% See also: common_fitPolynomial

% Copyright (c) 2015, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2015-11-04


kindcell = {'polynomial','exponential'};

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset', @isstruct);
    p.addParamValue('kind','polynomial',@(x)any(strcmpi(x,kindcell)));
    p.addParamValue('degree',2,@isscalar);
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end



% Define Fit Area
area = common_fitAreaDefine(dataset);

% Perform Polynomal fit
if strcmpi(p.Results.kind,'polynomial')
    [coefficients, resSumOfSquares] = ...
        common_fitPolynomial(dataset,area,'plot',false,'degrees',[p.Results.degree]);
    
    coeffvector = cell2mat(coefficients);
    
    % Create polynomial Baseline
    baseline = common_computeBaseline(dataset,coeffvector,'degree',p.Results.degree);
    
end
 
% Subtract Baseline
dataset.data = dataset.data - baseline;

% Write Parameters into History
history = cwEPRhistoryCreate;
history.functionname = mfilename();
history.kind = 'BaselineSubstraction';
history.parameters = {p.Results.kind, area, p.Results.degree, coeffvector};

% Calculate some things
% for index = 1:length(dataset.axes(1).values);
%     if area(index) == 1
%         Einser(index) = index;
%     else
%         Nuller(index) = index;
%     end
% end

% Write Report stuff
history.tplVariables.Kind = p.Results.kind;
history.tplVariables.Degree = p.Results.degree;
history.tplVariables.Coefficients = coeffvector;
history.tplVariables.resSumOfSquares = resSumOfSquares;
%history.tplVariables.areaIndex = areaindex;
%history.tplVariables.areaField = areaField;

dataset.history{end+1} = history;

end