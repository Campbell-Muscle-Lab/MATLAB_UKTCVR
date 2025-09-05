function linear_mixed_model_two_way

% Create data
n_f1 = 3;
n_f2 = 2;
n = 10;
noise = 1;
for i = 1 : n_f1
    for j = 1 : n_f2
        vi = (i-1)*(n_f2*n) + (j-1)*n + (1:n);
        y(vi) = i * j;
        f1(vi) = repmat(sprintf("%i", i), [1, n]);
        f2(vi) = repmat(sprintf("%c", j+64), [1, n]);
    end
end
% Add some jitter, resetting randumber generator for consistency
rng(1)
y = y + noise * (rand(size(y)) - 0.5);

% Form the table
t = table(y', f1', f2', VariableNames = ["y", "Block", "City"])

% Run the stats test
stats = linear_mixed_model(t, "y", "Block", ...
    f2_label = "City", ...
    figure_handle = 1)

% Expand the output
me = stats.main_effects
pc = stats.post_hoc
ms = stats.model_string
mes = stats.main_effects_string

% Save the figure
exportgraphics(gcf, 'two_way.png')