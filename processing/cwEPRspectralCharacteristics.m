function characteristics = cwEPRspectralCharacteristics(dataset,varargin)
% CWEPRSPECTRALCHARACTERISTICS Calculate a few characteristics of the
% spectra of a given dataset, assuming baseline-free spectra.
%
% Usage
%   cwEPRspectralCharacteristics(dataset)
%   characteristics = cwEPRspectralCharacteristics(dataset)
%
%   dataset         - stucture
%                     Dataset complying with specification of toolbox
%                     dataset structure
%
%   characteristics - structure
%                     tbd
%
% NOTE: This routine assumes basically baseline-free spectra and calculates
%       just a few numbers that might be of interest for a 0th-order
%       analysis of cw-EPR spectra.

% Copyright (c) 2015, Till Biskup
% 2015-11-18

% Assign default output
characteristics = struct();

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset',@(x)isstruct(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Calculate sum of spectrum: indication of phase error
characteristics.sum.absolute = sum(dataset.data);
characteristics.sum.relative = ...
    characteristics.sum.absolute/sum(abs(dataset.data));

% Calculate line width, assuming a single line, using pk2pk
[~,iMax] = max(dataset.data);
[~,iMin] = min(dataset.data);
characteristics.linewidth.pk2pk = ...
    diff(dataset.axes.data(1).values([iMax iMin]));
% Calculate line width as FWHM
integ = cumsum(dataset.data);
fieldPoints = find(integ>(max(integ)/2));
characteristics.linewidth.fwhm = ...
    diff(dataset.axes.data(1).values([fieldPoints(1) fieldPoints(end)]));

% Calculate maximum of line (zero crossing)
[~,iMaxInteg] = max(cumsum(dataset.data));
[~,iMaxZeroX] = min(abs(dataset.data(iMax:iMin)));
characteristics.max.integral = dataset.axes.data(1).values(iMaxInteg);
characteristics.max.zeroCrossing = ...
    dataset.axes.data(1).values(iMax+iMaxZeroX-1);

% Calculate asymmetry of line
characteristics.asymmetry.absolute = ...
    characteristics.max.zeroCrossing-characteristics.max.integral;
characteristics.asymmetry.relative = ...
    characteristics.asymmetry.absolute/characteristics.linewidth.pk2pk;

if nargout==0
    cwEPRspectralCharacteristicsDisp(characteristics)
end

end
