function [realsignal,imagsignal] = hilbert_transform(realsignal)

% Hilbert transformation (based on FFT approximation) to generate imaginary
% part of a spectrum
%
% Usage:
%   [realsignal,imagsignal] = hilbert_transform(realsignal)%
%
%   realsignal              - vector
%                             real data
%
%   realsignal              - vector
%                             real data output
%
%   imagsignal              - vector
%                             imaginary data output
%
%
% (c) 2017, Stephan Rein

%Check if the vector is transposed
dim = size(realsignal);

if dim(1) == 1
    realsignal =  realsignal';
end
%Make Fourier transform of the real input data
real_tmp = fft(realsignal);

%Convolution with signum permutation (rotation in complex plane)
h = zeros(length(real_tmp),1);
x = length(real_tmp);
for i=1:x
    if i >= 2 && i  <= x/2
        h(i) = 2;
    elseif i >= x/2+2
        h(i) = 0;
    else
        h(i) = 1;
    end
end

%Real convolution
real_tmp = real_tmp.*h;

%Inverse Fourier Transform
imagsignal = imag(ifft(real_tmp));
realsignal = real(ifft(real_tmp));

if dim(1) == 1
    realsignal =  realsignal';
    imagsignal = imagsignal';
end

end