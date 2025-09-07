function test

% Generate data with 2x2 design and a grouping variable
cities = ["Lexington", "Louisville"];
cuisines = ["Italian", "French", "Scottish"];
reviewers = ["Fiona", "Tucker", "Maggie", "Patterson"];

mean_scores = [1, 1.1, 1.05 ; 1.2, 1.0, 1.1];
noise = 0.2;

% Reset random generator for repeatility
rng(1);

% Loop through the table
counter = 0;
for i = 1 : numel(cities)
    for j = 1 : numel(cuisines)

        % Set a random number of scores
        n = 5 + randi(10, 1);
        vi = counter + (1:n);
        y(vi) = mean_scores(i,j) + (noise * (randn([n, 1]) - 0.5));
        city(vi) = repmat(cities(i), [n, 1]);
        cuisine(vi) = repmat(cuisines(j), [n, 1]);
        reviewer_ind = randi(numel(reviewers), [n, 1]);
        reviewer(vi) = reviewers(reviewer_ind);

        % Update counter for the next loop
        counter = counter + n;
    end
end

t = table(y', city', cuisine', reviewer', ...
        VariableNames = ["Score", "City", "Cuisine", "Reviewer"])

% Create a one-factor table
fig_jitter(t, "Score", "City", ...
    super_plot = true);