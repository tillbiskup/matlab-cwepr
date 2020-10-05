function return_value = cwEPRcalculateArea(dataset)
% CWEPRCALCULATEAREA calculates area under a given curve
%
% Usage
%   dataset = cwEPRintregrate(dataset)
%   new_dataset = cwEPRintregrate(dataset)
%
%   dataset  - struct
%              structure containing data and additional fields
%
%   area     - scalar/vector
%              area under the curve(s)
%
%              For 2D datasets, summing is performed along the first
%              dimension
%
%   dataset2 - struct
%              structure containing data and additional fields
%
%              Returned in case of 2D datasets, with axes adjusted
%              accordingly.
%
% WARNING: For reasonably correct results regarding cwEPR spectra, those
% spectra should be baseline-corrected, afterwards integrated, again
% baseline-corrected, and only then the area calculated.
%
% A proper sequence may look as follows:
%
%   dataset = cwEPRimport('<filename>');
%   dataset = cwEPRsubtractBaseline(dataset, 'degree', 0);
%   dataset = cwEPRintegrate(dataset);
%   dataset = cwEPRsubtractBaseline(dataset, 'degree', 1);
%   area = cwEPRcalculateArea(dataset)

% Copyright (c) 2020, Till Biskup
% 2020-10-05

if isvector(dataset.data)
    return_value = sum(dataset.data);
else
    return_value = dataset;
    return_value.data = sum(return_value.data, 1);
    return_value.axes.data(1) = return_value.axes.data(2);
    return_value.axes.data(2) = return_value.axes.data(3);
    return_value.axes.data(2).measure = 'integrated intensity';
    return_value.axes.data(3) = [];
    
    % Write history
    history = cwEPRhistoryCreate();
    history.kind = 'Area calculation';
    history.purpose = 'Calculate area below curve';
    return_value.history{end+1} = history;
end

end