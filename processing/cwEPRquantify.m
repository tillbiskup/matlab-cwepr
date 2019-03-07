function intensity = cwEPRquantify(dataset,varargin)
% CWEPRQUANTIFY calculates area under curve (line) to quantify signal
% intensity of a cw-EPR spectrum
%
% Usage
%   intensity = cwEPRquantify(dataset)
%   intensity = cwEPRquantify(dataset, range)
%
%   dataset   - struct
%               structure containing data and additional fields
%
%   range     - vector 
%               two-element vector with values corresponding to axis
%
%   intensity - scalar
%               intensity of given spectrum/line

% Copyright (c) 2019, Till Biskup
% 2019-03-07

intensity = 0;

if nargin > 1
    range = varargin{2};
else
    range = [];
end

if range && ~length(range) == 2
    warning(['(EE) ' 'Range must be two-element vector']);
    return
end

if range
    range = interp1(...
        dataset.axes.data(1).values,...
        1:length(dataset.axes.data(1).values),range,...
        'nearest');
    intensity = cumtrapz(dataset.data(range(1):range(2)));
else
    intensity = cumtrapz(dataset.data);
end

end