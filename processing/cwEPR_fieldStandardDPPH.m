function deltaB0 = cwEPR_fieldStandardDPPH(filename,varargin)
% CWEPR_FIELDSTANDARDDPPH Read DPPH spectrum and calculate DeltaB0 value
% for field calibration that can be used by the cwEPRfieldCalibration
% routine.
%
% Usage
%   deltaB0 = cwEPR_fieldStandardDPPH(filename)
%
%   filename - string
%              Name of file containing DPPH spectrum 
%
%   deltaB0  - scalar
%              Field difference calculated from DPPH spectrum
%
% NOTE: The function assumes the DPPH spectrum to be baseline-free and
%       calculates the field position for the g_iso value by integrating
%       the spectrum and taking the maximum of the result.

% Copyright (c) 2015, Till Biskup
% 2015-11-18

% Assign default output
deltaB0 = 0;

% g value for DPPH (stes-rsi-60-2949)
gDPPH = 2.0036;

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('filename', @(x)ischar(x));
    p.parse(filename,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Load DPPH spectrum
dataset = cwEPRimport(filename);

if isempty(dataset.data)
    warning('Could not load file "%s"',filename);
    return;
end

% Calculate B0 value of center of line for DPPH spectrum using the
% integrated spectrum
[~,iMax] = max(cumsum(dataset.data));
B0DPPHmeas = dataset.axes.data(1).values(iMax);

% Calculate B0 for DPPH with given experimental frequency
B0DPPH = EPRg2mT(gDPPH,...
    dataset.parameters.bridge.MWfrequency.value*1e9);

deltaB0 = B0DPPH-B0DPPHmeas;

end
