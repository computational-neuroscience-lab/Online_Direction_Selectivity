function [dsK, dsAngle, directionModules] = compute_dsi(directions, avgBarResponses)

[nCells, ~, nDirections] = size(avgBarResponses);

dsK = zeros(nCells, 1);
dsAngle = zeros(nCells, 1);
dirVectors = zeros(nCells, nDirections);

directionModules = zeros(nCells, nDirections);
for iCell = 1:nCells
    cellBarResponses = squeeze(avgBarResponses(iCell, :, :));
    [~, ~, dirComponents] = svd(cellBarResponses);
    directionModules(iCell, :) = dirComponents(:,1)';
    
    % Solve the sign ambiguity of SVD
    activityByDirection = std(cellBarResponses);
    [~, maxActivityDirection] = max(activityByDirection);
    if directionModules(iCell, maxActivityDirection) < 0
        directionModules(iCell, :) = directionModules(iCell, :) * -1;
    end
    
    dirVectors(iCell, :) = directionModules(iCell, :) .* exp(directions * 1i);
    dsK(iCell) = abs(sum(dirVectors(iCell, :)));
    dsAngle(iCell) = angle(sum(dirVectors(iCell, :)));
end
