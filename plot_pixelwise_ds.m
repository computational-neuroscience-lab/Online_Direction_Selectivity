% Code for online analysis of direction selectivity of calcium traces
% Based on the paper from Baden et al. (2016)
% Author: Francesco Trapani (Institut De la Vision, PARIS)

function plot_pixelwise_ds(tiff_file, frame_rate, bars_vec, bars_rate, blur_factor, ds_threshold, snr_threshold)
% ARGS
%   tiff_file:      path to the .tiff video of the calcium recording.
%   frame_rate:     frame rate of the .tiff video (in Hz).
%   bars_vec:       path to the .vec file representing the bars stimulus.
%   bars_rate:      frame rate of the bars stimulus (in Hz).
%   blur_factor:    sigma of the gaussian kernel convolved to the images.
%   ds_threshold:	direction selectivity of a pixel is considered only if
%                   its direction-selectivity-index is above this threshold.
%   snr_threshold:  direction selectivity of a pixel is considered only if
%                   its signal-to-noise ratio is above this threshold.

img = extract_from_tiff(tiff_file);

% do DS analysis
[ds_map, angle_map, snr_map] = do_online_ds(img, frame_rate, bars_vec, bars_rate, blur_factor);
map = ds_map .* (snr_map > snr_threshold) .* (ds_map > ds_threshold);

% put together the picture
background_img = create_background_img(img);
[n_rows, n_cols] = size(background_img);

hue = (angle_map + pi) ./ (2 * pi); 
saturation = map ./ 2;
lightness = background_img;

hsl_img = zeros(n_rows, n_cols, 3);
hsl_img(:,:,1) = hue;
hsl_img(:,:,2) = saturation;
hsl_img(:,:,3) = lightness;
rgb_img = hsl2rgb(hsl_img);

% create the colormap
hslMap = [linspace(0,1,360)', ones(360,1)*.5,  ones(360,1)*.5];
rgbMap = hsl2rgb(hslMap);

% plot
figure()

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 800;
horz = 800;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

imagesc(rgb_img);
title_txt = {"Pixelwise Direction Selectivity:", string(tiff_file)};
title(title_txt, 'Interpreter', 'none')
axis off

colormap(rgbMap);
bar_ticks =  0:.125:1;
% bar_labels = {"-\pi", "-3/4\pi","-1/2\pi", "-1/4\pi", "0", "1/4\pi" "1/2\pi" "3/4\pi", "\pi"};
% cbar.Label.String = 'Preferred Direction (rads)';
% 
bar_labels = {"4", "5","6", "7", "0", "1" "2" "3", "4"};
cbar.Label.String = 'Preferred Direction';
cbar = colorbar('southoutside', 'Ticks', bar_ticks, 'TickLabels', bar_labels);
