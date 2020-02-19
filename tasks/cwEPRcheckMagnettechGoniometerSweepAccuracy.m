function cwEPRcheckMagnettechGoniometerSweepAccuracy(filename)
% Check the accuracy of the goniometer sweep of a Magnettech MS5000.
%
% Usage
%     cwEPRcheckMagnettechGoniometerSweepAccuracy(filename)
%
%     filename - string
%                Name of the (info) file corresponding to the dataset
%
% The dataset is constructed using the cwEPRimportMagnettechGoniometerSweep
% function of the cwepr toolbox. Furthermore, two plots are created and
% saved, namely a 2D overview of the rotational pattern and a 1D plot
% showing the deviation of the set and actual angle. The files are named
% "angular-pattern.pdf" and "angle-deviation.pdf", respectively.
%
% Some measurements with orientation-dependent samples gave hints on the
% inaccuracy of the Magnettech goniometer sweeps, namely large deviations
% between actual and set goniometer angle of about 2 degrees. Furthermore,
% the spectra seem not very reliably recorded, as the 2D pattern of the
% interpolated data shows.

% Copyright (c) 2020, Till Biskup
% 2020-02-19

dataset = cwEPRimportMagnettechGoniometerSweep(filename);

figure(100)
commonPlot(dataset);
set(gca,...
    'XLim', [338 338.8], ...
    'TickDir', 'out', ...
    'Box', 'off' ...
    );

real_angles = dataset.axes.data(2).values;
set_angles = linspace(0, 180, length(real_angles));

commonFigureExport(gcf, 'angular-pattern.pdf', ...
    'PaperSize', [16, 16] ...
);

figure(101)
plot(set_angles,real_angles-set_angles');
hold on
plot([-1, 181], [0, 0], 'k:');
hold off
set(gca, ...
    'XLim', [-1, 181], ...
    'TickDir', 'out', ...
    'Box', 'off' ...
    );
xlabel('{\itangle} / degree');
ylabel('{\itangle difference} / degree');
title(sprintf('Step size: %3.1f degree', 180/(length(real_angles)-1)));

commonFigureExport(gcf, 'angle-deviation.pdf', ...
    'paperSizeCorrection', [-0.6 0.2 1.8 0] ...
);

end
