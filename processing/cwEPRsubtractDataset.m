function dataset = cwEPRsubtractDataset(dataset,toSubtract)
% CWEPRSUBTRACTDATASET Subtract data of one dataset from other dataset
% without saving the complete subtracted dataset, but just the subtracted
% vector.
%
% Perform interpolation to match data to be subtracted to dataset.
%
% Perform extrapolation where necessary using mean value of data to be
% subtracted as fixed value.
%
% Usage
%   dataset = cwEPRsubtractDataset(dataset,toSubtract)
%
%   dataset    - struct
%                cwEPR dataset
%
%   toSubtract - struct
%                cwEPR dataset

% Copyright (c) 2016, Till Biskup
% 2016-11-17

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.addRequired('tosubtract',@(x)isstruct(x));
    p.parse(dataset,toSubtract);
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Linearly interpolate data to be subtracted on axis of dataset to be
% subtracted from and extrapolate (where necessary) using a fixed value
% derived from the mean of the data to be subtracted
toSubtractVector = interp1(...
    toSubtract.axes.data(1).values,...
    toSubtract.data,...
    dataset.axes.data(1).values,...
    'linear',mean(toSubtract.data));

% Perform subtraction
dataset = cwEPRsubtract(dataset,toSubtractVector);

end

