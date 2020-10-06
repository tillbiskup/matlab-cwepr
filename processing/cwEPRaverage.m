function dataset = cwEPRaverage(dataset)
% CWEPRAVERAGE Average 2D dataset over second dimension
%
% Usage
%   dataset = cwEPRaverage(dataset)
%
%   dataset  - struct
%              structure containing data and additional fields
%

% Copyright (c) 2020, Till Biskup
% 2020-10-06

if isvector(dataset.data)
    warning('Dataset seems to be 1D, no averaging performed');
    return
end

dataset.data = mean(dataset.data, 2);
dataset.axes.data(2) = dataset.axes.data(3);
dataset.axes.data(3) = [];
dataset.label = sprintf('%s (averaged)', dataset.label);

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Averaging';
history.purpose = 'Average data from 2D dataset over second dimension';
dataset.history{end+1} = history;

end