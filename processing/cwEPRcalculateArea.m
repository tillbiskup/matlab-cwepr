function area = cwEPRcalculateArea(dataset)
% CWEPRCALCULATEAREA calculates area under a given curve
%
% Usage
%   dataset = cwEPRintregrate(dataset)
%
%   dataset - struct
%             structure containing data and additional fields
%
%   area    - scalar/vector
%             area under the curve(s)
%
%             For 2D datasets, summing is performed along the first
%             dimension
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

area = sum(dataset.data, 1);

end