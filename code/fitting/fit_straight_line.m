function out = fit_straight_line(x,y, options);

% Defaults
arguments
    x (:,:) double = []
    y (:,:) double = [];

    options.omit_NaNs (1,:) logical = true
    options.no_of_fit_points (1,1) double = 100

    options.confidence_level (1,1) double = 0.95

    options.color_map (:, 3) double = []
    options.marker_color_index (1,1) = 1
    options.marker_size (1,1) double = 40;
    options.marker_face_alpha (1,1) double = 0.1
    options.marker_symbol (1,1) string = "o"
    options.marker_edge_alpha = 0.5
    options.marker_edge_width = 0.5
    options.marker_edge_brightening = -0.5

    options.fit_line_color_index (1,1) double = 2;
    options.fit_line_width (1,1) double = 1
    options.fit_line_style (1,1) string = ""

    options.confidence_line_color_index (1,1) double = 3;
    options.confidence_line_width (1,1) double = 1
    options.confidence_line_style (1,1) string = "--"

    options.regression_line_color_index (1,1) double = 4;
    options.regression_line_width (1,1) double = 1
    options.regression_line_style (1,1) string = "--"


    options.title_string (1,:) string = ""
    options.title_font_size (1,1) double = 10
    options.title_rel_y_pos (1,1) double = 1.2;

    options.figure_handle (1,1) double = 0
    options.subplot_handle (1,:) double = []
end

% Some error checking and flipping
for i=1:2
    if (i==1)
        temp=x;
    else
        temp=y;
    end
    [r,c]=size(temp);
    if (c>r)
        temp=temp';
    end
    if (i==1)
        x=temp;
    else
        y=temp;
    end
end

if (options.omit_NaNs)
    bi = find(isnan(x)|isnan(y));
    x(bi)=[];
    y(bi)=[];
end

% Set defaults
if (isempty(options.color_map))
    options.color_map = return_matplotlib_default_colors();
end

% Code
[b,bint,r,rint,stats]=regress(y,[ones(size(x)) x], ...
    (1-options.confidence_level));

% Calculate stuff about the fit
x_fit = linspace(min(x), max(x), options.no_of_fit_points);
y_fit = b(2) * x_fit' + b(1);
r_matrix = corrcoef(x',y');

% Now get the error on the regression line
% http://mathworks.com/matlabcentral/newsreader/view_thread/309337
if (numel(x)>2)
    [p,s]=polyfit(x,y,1);
    [~,dy]=polyconf(p,x_fit,s, ...
        'predopt','curve', ...
        'alpha',1-options.confidence_level);
    y_regression(:,1) = y_fit+dy';
    y_regression(:,2) = y_fit-dy';

    % And errors on where the points lie
    [~,dy]=polyconf(p, x_fit, s, ...
        'predopt','observation', ...
        'alpha',1-options.confidence_level);
    y_confidence(:,1) = y_fit+dy';
    y_confidence(:,2) = y_fit-dy';
else
    y_regression(:,1) = NaN*ones(size(x));
    y_regression(:,2) = NaN*ones(size(x));
    y_confidence(:,1) = NaN*ones(size(x));
    y_confidence(:,2) = NaN*ones(size(x));
end

% Store data
out.x=x;
out.y=y;
out.slope=b(2);
out.slope_confidence_limits=bint(2,:);
out.intercept=b(1);
out.intercept_confidence_limits=bint(1,:);
out.x_fit=x_fit;
out.y_fit=y_fit;
out.y_confidence=y_confidence;
out.y_regression=y_regression;
out.p=stats(3);
out.r=r_matrix(1,2);
out.title_string=sprintf( ...
        'y = %.5g*x + %.5g\nr=%.5g\np=%.5g', ...
        out.slope,out.intercept,out.r,out.p);


% Display if required
if ((options.figure_handle>0) || (~isempty(options.subplot_handle)))

    if (options.figure_handle > 0)
        figure(options.figure_handle);
        clf
    else
        subplot(options.subplot_handle);
    end
    hold on;

    marker_face_color = options.color_map(options.marker_color_index, :);
    marker_edge_color = brighten(marker_face_color, options.marker_edge_brightening);

    scatter(x, y, ...
        options.marker_size, ...
        'filled', ...
        Marker = options.marker_symbol, ...
        MarkerFaceColor = marker_face_color, ...
        MarkerFaceAlpha = options.marker_face_alpha, ...
        MarkerEdgeColor = marker_edge_color, ...
        MarkerEdgeAlpha = options.marker_edge_alpha, ...
        LineWidth = options.marker_edge_width);
    
    plot(x_fit, y_fit, ...
        options.fit_line_style, ...
        LineWidth = options.fit_line_width, ...
        Color = options.color_map(options.fit_line_color_index, :));

    for i=1:2
        plot(x_fit, y_confidence(:,i), ...
            options.confidence_line_style, ...
            LineWidth = options.confidence_line_width, ...
            Color = options.color_map(options.confidence_line_color_index, :));

        plot(x_fit, y_regression(:,i), ...
            options.regression_line_style, ...
            LineWidth = options.regression_line_width, ...
            Color = options.color_map(options.regression_line_color_index, :));
    end

    % Display
    x_limits=xlim;
    y_limits=ylim;
    if (options.title_font_size>0)
        text(mean(x_limits), ...
            y_limits(1) + options.title_rel_y_pos * diff(y_limits), ...
            out.title_string, ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','top', ...
            'FontSize',options.title_font_size);
    end
end
