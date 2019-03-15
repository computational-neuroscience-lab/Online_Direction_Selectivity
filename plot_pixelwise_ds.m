% Code for online analysis of direction selectivity of calcium traces
% Based on the paper from Baden et al. (2016)
% Author: Francesco Trapani (Institut De la Vision, PARIS)

function plot_pixelwise_ds(tiff_file, IMG_RATE, bars_vec, BARS_RATE, SNR_THRESHOLD)

% do DS analysis
[ds_map, snr_map] = do_online_ds(tiff_file, IMG_RATE, bars_vec, BARS_RATE);
map = ds_map .* (snr_map > SNR_THRESHOLD);

% put together the picture
background_img = create_background_img(tiff_file);
color_img = zeros(size(background_img, 1), size(background_img, 2), 3);
color_img(:,:,1) = map / 2;
color_img(:,:,2) = background_img;
color_img(:,:,3) = background_img;

% plot
figure()
ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 800;
horz = 800;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

imagesc(color_img);

title_txt = strcat("pixelwise Direction Selectivity: ", tiff_file);
title(title_txt, 'Interpreter', 'none')
axis off


