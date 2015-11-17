function dataset = cwEPRfrequencyCorrection(dataset,varargin)
% CWEPRFREQUENCYCORRECTION makes frequency correction to a given value or
% to a standardvalue. Since this is a nonlinear operation it interpolates
% the data to give back an equidistant axis.
%
% Usage
%   dataset = cwEPRfrequencyCorrection(dataset)
%   dataset = cwEPRfrequencyCorrection(dataset,newFrequency)
%
%   dataset      - stucture
%                  Dataset complying with specification of toolbox dataset
%                  structure
%
%   newFrequency - scalar
%                  Frequency in GHz to which correction shall take place.
%                  Default: 9.70 GHz
 
% Copyright (c) 2015, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2015-11-17

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@(x)isstruct(x));
parser.addOptional('NewFrequency',9.7,@(x)isscalar(x));
parser.parse(dataset,varargin{:});

% Read out axes in mT
if ~strcmpi(dataset.axes.data(1).unit,'mT') 
  disp('Please provide your axes in mT');
  return
end
mTold = dataset.axes.data(1).values;

% Read out MWfrequency in GHz
if ~strcmpi(dataset.parameters.bridge.MWfrequency.unit,'GHz') 
  disp('Please proviede your microwave frequendy in GHz');
  return
end
% Conversion to Hz
fqold = 10^9 * dataset.parameters.bridge.MWfrequency.value;

% convert to g-values
g = EPRmT2g(mTold,fqold);

% convert back to mT with newFrequency
fqnew = 10^9 * parser.Results.NewFrequency;
mTnewNotEquidistant = EPRg2mT(g, fqnew);

% Do the interpolation thingy
mTnewEquidistant = linspace(mTnewNotEquidistant(1),mTnewNotEquidistant(end),length(mTnewNotEquidistant)); 
for slice = 1:size(dataset.data,1)
    dataset.data(slice,:) = interp1(mTnewNotEquidistant,...
        dataset.data(slice,:),mTnewEquidistant,'linear');
end

% Create and fill History
history = cwEPRhistoryCreate();
history.functionName = mfilename;
history.kind = 'Frequency correction';
history.reversible = false;
history.tplVariables.OldFrequency = dataset.parameters.bridge.MWfrequency.value;
history.tplVariables.NewFrequency = parser.Results.NewFrequency;
history.parameters = {parser.Results.NewFrequency};


% Write back to dataset
dataset.axes.data(1).values = mTnewEquidistant;
dataset.parameters.bridge.MWfrequency.value = parser.Results.NewFrequency;
dataset.history{end+1} = history;

end
