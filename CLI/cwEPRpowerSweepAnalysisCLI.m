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

% Copyright (c) 2015, Till Biskup
% 2015-11-11

% 1st step: Ask user for data
fileName = '';
while isempty(fileName)
    fileName = cliInput('Filename of file containing powerSweep data');
    if ~exist(fileName,'file')
        fileName = '';
    end
end

data = EPRbrukerSPCimport(fileName);

% 2nd step: Plot data and ask user for field index
figure();
plot(data.data);

fieldIndex = cliInput(...
    'Field index used for further analysis','numeric',true);

% 3rd step: Plot sqrt(power) vs. EPR intensity and ask user for number of
%           points used for the linear regression
sqrtP = sqrt(EPRdB2mW(data.axes(2).values));
eprI = data.data(fieldIndex,:);
figure();
plot(sqrtP,eprI,'d-');
xlabel('{\it index}')
ylabel('{\it signal intensity}');

nPtLinReg = cliInput(...
    'Number of points for linear regression','numeric',true);

% 4th step: Plot sqrt(power) vs. EPR intensity and deviation of EPR
% intensity from linear regression
coeff = polyfit(sqrtP(end-nPtLinReg:end),eprI(end-nPtLinReg:end),1);
linReg = polyval(coeff,sqrtP);

ylim = get(gca,'YLim');
hold on;
plot(sqrtP,linReg,'k-');
hold off;
set(gca,'YLim',ylim);
xlabel('sqrt({\itP}) / mW')
ylabel('{\it signal intensity}');

figure();
plot(data.axes(2).values,linReg-eprI,'d-');
xlim = get(gca,'XLim');
hold on; 
plot([0 50],[0 0],'k:'); 
hold off; 
set(gca,'XLim',xlim);
xlabel('{\it MW attenuation} / dB')
ylabel('{\it deviation from linear regression}');

end