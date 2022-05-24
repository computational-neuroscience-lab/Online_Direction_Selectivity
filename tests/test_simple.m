close all
clear
clc

% parameters
% tiff_file = "tests/data/tiffs/bars_180410a.tif";
tiff_file = 'tests/data/tiffs/CaTrace4.tif';
img_rate = 7.82;	% Hz

% bars_vec = "tests/data/stim/bars.vec";
bars_vec = 'tests/data/stim/DSnew2.vec';
bars_rate = 50;     % Hz

blur_factor = 0.8;
snr_threshold = 0.4;
ds_threshold = 0.3;

tic
plot_pixelwise_ds(tiff_file, img_rate, bars_vec, bars_rate, blur_factor, ds_threshold, snr_threshold);
fprintf("test time = %f secs\n", toc);