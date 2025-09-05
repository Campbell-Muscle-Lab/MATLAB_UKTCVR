function linear_mixed_model_one_way

% Create data
n_f1 = 3;
n = 4;
noise = 0.3;
for i = 1 : n_f1
    vi = (i-1)*n+(1:n);
    y(vi) = i;
    f1(vi) = repmat(sprintf("%.i", i), [1, n]);
end
% Add some jitter, resetting randumber generator for consistency
rng(1)
y = y + noise * (rand(size(y)) - 0.5);

% Form the table
t = table(y', f1', VariableNames = ["y", "Block"]);

% Run the stats test
stats = linear_mixed_model(t, "y", "Block", figure_handle = 1)

% Expand the output
me = stats.main_effects
pc = stats.post_hoc
ms = stats.model_string
mes = stats.main_effects_string

% Save the figure
exportgraphics(gcf, 'one_way.png')