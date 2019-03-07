function [realsignal_pc,  phi] = APC(realsignal, varargin)

% Usage:
%   [realsignal_pc,  phi] = APC(realsignal, varargin)
%
%   realsignal              - Vector
%                             original data vector
%
%   Optional parameter. Passed in a structure (e.g. Option.order = 2)
%
%   order                   - Integer 
%                             Degree of Harmonic (default is 1)
%
%   method                  - String ('Fourier')
%                             Use conjugated Fourier space method instead
%                             of the phace correction in the field domain
%
%   OUTPUT
%   realsignal_pc           - vector
%                             phase corrected data
%
%
% Algorithms for the phase correction of EPR data.
% First the imaginary part of the real valued signal
% is reconstructed using a Hilbert transform (for details see
% Hilbert_transform). Afterwards the signal is is rotated in the complex
% plane and integrated (also multiple integrations are possible) to an
% absorptive signal. The signal is evaluated regarding the optimal phase:
% Method 1: The integral of the negative parts of the absorptive signal is
% minimized.
% Method 2: The sum over the first 3 and last 3 elements of the Fourier
% transform of the absorptive signal is maximized.
%
% Copyright (c) 2017, Stephan Rein


%Initial phase
method = 1;
order = 1;
phi = 0;

%Calculate a Hilbert transform of the real valued signal
[realsignal_org_tmp,imsignal_org] = hilbert_transform(realsignal);
complete_sig = realsignal_org_tmp+1i*imsignal_org;

%Phase sweep in the complex plane in 1 degree steps for zeroth order 
min_ang = -pi/2;
max_ang = pi/2;
angles = linspace(min_ang, max_ang, 181);

%Check if additional options were passed (method or order)
if nargin >1
    if isfield(varargin{1},'method')
        if strcmpi(varargin{1}.method,'Fourier')
            method = 2;
        end
    end
    if isfield(varargin{1},'order')
        order = varargin{1}.order;
    end
end

%Field domain correction
if method == 1
    FT_sig_tmp = complete_sig;
    if order > 0
        for j = 1:order
            FT_sig_tmp = cumtrapz(FT_sig_tmp);
        end
    end
    FT_sig_tmp = (baseline_correction(real(FT_sig_tmp),1,10));
    t_best2 = abs(trapz(FT_sig_tmp(FT_sig_tmp<0)));
    %Run loop to find the best phase
    for k = 1:length(angles)
        rotate =  (exp(1i*angles(k)).*(complete_sig));
        FT_sig_tmp= rotate;
        if order > 0
            for j = 1:order
                FT_sig_tmp = cumtrapz(FT_sig_tmp);
            end
        end
        FT_sig_tmp = (baseline_correction(real(FT_sig_tmp),1,10));
        t2 = abs(trapz(FT_sig_tmp(FT_sig_tmp<0))); 
        if t2 < t_best2
            t_best2 = t2;
            phi = angles(k);
        end
    end
    str = 'Field domain method was used';
%Fourier space correction
elseif method == 2
    FT_sig_tmp = complete_sig;
    if order > 0
        for j = 1:order
            FT_sig_tmp = cumsum(FT_sig_tmp);
        end
    end
    FT_sig_tmp = (baseline_correction(real(FT_sig_tmp),1,10));
    start = fft(FT_sig_tmp);
    t_max = abs(sum(real(start(1:3)))+abs(sum(real(start(end-3:end)))));
    for k = 1:length(angles)
        rotate =  real(exp(1i*angles(k)).*(complete_sig));
        FT_sig_tmp = rotate;
        if order > 0
            for j = 1:order
                FT_sig_tmp = cumsum(FT_sig_tmp);
            end
        end
        FT_sig_tmp = (baseline_correction(real(FT_sig_tmp),1,10));
        FT_sig_tmp = fft(FT_sig_tmp);
        t = abs(sum(real(FT_sig_tmp(1:3))))+abs(sum(real(FT_sig_tmp(end-3:end))));
        if t > abs(t_max)
            t_max = abs(t);
            phi = angles(k);
        end
    end
    str = 'Fourier space method was used';
end
realsignal_pc =  real(exp(1i*phi)*(complete_sig));
fprintf(str)
fprintf('\nPhase correction was carried out with phi = %f',phi*(180/pi));
fprintf(' degree\n');
