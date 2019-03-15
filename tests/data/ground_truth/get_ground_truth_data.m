function boundaries = get_ground_truth_data(expId)

roi_path = strcat("/media/fran_tr/All Optical/AllOptical/Experiments/", expId, "/traces/block_roi.mat");
load(getDatasetMat(), "cellsTable")
load(roi_path, "MapId")

true_ds_indices = and([cellsTable.experiment] == expId, [cellsTable.DS] == 1);
true_ds_cells = [cellsTable(true_ds_indices).N];

% get boundaries of ground truth ds cells
boundaries = cell(1, numel(true_ds_cells));
for i = 1:numel(true_ds_cells)
    ds_cell = true_ds_cells(i);
    mask = MapId(:, :, ds_cell);
    boundaries{i} = bwboundaries(mask,'noholes');
end