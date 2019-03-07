function [signal_corr, poly] = baseline_correction(signal, varargin)

% Polynomial baseline correction for cw-EPR data
%
% [signal, poly] = baseline_correction(signal, varargin)
%
%   signal                         - Vector
%                                    input data
%
%   varargin(1)                    - Integer
%                                    polynomial degree (default 1)
%
%   varargin(2)                    - Integer
%                                    number of average points (default 40)
%
%   signal_corr                    - Vector
%                                    baseline corrected spectrum
%
%   poly                           - Vector
%                                    polynomial baseline function
%
%
% (c) 2017, Stephan Rein, University of Freiburg


s = signal;
si = size(signal);
if si(1) ~= 1
    signal = signal';
end

%Check input and set  default average region
if ~isempty(varargin)    
    if length(varargin) == 1
          polynomial = varargin{1};
          N_average = 100;
    end
    if length(varargin) ==2
          N_average = varargin{2};
          polynomial = varargin{1};
    end    
else
    N_average = 100;
    polynomial = 1;
end

%Split the data vector
splitdatavec = [signal(1:N_average), signal(end-N_average+1:end)];
vec = 1:length(signal);
splitxvec = [vec(1:N_average)  vec(end-N_average+1:end)];

p = polyfit(splitxvec,splitdatavec,polynomial);
poly = polyval(p,vec);
signal_corr = signal-poly;

%Return transposed vector if wished
if si(1) ~= 1
    signal_corr = signal_corr';
end

return 







