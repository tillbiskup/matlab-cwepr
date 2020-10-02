function dataset = cwEPRsubtractBaseline(dataset, varargin)
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
%                  either polynomial or exponential 
%                  Default: polynomial
%
%        degree  - scalar
%                  degree of polynomial or exponential 
%                  Default: 2
%
%        percent - scalar
%                  percentage of the x axis used for fitting
%                  (from both sides)
%                  Default: 10
%                            

% See also: common_fitPolynomial

% Copyright (c) 2015-20, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2020-10-01


kindcell = {'polynomial','exponential'};

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset', @isstruct);
    p.addParameter('kind','polynomial',@(x)any(strcmpi(x,kindcell)));
    p.addParameter('degree',2,@isscalar);
    p.addParameter('percent',10,@isscalar);
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Define Fit Area
%area = common_fitAreaDefine(dataset);
B0=dataset.axes.data(1).values;
areaPart = floor(numel(B0)/10);
areaIndices = [1:areaPart length(B0)-areaPart:length(B0)];
area = zeros(1,length(B0));
area(areaIndices) = 1;
area = logical(area);

if isscalar(dataset.data)
    area = reshape(area,size(dataset.data));
end

% Perform Polynomal fit
if strcmpi(p.Results.kind,'polynomial')
    [coefficients, ~] = common_fitPolynomial(...
        dataset,area,'plot',false,'degrees',[p.Results.degree]);
    coeffvector = cell2mat(coefficients);
    coeffvector = reshape(coeffvector, [], numel(coefficients));
    
    % Create polynomial Baseline
    baseline = common_computeBaseline(...
        dataset,coeffvector,'degree',p.Results.degree);
end

% Subtract Baseline
if isscalar(dataset.data)
    dataset.data = dataset.data - baseline(:);
else
    dataset.data = dataset.data - baseline;
end

% Write Parameters into History
history = cwEPRhistoryCreate;
history.functionname = mfilename();
history.kind = 'BaselineSubtraction';
history.parameters = {...
    p.Results.kind, area, p.Results.degree, coeffvector};

dataset.history{end+1} = history;

end
