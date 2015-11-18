function dataset = cwEPRnormaliseReceiverGain(dataset,varargin)
% CWEPRNORMALISERECEIVERGAIN Normalise given dataset for receiver gain
% settings, aka divide by receiver gain used during recording.
%
% Usage
%   dataset = cwEPRnormaliseReceiverGain(dataset)
%
%   dataset  - stucture
%              Dataset complying with specification of toolbox dataset
%              structure
%
% SEE ALSO: cwEPRnormaliseScans

% Copyright (c) Till Biskup
% 2015-11-18

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addOptional('receiverGain',...
        dataset.parameters.signalChannel.receiverGain,@(x)isscalar(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Check whether normalisation has been done already and in case return
if ~isempty(dataset.history) && ...
        any(cellfun(@(x)strcmpi(x.functionName,mfilename),dataset.history))
    disp('(WW) Receiver gain normalisation has been done already. ABORT.')
    return;    
end

dataset.data = dataset.data/p.Results.receiverGain;

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Receiver gain normalisation';
history.purpose = 'Normalise intensity of signal for receiver gain.';
history.parameters = {p.Results.receiverGain};
dataset.history{end+1} = history;

end