% Code for online analysis of direction selectivity of calcium traces
% Based on the paper from Baden et al. (2016)
% Author: Francesco Trapani (Institut De la Vision, PARIS)

function [ds_map, angle_map, snr_map] = do_online_ds(img, frame_rate, bars_vec, bars_rate, blurring_factor)
% ARGS
%   tiff_file:  path to the .tiff video of the calcium recording
%   frame_rate: frame rate of the .tiff video (in Hz)
%   bars_vec: path to the .vec file representing the bars stimulus
%   bars_rate: frame rate of the bars stimulus (in Hz)
%   blurring_factor: sigma of the gaussian kernel convolved to the calcium images

% params
MIN_N_FRAMES_BASELINE = 10;

% Load & Filter data
img_blurred = imgaussfilt(img, blurring_factor);

[n_rows, n_columns, n_frames_recording] = size(img_blurred);
n_pixels = n_rows * n_columns;

traces = reshape(img_blurred, [n_pixels, n_frames_recording]);

% Get the structure of the bars stim
[angles, angles_sequence, bar_duration, baseline_duration] = get_bars_infos(bars_vec, bars_rate);

n_angles = length(angles);
n_bars = length(angles_sequence);

n_frames_baseline = baseline_duration * frame_rate;
n_frames_1bar = bar_duration * frame_rate;

% Make sure that the recording is as long as the whole bars stim.
% If this is not the case, discard the repetitions that were not recorded.
n_bars_recorded = floor((n_frames_recording - n_frames_baseline) / n_frames_1bar);
if n_bars_recorded >= n_bars
    n_bars_recorded = n_bars;
else
    fprintf("WARNING: %i bar repetitions were not recorded\n", n_bars - n_bars_recorded);
end
    
angles_sequence = angles_sequence(1:n_bars_recorded);
n_frames = ceil((n_bars_recorded * n_frames_1bar) + n_frames_baseline);
    
% Calcium traces are extracted as (f - f0) / f0.
% f0 is the spontaneous activity measured in the [X] seconds preceeding the stimulus
if n_frames_baseline < MIN_N_FRAMES_BASELINE
    error("Not enough frames to estimate spontaneous activity")
end

f_baseline = traces(:, 1:round(n_frames_baseline));
f_bars = traces(:, round(n_frames_baseline + 1):n_frames);

f0 = median(f_baseline, 2);
f = (f_bars - f0) ./ f0;

% For each angle, retrieve the repetitions
% and compute the median response.
fmean_by_angle = zeros(n_pixels, floor(n_frames_1bar), n_angles);

% Signal-to-noise ratio indices are computed to assess
% the quality of the responses.
snr_by_angle = zeros(n_pixels, n_angles);

for i_angle = 1:n_angles
    
    repetition_indices = find(angles_sequence == i_angle);
    f_rep = zeros(n_pixels, numel(repetition_indices), floor(n_frames_1bar));
    
    for i_rep = 1:numel(repetition_indices)
        rep_slot = repetition_indices(i_rep) - 1;
        rep_start = 1 + round(rep_slot * n_frames_1bar);
        rep_end = rep_start + floor(n_frames_1bar) -1;
        f_rep(:, i_rep, :) = f(:, rep_start:rep_end);
    end
    
    fmean_by_angle(:, :, i_angle) = median(f_rep, 2);
    snr_by_angle(:, i_angle) = compute_snr(f_rep);
end

% normalize
peaks = max(max(abs(fmean_by_angle), [], 3), [], 2);
fmean_by_angle_norm = fmean_by_angle ./ peaks;

% compute direction selectivity
[ds_indices, ds_angle, ds_modules] = compute_dsi(angles, fmean_by_angle_norm);
[~, preferred_direction] = max(ds_modules, [], 2);

% Just consider signal to noise ratio for the preferred direction
snr = zeros(1, n_pixels);
for i_pixel = 1:n_pixels
    snr(i_pixel) = snr_by_angle(i_pixel, preferred_direction(i_pixel));
end

% reconstruct the ds map
ds_map = reshape(ds_indices, [n_rows, n_columns]);
angle_map = reshape(ds_angle, [n_rows, n_columns]);
snr_map = reshape(snr, [n_rows, n_columns]);
