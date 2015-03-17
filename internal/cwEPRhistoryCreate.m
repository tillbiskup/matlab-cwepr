function history = cwEPRhistoryCreate
% CWEPRHISTORYCREATE Create and return data structure of cw-EPR 
% history record.
%
% Usage
%   history = cwEPRhistoryCreate
%
%   history       - struct
%                   Structure complying with minimal history record
%

% Copyright (c) 2014-15, Till Biskup
% Copyright (c) 2014-15, Deborah Meyer
% 2015-03-16

% Define version of dataset structure
structureVersion = '0.1';

history = commonHistoryCreate(structureVersion);
