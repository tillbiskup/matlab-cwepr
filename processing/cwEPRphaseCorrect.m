function [dataset, phi] = cwEPRphaseCorrect(dataset,varargin)
% CWEPRPHASECORRECT applies automatic phase correction to a cw-EPR spectrum 
% and writes history
%
% Usage
%   dataset = cwEPRphaseCorrect(dataset)
%   [dataset, phi] = cwEPRphaseCorrect(dataset)
%   dataset = cwEPRphaseCorrect(dataset, range)
%
%   dataset - struct
%             structure containing data and additional fields
%
%   phi     - scalar
%             phase angle resulting from automatic phase correction
%

% Copyright (c) 2019, Till Biskup
% 2019-03-07

if nargin > 1
    range = varargin{2};
else
    range = [];
end

if range 
    if ~(length(range) == 2)
        warning(['(EE) ' 'Range must be two-element vector']);
        return
    end
end

if range
    range = interp1(...
            dataset.axes.data(1).values,...
            1:length(dataset.axes.data(1).values),range,...
            'nearest');
    [data, phi] = APC(dataset.data(range(1):range(2)));
    dataset.data(range(1):range(2)) = data;
else
    [dataset.data, phi] = APC(dataset.data);
end

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Phase Correction';
history.purpose = 'Automatically correct the phase of a cw-EPR spectrum';
history.parameters = {phi};
dataset.history{end+1} = history;

end