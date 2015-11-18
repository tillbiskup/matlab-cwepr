function dataset = cwEPRnormaliseScans(dataset,varargin)
% cwEPRnormaliseScans Normalise given dataset for number of scans, aka
% divide by number of scans done.
%
% Usage
%   dataset = cwEPRnormaliseScans(dataset)
%
%   dataset  - stucture
%              Dataset complying with specification of toolbox dataset
%              structure
%
% SEE ALSO: cwEPRnormaliseReceiverGain

% Copyright (c) Till Biskup
% 2015-11-18

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addOptional('accumulations',...
        dataset.parameters.signalChannel.accumulations,@(x)isscalar(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Check whether normalisation has been done already and in case return
if ~isempty(dataset.history) && ...
        any(cellfun(@(x)strcmpi(x.functionName,mfilename),dataset.history))
    disp('(WW) Normalisation for number of scans has been done already. ABORT.');
    return;    
end

dataset.data = dataset.data/p.Results.accumulations;

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Number of scans normalisation';
history.purpose = 'Normalise intensity of signal for number of scans done.';
history.parameters = {p.Results.accumulations};
dataset.history{end+1} = history;

end