function cwEPRbatchPreprocessEMX
% CWEPRBATCHPREPROCESSEMX Import EMX raw data, perform field correction
% (with measured LiLiF standard), frequency correction (default: 9.7 GHz),
% save as cwEPR datasets, plot and export figures (both PDF and PNG),
% create dokuwiki block for including the figure in electronic lab book.
%
% Usage:
%   cwEPRbatchPreprocessEMX
%
% For each dataset a dokuwiki block is created for including the figure,
% using the filename with prepended date (YYYYMMDD). The PNG file is moved
% to this name (with prepended date), the PDF file copied. 
%
% Thus, you will end up with a whole series of files created for each dataset:
%
%   <filename>.xbz           - the cwEPR dataset
%   <filename>.pdf           - plot as PDF file (output of commonPlot)
%   YYYYMMDD-<filename>.png  - plot as PNG file for dokuwiki lab book
%   YYYYMMDD-<filename>.pdf  - plot as PDF file for dokuwiki lab book
%   YYYYMMDD-<filename>.txt  - caption for plot for dokuwiki lab book
%
% The template used for creating the caption for the dokuwiki lab book is
% named "dwLabbook1DFigureCaption.txt" and located in the template
% directory of your cwEPR toolbox installation. You may change it according
% to your purposes.
%
% Limitations:
%
% Looks for files with spc extension (case INsensitive) and performs
% processing steps for all these files excluding those with "lilif" 
% (case INsensitive) in name.
%
% Dependencies:
%
% Relies on common toolbox and ImageMagick installation (for PNG export).

% Copyright (c) 2016, Till Biskup
% 2016-11-18

% Default value for field and frequency correction
DeltaB0 = 0;
MWfrequency = 9.7; % in GHz

% Lookup lilif file - assuming lilif in name (case INsensitive) - and get
% DeltaB0 value if successful.
lilifFilename = commonDir('*lilif*spc');

if ~isempty(lilifFilename)
    DeltaB0 = cwEPR_fieldStandardLiLiF(lilifFilename{1});
end

% Get filenames of spectra and remove lilif filename(s) from cell array
spcFileNames = commonDir('*spc');
spcFileNames(~cellfun('isempty',strfind(lower(spcFileNames),'lilif'))) = [];

for spcFile = 1:length(spcFileNames)
    
    [~,filename,~] = fileparts(spcFileNames{spcFile});
    
    dataset = cwEPRimport(filename);
    dataset = cwEPRfieldCorrection(dataset,DeltaB0);
    dataset = cwEPRfrequencyCorrection(dataset,MWfrequency);
    cwEPRsave(filename,dataset);
    
    commonPlot(dataset)
    commonFigureExport(gcf,filename);
    pdf2bitmap(filename);
    
    createDokuwikiCaption(dataset,filename);
    
    % Rename PNG file and copy PDF file: prepend date (yyyymmdd)
    dateString = datestr(datenum(dataset.parameters.date.start,31),'yyyymmdd');
    movefile([filename '.png'],[dateString '-' filename '.png']);
    copyfile([filename '.pdf'],[dateString '-' filename '.pdf']);

end

end


function createDokuwikiCaption(dataset,filename)

dateString = datestr(datenum(dataset.parameters.date.start,31),'yyyymmdd');
dataset.filename = [dateString '-' filename];

templateFile = cwEPRtemplateFilepath('dwLabbook1DFigureCaption.txt');

t = tpl();
t.setDelimiter({'<<','>>'});
t.setTemplate(templateFile);
t.setAssignments(dataset);
output = t.render();
commonTextFileWrite([dateString '-' filename '.txt'],output);

end