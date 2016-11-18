function filePath = cwEPRtemplateFilepath(fileName)
% CWEPRTEMPLATEFILEPATH Return full file including path for template file.
%
% Usage
%   file = cwEPRtemplateFilepath()
%
%   file - string
%          Full path to template file
%          Empty if not found
%
% NOTE: Currently, even if you have subdirectories in your template
% directory, only the files from the template directory itself will be
% returned.

% Copyright (c) 2016, Till Biskup
% 2016-11-18

filePath = commonTemplateFilepath(fileName,'prefix','cwEPR');

end