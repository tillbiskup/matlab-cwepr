function dataset = cwEPRimportMagnettechGoniometerSweep(filename)
% Import data from goniometer sweep recorded with Magnettech MS5000.
% 
% Usage
%    dataset = cwEPRimportMagnettechGoniometerSweep(filename)
%
%    filename - string
%               Name of the (info) file correspoding to the dataset
%
%    dataset  - struct
%               Structure conforming to the cwEPR dataset structure
%
% Magnettech does store each trace in a separate file. Furthermore, the
% field axes are neither consistent for each spectrum nor equidistant.
% Thus, assembling all traces in a single dataset in a matrix requires some
% advanced processing. The following steps are currently undertaken:
%
%  * Raw data are imported using EasySpins "eprload" routine
%
%  * Field axes are frequency-corrected to MW frequency of first data file
%    that got imported
%
%  * Data are interpolated to equidistant identical field axis using a
%    field precision defaulting to 1e-3 mT.
%
% IMPORTANT NOTE:
% It seems that the angles the Magnettech spectrometer records spectra for
% are not at all the angles set by the user within the software. Deviations
% of several degrees are regularly found, thus seriously questioning the
% sensibility of using the goniometer with this spectrometer.

% Copyright (c) 2020, Till Biskup
% 2020-09-07

FIELD_PRECISION = 1e-3; % in mT

[data_filenames, fpath] = get_data_filenames(filename);
[data, angles] = read_data_files(data_filenames, fpath);
dataset = create_dataset_by_interp(data, FIELD_PRECISION, angles);

dataset = apply_infofile_contents(dataset, filename);

% Just for debugging purposes, alternative way of creating a dataset
% dataset2 = create_dataset_by_cutoff(data, angles);

end


function [data_filenames, fpath] = get_data_filenames(filename)

[fpath, fname, ~] = fileparts(filename);
data_filenames = commonDir(fullfile(fpath, [fname '*.xml']));

end


function [data, angles] = read_data_files(data_filenames, fpath)

n_data_files = length(data_filenames);
data = cell(n_data_files, 1);
angles = zeros(n_data_files, 1);

for k = 1:n_data_files
    data_file = data_filenames{k};
    [B0, int, par] = eprload(fullfile(fpath, data_file));

    % Correct to MW frequency of first data file read
    if k == 1
        MWFreq = par.MwFreq;
    else
        B0 = B0_frequency_correction(B0, par.MwFreq, MWFreq);
    end
    
    data{k}.B0 = B0;
    data{k}.data = int;
    data{k}.parameters = par;
    angles(k) = par.GonAngle;
    % Special case for goniometer angle gone wrong... particularly 0 deg
    if angles(k) > 359.5
        angles(k) = 0;
    end
end

% Sort data according to angle read from parameters
[~, sort_indices] = sort(angles);
data = data(sort_indices);

end


function dataset = create_dataset_by_interp(data, FIELD_PRECISION, angles)

dataset = cwEPRdatasetCreate('numberOfAxes', 3);

B0_interpolated = get_interpolated_field_axis(data, FIELD_PRECISION);

for k = 1:length(data)
    dataset.data(:, k) = interp1(...
        data{k}.B0, ...
        data{k}.data, ...
        B0_interpolated ...
        );
end

dataset.axes.data(1).values = B0_interpolated;
dataset.axes.data(2).values = sort(angles);

dataset.axes.data(1).measure = 'magnetic field';
dataset.axes.data(1).unit = 'mT';

dataset.axes.data(2).measure = 'angle';
dataset.axes.data(2).unit = 'degree';
end


function B0_interpolated = get_interpolated_field_axis(data, FIELD_PRECISION)

field_limits = cell2mat(cellfun(...
    @(x)[min(x.B0), max(x.B0)], data, ...
    'UniformOutput', false)...
    );

B0_min = max(field_limits(:, 1));
B0_max = min(field_limits(:, 2));

B0_min_interpolated = interpolate_to_precision(B0_min, FIELD_PRECISION);
B0_max_interpolated = interpolate_to_precision(B0_max, FIELD_PRECISION);

B0_interpolated = ...
    B0_min_interpolated : FIELD_PRECISION : B0_max_interpolated;

end


function result = interpolate_to_precision(value, precision)

result = round(value ./ precision) .* precision;

end


function dataset2 = create_dataset_by_cutoff(data, angles)

data_lengths = cell2mat(cellfun(...
    @(x)length(x.B0), data, ...
    'UniformOutput', false)...
    );

dataset2 = cwEPRdatasetCreate('numberOfAxes', 3);

for k = 1:length(data)
    dataset2.data(:, k) = data{k}.data(1:min(data_lengths));
end

dataset2.axes.data(1).values = data{1}.B0(1:min(data_lengths));
dataset2.axes.data(2).values = sort(angles);

end


function B0_corr = B0_frequency_correction(B0, MW_freq_in, MW_freq_out)

g = EPRmT2g(B0,MW_freq_in);
B0_corr = EPRg2mT(g, MW_freq_out);

end

function dataset = apply_infofile_contents(dataset, filename)

[fpath, fname, ~] = fileparts(filename);
infoFileName = fullfile(fpath, [fname '.info']);

if exist(infoFileName,'file')
    [info,infoVersion] = cwEPRinfofileLoad(infoFileName);
    dataset = cwEPRdatasetMapInfo(dataset,info,infoVersion);
else
    warning('Info file %s not found - not mapped',infoFileName);
end

end