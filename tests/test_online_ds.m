close all
clear

% params
IMG_RATE = 7.82;  % Hz
BARS_RATE = 50;  % Hz
SNR_THRESHOLD = 0.7;

% Available Examples
exp_ids = ["180326", "180327", "180328", "180329", "180330", "180406", "180410a", "180410b", "180410c", "180411"];

for exp_id = exp_ids

    % Files
    bars_vec = "tests/data/stim/bars.vec";
    tiff_file = strcat("tests/data/tiffs/bars_", exp_id, ".tif");
    ground_truth_mat = strcat("tests/data/ground_truth/", exp_id, "_boundaries.mat");

    % Plot Direction Selectivity
    tic
    plot_pixelwise_ds(tiff_file, IMG_RATE, bars_vec, BARS_RATE, SNR_THRESHOLD);
    fprintf("online DS analysis performed in %f seconds\n", toc);
    
    % Load ground truth data
    load(ground_truth_mat, "boundaries");

    % Plot & compare
    hold on
    for b = boundaries
        visboundaries(b{:}, 'Color', 'yellow');
    end
    
    waitforbuttonpress()
    close();
end
