function dataset = cwEPRintregrate(dataset)
% CWEPRINTEGRATE integrates a cw-EPR spectrum and writes history
%
% Usage
%   dataset = cwEPRintregrate(dataset)
%
%   dataset - struct
%             structure containing data and additional fields
%

% Copyright (c) 2019, Till Biskup
% 2019-03-07

dataset.data = cumtrapz(dataset.data);

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Integration';
history.purpose = 'Integrate spectrum';
dataset.history{end+1} = history;

end