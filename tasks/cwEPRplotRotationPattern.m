function cwEPRplotRotationPattern(dataset, varargin)
% CWEPRPLOTROTATIONPATTERN displays rotation patterns of EPR spectra 
% obtained by using a goniometer.
%
% Usage:
%   cwEPRplotRotationPattern(dataset)
%   cwEPRplotRotationPattern(dataset, 'parameter', <value>)
%
%   dataset - struct
%             cwEPR Toolbox dataset containing data and metadata
%
%
%   Optional parameters
%
%   summaryOnly - logical
%       Whether to show only summary figure
%
%       default: true
%
%   xrange - vector
%       Range of x axis
%
%       Useful for zooming into the x axis
%
%   title - string
%       Title for figure(s), including summary figure using several axes
%
%       Uses MATLAB's sgtitle function introduced as late as R2018b

% Copyright (c) 2020, Till Biskup
% 2020-09-07

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset', @(x)isstruct(x));
    p.addParameter('summaryOnly', true, @islogical);
    p.addParameter('xrange', [], @isvector);
    p.addParameter('title', '', @ischar);
    p.parse(dataset, varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

parameters = p.Results;

% Some settings
figureOffset = 100;

% Get axes and data
B0 = dataset.axes.data(1).values; % magnetic field in mT
angle = dataset.axes.data(2).values; % angle in degree
data = dataset.data;

stackOffset = 0.5*max(data(:, 1));

% Baseline correction
% for spectrum = 1:length(angle)
%     data(:, spectrum) = data(:, spectrum) - mean(data(1:50, spectrum));
% end

xrange = parameters.xrange;
if isempty(xrange)
    xrange = B0([1, end]);
end

if ~parameters.summaryOnly
    % First plot - transpose data for magnetic field being x axis
    figure(figureOffset)
    imagesc(B0, angle, data')
    % images have coordinate origin in the top left corner
    % We want the origin in the lower left corner, hence revert y axis
    % direction
    set(gca, ...
        'ydir', 'normal', ...
        'ylim', angle([1 end]), ...
        'tickdir', 'out' ...
        );
    xlabel('{\itmagnetic field} / mT');
    ylabel('{\itangle} / degree');
    
    % Contour plot
    figureOffset = figureOffset + 1;
    figure(figureOffset)
    contourf(B0, angle, data', 30)
    xlabel('{\itmagnetic field} / mT');
    ylabel('{\itangle} / degree');
    
    % 1D plot
    figureOffset = figureOffset + 1;
    figure(figureOffset)
    plot(B0,data)
    set(gca, 'xlim', B0([1, end]))
    xlabel('{\itmagnetic field} / mT');
    
    % 1D stack plot
    figureOffset = figureOffset + 1;
    figure(figureOffset)
    offset = 0;
    hold on
    for spectrum = 1:length(angle)
        plot(B0, data(:, spectrum) + offset, 'k');
        offset = offset + stackOffset;
    end
    hold off
    set(gca, ...
        'xlim', B0([1, end]), ...
        'ylim', [min(data(:, 1))*1.1 max(data(:, end))*1.1+(length(angle)-1)*stackOffset], ...
        'ytick', [0:stackOffset*2:(length(angle)-1)*stackOffset], ...
        'tickdir', 'out', ...
        'ticklength', [0.005, 0] ...
        )
    xlabel('{\itmagnetic field} / mT');
    set(gcf, 'Position', [10 10 300 1000]);
end

% Combined figure with several subplots
figureOffset = figureOffset + 1;
figure(figureOffset)

if exist('sgtitle', 'file')
    sgtitle(parameters.title);
end

subplot(2, 2, 1)
% Contour plot
contourf(B0, angle, data', 30)
set(gca, ...
    'xlim', xrange, ...
    'box', 'off', ...
    'tickdir', 'out' ...
    );
xlabel('{\itmagnetic field} / mT');
ylabel('{\itangle} / degree');

subplot(2, 2, 3)
imagesc(B0, angle, data')
% images have coordinate origin in the top left corner
% We want the origin in the lower left corner, hence revert y axis
% direction
set(gca, ...
    'xlim', xrange, ...
    'ydir', 'normal', ...
    'ylim', angle([1 end]), ...
    'box', 'off', ...
    'tickdir', 'out' ...
    );
xlabel('{\itmagnetic field} / mT');
ylabel('{\itangle} / degree');

subplot(2, 2, [2, 4])
offset = 0;
hold on
for spectrum = 1:length(angle)
    plot(B0,data(:, spectrum) + offset, 'k');
    offset = offset + stackOffset;
end
hold off
set(gca, ...
    'xlim', xrange, ...
    'ylim', [min(data(:, 1))*1.1 max(data(:, end))*1.1+(length(angle)-1)*stackOffset], ...
    'ytick', [0:stackOffset*2:(length(angle)-1)*stackOffset], ...
    'yticklabel', num2str(angle(1:2:end)), ...
    'XGrid', 'on', ...
    'tickdir', 'out', ...
    'ticklength', [0.005, 0] ...
    )
xlabel('{\itmagnetic field} / mT');
ylabel('{\itangle} / degree');

set(gcf, 'Position', [200 20 800 800]);
