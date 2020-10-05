function dataset = cwEPRextractSlice(dataset, slice)
% CWEPREXTRACTSLICE extracts a slice from a 2D dataset
%
% The value and unit of the slice are added in brackets to the label of the
% dataset, thus being automatically displayed in the title and legend,
% respectively if using commonPlot and commonPlotMultiple.
%
% Usage
%   dataset = cwEPRintregrate(dataset, slice)
%
%   dataset  - struct
%              structure containing data and additional fields
%
%   slice    - scalar
%              index of the slice to be extracted

% Copyright (c) 2020, Till Biskup
% 2020-10-05

if isvector(dataset.data)
    warning('Dataset seems to be 1D, no slice extracted');
    return
end

dataset.data = dataset.data(:, slice);
slice_info.value = dataset.axes.data(2).values(slice);
slice_info.unit = dataset.axes.data(2).unit;
dataset.axes.data(2) = dataset.axes.data(3);
dataset.axes.data(3) = [];
dataset.label = sprintf('%s (%i %s)', ...
    dataset.label, slice_info.value, slice_info.unit);

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Slice extraction';
history.purpose = 'Extract slice from 2D dataset';
dataset.history{end+1} = history;

end