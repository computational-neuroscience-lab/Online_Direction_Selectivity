close all
clear

% experimental parameters
img_rate = 7.82;	% Hz
bars_rate = 50;     % Hz

% analysis parameters
blur_factor = 0.8;
snr_threshold = 0.7;
ds_threshold = 0.5;

% Available Examples
examples = ["180326", "180327", "180328", "180329", "180330", "180406", "180410a", "180410b", "180410c", "180411"];

for example = examples
    
    % Files
    bars_vec = "tests/data/stim/bars.vec";
    tiff_file = strcat("tests/data/tiffs/bars_", example, ".tif");

    % Plot Direction Selectivity
    tic
    plot_pixelwise_ds(tiff_file, img_rate, bars_vec, bars_rate, blur_factor, ds_threshold, snr_threshold);
    fprintf("online DS analysis performed in %f seconds\n", toc);

    % Plot & compare with ground truth
    ground_truth_mat = strcat("tests/data/ground_truth/", example, "_boundaries.mat");
    load(ground_truth_mat, "boundaries");
    hold on
    for b = boundaries
        visboundaries(b{:}, 'Color', "red");
    end
    
    waitforbuttonpress()
    close();
end
