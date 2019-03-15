function [angles, angles_sequence, bar_duration, baseline_duration] = get_bars_infos(bars_file, bars_rate)

bars_mat = load(bars_file);
bars_vec = bars_mat(2:end, 5);
bars_changes = find(diff([0; bars_vec; 0]));
baseline_duration = (bars_changes(1) -1) / bars_rate;

intervals = diff(bars_changes);
if range(intervals) > 0
    error(strcat("ERROR IN ", bars_vec_path, ": bars repetition do not have the same length!"))
end
bar_duration = intervals(1) / bars_rate;

angles = (0:7) * (pi / 4);
angles_vec = mod(bars_vec, 10);
angles_sequence = angles_vec(bars_changes(1:end-1));