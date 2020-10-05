function dataset = cwEPRintegrate(dataset)
% CWEPRINTEGRATE integrates a cw-EPR spectrum and writes history
%
% Usage
%   dataset = cwEPRintregrate(dataset)
%
%   dataset - struct
%             structure containing data and additional fields
%
% Note: For integration, the function 'cumtrapz' is used.
%
% WARNING: For reasonably correct results regarding cwEPR spectra, those
% spectra should be baseline-correced before integrating them.
%
% A proper sequence may look as follows:
%
%   dataset = cwEPRimport('<filename>');
%   dataset = cwEPRsubtractBaseline(dataset, 'degree', 0);
%   dataset = cwEPRintegrate(dataset);
%
% If you would like to further process the integrated spectra, often, an
% additional baseline correction needs to be performed:
%
%   dataset = cwEPRsubtractBaseline(dataset, 'degree', 1);

% Copyright (c) 2019-20, Till Biskup
% 2020-10-05

dataset.data = cumtrapz(dataset.data);

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Integration';
history.purpose = 'Integrate spectrum';
dataset.history{end+1} = history;

end