function cwEPRpowerSweepAnalysisCLI
% CWEPRPOWERSWEEPANALYSISCLI Command-line interface for interactive
% analysis of cw-EPR power sweeps.
%
% The idea behind the analysis of power sweeps from cw-EPR is as follows:
%
% 1) Plot spectra and ask user for a field point of the spectrum the
%    analysis should be performed for
%
% 2) Plot sqrt(power) vs. EPR intensity and ask user for number of points
%    that shall be used for a linear regression of the linear region
%
% 3) Plot MW attenuation in dB vs. deviation of EPR intensity from linear
%    regression performed in previous step.
%
% With the information from the plot of step three, the user shall
% immediately have the information necessary: The minimum attenuation
% necessary not to distort the signal.
%
% Currently (2015-11-11), this CLI is highly dependent on the particular
% setup used (Bruker EMX, decreasing MW power), but will be made more
% failsave in the future.
%
% Acknowledgements: The plot of step three was an idea of Lorenz Heidinger.

% Copyright (c) 2015-16, Till Biskup
% 2016-11-30

% Welcome message with a bit of explanation to guide the user
welcomeMessage = {...
    ''...
    'Analysis of power sweeps from cw-EPR'...
    ''...
    'NOTE: Works currently only for Bruker EMX data measured with'...
    '      decreasing power (increasing attenuation).'...
    ''...
    'The following steps are necessary:'...
    ''...
    '1) Enter filename (needs file extension!)'...
    ''...
    '2) Provide field index for further analysis (default: maximum)'...
    ''...
    '3) Provide number of points for linear regression (default: 5)'...
    ''...
    'The final result is a plot of the deviation of the EPR intensity'...
    'from the linear regression vs. MW attenuation in dB.'...
    ''...
    'This gives immediate access to the minimum attenuation required'...
    'not to saturate the sample.'...
    ''...
    };
cellfun(@(x)fprintf('  %s\n',x),welcomeMessage);


% 1st step: Ask user for data
fileName = '';
while isempty(fileName)
    fileName = CLIinput('Filename of file containing powerSweep data');
    data = cwEPRimport(fileName);
    if isempty(data.data)
        fileName = '';
    end
end

% Remove extension from filename for further use (saving plot figures)
[filePath,fileBasename,~] = fileparts(fileName);
fileName = fullfile(filePath,fileBasename);

% 2nd step: Plot data and ask user for field index
figure();
plot(data.data');
set(gca,'XLim',[1 size(data.data,2)]);
xlabel('{\it index}')
ylabel('{\it signal intensity}');

[~,fieldIndex] = max(data.data(1,:));

fieldIndex = CLIinput(...
    'Field index used for further analysis',...
    'numeric',true,'default',num2str(fieldIndex));

% 3rd step: Plot sqrt(power) vs. EPR intensity and ask user for number of
%           points used for the linear regression
sqrtP = sqrt(EPRdB2mW(data.axes.data(2).values));
eprI = data.data(:,fieldIndex)';
figure();
plot(sqrtP,eprI,'kd-');
xlabel('sqrt({\itP}) / mW')
ylabel('{\it signal intensity}');

nPtLinReg = CLIinput(...
    'Number of points for linear regression',...
    'numeric',true,'default','5');

% 4th step: Plot sqrt(power) vs. EPR intensity and deviation of EPR
% intensity from linear regression
coeff = polyfit(sqrtP(end-nPtLinReg+1:end),eprI(end-nPtLinReg+1:end),1);
linReg = polyval(coeff,sqrtP);

ylim = get(gca,'YLim');
hold on;
plot(sqrtP,linReg,'k-');
hold off;
set(gca,'YLim',ylim);
xlabel('sqrt({\itP}) / mW')
ylabel('{\it signal intensity}');

figure();
plot(data.axes.data(2).values,linReg-eprI,'kd-');
xlim = get(gca,'XLim');
hold on; 
plot([0 50],[0 0],'k:'); 
hold off; 
set(gca,'XLim',xlim);
xlabel('{\it MW attenuation} / dB')
ylabel('{\it deviation from linear regression}');
set(gca,'XLim',[min(data.axes.data(2).values)-1 max(data.axes.data(2).values)+1]);

commonFigureExport(gcf,[fileName '-linRegDeviation']);

end