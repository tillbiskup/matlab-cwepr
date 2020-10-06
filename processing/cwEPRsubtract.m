function dataset = cwEPRsubtract(dataset,tosubtract)
% CWEPRSUBTRACT subtract any vector with same length as dataset.data 
% from a cw-EPR spectrum and writes history
%
% Usage
%   dataset = cwEPRsubtract(dataset,vector)
%
%   dataset    - struct
%                structure containing data and additional fields
%
%
%   tosubtract - vector 
%                any vector with same length as dataset.data
%                            

% Copyright (c) 2016-20, Till Biskup, Jara Popp, Deborah Meyer
% 2020-10-06

if ~isequal(numel(tosubtract),numel(dataset.data))
    disp(['(EE) ' 'vector length not equal to data length']);
    return
end

tosubtract = reshape(tosubtract, size(dataset.data));

dataset.data = dataset.data-tosubtract;

% Write history
history = cwEPRhistoryCreate();
history.kind = 'Subtraction';
history.purpose = 'Subtraction of given vector from data';
history.parameters = {tosubtract};
dataset.history{end+1} = history;

end