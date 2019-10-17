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
 
% Copyright (c) 2015-, Till Biskup
% Copyright (c) 2015, Deborah Meyer
% 2019-10-17

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addOptional('newFrequency',9.7,@(x)isscalar(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Read out axes in mT
if ~strcmpi(dataset.axes.data(1).unit,'mT') 
  disp('Please provide your axes in mT');
  return
end
mTold = dataset.axes.data(1).values;

% Read out MWfrequency in GHz
if ~strcmpi(dataset.parameters.bridge.MWfrequency.unit,'GHz') 
  disp('Please provide your microwave frequency in GHz');
  return
end
% Conversion to Hz
fqold = 10^9 * dataset.parameters.bridge.MWfrequency.value;

% convert to g-values
g = EPRmT2g(mTold,fqold);

% convert back to mT with newFrequency
fqnew = 10^9 * p.Results.newFrequency;
mTnewNotEquidistant = EPRg2mT(g, fqnew);

% Do the interpolation thingy
mTnewEquidistant = linspace(mTnewNotEquidistant(1),...
    mTnewNotEquidistant(end),length(mTnewNotEquidistant)); 
for slice = 1:size(dataset.data,2)
    dataset.data(:,slice) = interp1(mTnewNotEquidistant,...
        dataset.data(:,slice),mTnewEquidistant,'linear');
end

% Create and fill History
history = cwEPRhistoryCreate();
history.kind = 'Frequency correction';
history.purpose = 'Correct dataset to given MW frequency';
history.reversible = false;
history.tplVariables.oldFrequency = ...
    dataset.parameters.bridge.MWfrequency.value;
history.tplVariables.newFrequency = p.Results.newFrequency;
history.parameters = {p.Results.newFrequency};


% Write back to dataset
dataset.axes.data(1).values = mTnewEquidistant;
dataset.parameters.bridge.MWfrequency.value = p.Results.newFrequency;
dataset.history{end+1} = history;

end
