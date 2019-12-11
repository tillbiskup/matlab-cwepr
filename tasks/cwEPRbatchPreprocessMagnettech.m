function cwEPRbatchPreprocessMagnettech(varargin)
% CWEPRBATCHPREPROCESSMAGNETTECH Import Magnettech raw data, perform
% frequency correction (default: 9.48 GHz), save as cwEPR datasets, plot
% and export figures (both PDF and PNG), create dokuwiki block for
% including the figure in electronic lab book.
%
% Usage:
%   cwEPRbatchPreprocessMagnettech
%
% For each dataset a dokuwiki block is created for including the figure,
% using the filename with prepended date (YYYYMMDD). The PNG file is moved
% to this name (with prepended date), the PDF file copied. 
%
% Thus, you will end up with a whole series of files created for each
% dataset:
%
%   <filename>.xbz           - the cwEPR dataset
%   <filename>.pdf           - plot as PDF file (output of commonPlot)
%   YYYYMMDD-<filename>.png  - plot as PNG file for dokuwiki lab book
%   YYYYMMDD-<filename>.pdf  - plot as PDF file for dokuwiki lab book
%   YYYYMMDD-<filename>.txt  - caption for plot for dokuwiki lab book
%
% The template used for creating the caption for the dokuwiki lab book is
% named "dwLabbook1DFigureCaption-Magnettech.txt" and located in the
% template directory of your cwEPR toolbox installation. You may change it
% according to your purposes.
%
% Limitations:
%
% Looks for files with INFO extension (case INsensitive) and performs
% processing steps for all these files.
%
% Dependencies:
%
% Relies on common toolbox and ImageMagick installation (for PNG export).

% Copyright (c) 2019, Till Biskup
% 2019-12-11

% Default value for field and frequency correction
DeltaB0 = 0;
MWfrequency = 9.48; % in GHz
if nargin
    MWfrequency = varargin{1};
end

% Get filenames of spectra
infoFileNames = commonDir('*info');

for infoFile = 1:length(infoFileNames)
    
    fprintf('Current (info) file: %s\n', infoFileNames{infoFile});
    
    [~,filename,~] = fileparts(infoFileNames{infoFile});
    
    xmlFilename = [filename '.xml'];
    if ~exist(xmlFilename,'file')
        fprintf('\t...skipped\n');
        continue
    end
    
    dataset = cwEPRimport(xmlFilename,'RCnorm',false,'SCnorm',false); 
    dataset = cwEPRfrequencyCorrection(dataset,MWfrequency);
    dataset = subtractZeroOrderBaseline(dataset);
    cwEPRsave(filename,dataset);
    
    commonPlot(dataset,'title','none')
    commonFigureExport(gcf,filename);
    pdf2bitmap([filename '.pdf']);
    
    createDokuwikiCaption(dataset,filename);
    
    % Rename PNG file and copy PDF file: prepend date (yyyymmdd)
    dateString = ...
        datestr(datenum(dataset.parameters.date.start,31),'yyyymmdd');
    movefile([filename '.png'],[dateString '-' filename '.png']);
    copyfile([filename '.pdf'],[dateString '-' filename '.pdf']);

end

end


function dataset = subtractZeroOrderBaseline(dataset)

dataset.data = dataset.data-mean(dataset.data([1:50,end-50:end]));

end


function createDokuwikiCaption(dataset,filename)

dateString = datestr(datenum(dataset.parameters.date.start,31),'yyyymmdd');
dataset.filename = [dateString '-' filename];

templateFile = ...
    cwEPRtemplateFilepath('dwLabbook1DFigureCaption-Magnettech.txt');

t = tpl();
t.setDelimiter({'<<','>>'});
t.setTemplate(templateFile);
t.setAssignments(dataset);
output = t.render();
commonTextFileWrite([dateString '-' filename '.txt'],output);

end