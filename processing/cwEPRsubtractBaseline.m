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

% See also: common_fitPolynomial

% Copyright (c) 2015-16, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2016-11-17


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
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end



% Define Fit Area
%area = common_fitAreaDefine(dataset);
B0=dataset.axes.data(1).values;
areaIndices = [1:400 length(B0)-400:length(B0)];
area = zeros(1,length(B0));
area(areaIndices) = 1;
area = logical(area);

area = reshape(area,size(dataset.data));

% Perform Polynomal fit
if strcmpi(p.Results.kind,'polynomial')
    [coefficients, resSumOfSquares] = ...
        common_fitPolynomial(dataset,area,'plot',false,'degrees',[p.Results.degree]);
    coeffvector = cell2mat(coefficients);
    
    % Create polynomial Baseline
    baseline = common_computeBaseline(dataset,coeffvector,'degree',p.Results.degree);
end
 
% Subtract Baseline
dataset.data = dataset.data - baseline(:);

% Write Parameters into History
history = cwEPRhistoryCreate;
history.functionname = mfilename();
history.kind = 'BaselineSubstraction';
history.parameters = {p.Results.kind, area, p.Results.degree, coeffvector};


areIndexnum = [];
j=1;
% 
for k=1:length(area)
 areaIndex(k) =area(k);
if k>1&&areaIndex(k-1) ~= areaIndex(k)
    areIndexnum(j)  = k;
    j=j+1;
end

 %0 areaField = 
end

%das= areIndexnum
% Write Report stuff
history.tplVariables.Kind = p.Results.kind;
history.tplVariables.Degree = p.Results.degree;
history.tplVariables.Coefficients = coeffvector;
history.tplVariables.resSumOfSquares = resSumOfSquares;
%history.tplVariables.areaIndex = areaIndex;
%history.tplVariables.areaField = areaField;

dataset.history{end+1} = history;

end
