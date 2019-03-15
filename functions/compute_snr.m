function snr = compute_snr(traces)
% Compute signal-to-noise ratio for calcium traces
% (see "The functional diversity of retinal ganglion cells in the mouse"
% paper from Baden et al. - 2016).

% traces: 2d [n_Cells * n_repetitions * n_time_steps] matrix
r_dim = 2;
t_dim = 3;

num_ =  std(mean(traces, r_dim), 0, t_dim);
den_ =  mean(std(traces, 0, t_dim), r_dim);

snr = num_ ./ den_;
