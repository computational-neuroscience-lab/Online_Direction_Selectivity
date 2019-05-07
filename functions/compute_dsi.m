function [dsi, ds_angle, ds_modules] = compute_dsi(directions, bar_responses)
% Compute direction selectivity of calcium traces
% (see "The functional diversity of retinal ganglion cells in the mouse"
% paper from Baden et al. - 2016).

[n_cells, ~, n_directions] = size(bar_responses);

dsi = zeros(n_cells, 1);
ds_angle = zeros(n_cells, 1);
d_vectors = zeros(n_cells, n_directions);

ds_modules = zeros(n_cells, n_directions);
for iCell = 1:n_cells
    cellBarResponses = squeeze(bar_responses(iCell, :, :));
    [~, ~, dirComponents] = svd(cellBarResponses);
    ds_modules(iCell, :) = dirComponents(:,1)';
    
    % Solve the sign ambiguity of SVD
    activityByDirection = std(cellBarResponses);
    [~, maxActivityDirection] = max(activityByDirection);
    if ds_modules(iCell, maxActivityDirection) < 0
        ds_modules(iCell, :) = ds_modules(iCell, :) * -1;
    end
    
    d_vectors(iCell, :) = ds_modules(iCell, :) .* exp(directions * 1i);
    dsi(iCell) = abs(sum(d_vectors(iCell, :)));
    ds_angle(iCell) = angle(sum(d_vectors(iCell, :)));
end
