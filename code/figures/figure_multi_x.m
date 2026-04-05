function figure_multi_x(data_file_strings, template_file_string, options)
% Creates a figure from a json layout %

    arguments
        data_file_strings (:,:) = strings(0)
        template_file_string (1,1) = ""

        options.data_file_filters = [];

        options.max_points_per_trace (1,1) = 5000

        options.envelope_no_of_bins (1,1) = 25
        options.envelope_face_alpha = 0.25
        options.envelope_edge_alpha = 0.75

        options.output_file_string = ""
        options.output_file_types = ["png", "eps", "svg"]
        options.output_dpi = 1200

        options.figure_number (1,1) = 1
        options.figure_title (1,1) = ""

        options.trace_color_map (:,3) = return_matplotlib_default_colors()
        options.trace_line_width (1,1) = 1
        options.trace_line_style (1,1) = '-'

        options.legend_font_size (1,1) = 9
        options.legend_icon_col_width (1,1) = 7
        options.legend_alignment (1,1) = "top_left"
        options.legend_position (1,2) = [1 1]

        options.annotation_font_size (1,1) = 9;
        options.annotation_font_color (1,3) = [0 0 0];
        
        options.box_line_width (1,1) = 1
        options.box_edge_color (1,:) = [0 0 0]
        options.box_fill_color (1,:) = [1 0 1]
        options.box_fill_alpha (1,1) = 0.5
        
        options.vline_style (1,1) = "--"
        options.vline_width (1,1) = 1
        options.vline_color (1,3) = 0.5 * ones(1,3)
    end

    % Load the JSON layout
    template = readstruct(template_file_string);

    % Deduce subplots
    col_i = [];
    for i = 1 : numel(template.panels)
        col_i(i) = template.panels(i).column;
    end
    col_stats = summary_stats(col_i);
    no_of_cols = col_stats.max;
    no_of_rows = sum(col_i == col_stats.mode);

    % Deduce pads
    if (numel(template.layout.padding_top) == 2)
        padding_top = [template.layout.padding_top(1), ...
            template.layout.padding_top(2) * ones(1, no_of_rows-1)];
    else
        padding_top = template.layout.padding_top;
    end
    if (numel(template.layout.padding_bottom) == 2)
        padding_bottom = [ ...
            template.layout.padding_bottom(1) * ones(1, no_of_rows-1) ...
            template.layout.padding_bottom(2)];
    else
        padding_bottom = template.layout_padding_bottom;
    end

    % Now make the figure
    figure(options.figure_number);
    clf;
    [subplots, fig_options] = layout_subplots( ...
        figure_handle = options.figure_number, ...
        figure_width = template.layout.fig_width, ...
        panels_wide = no_of_cols, ...
        panels_high = no_of_rows, ...
        padding_left = template.layout.padding_left, ...
        padding_right = template.layout.padding_right, ...
        padding_top = padding_top, ...
        padding_bottom = padding_bottom, ...
        x_to_y_ratio = template.layout.x_to_y_ratio, ...
        panel_label = false);

    % Since there is the potential to loop through multiple files
    % we need a bit of preparation to track which subplot to use for each
    % panel
    rows_plotted = zeros(1, no_of_cols);
    subplot_for_panel = zeros(1, numel(template.panels));

    % And we also need some stuff to keep track of legends
    h_leg = [];

    % Now loop through the data files
    for file_i = 1 : numel(data_file_strings)
    
        % Now load data
        d = readtable(data_file_strings(file_i));
        dn = d.Properties.VariableNames'

        if (~isempty(options.data_file_filters))
            for filter_i = 1 : numel(options.data_file_filters)
                d = apply_data_file_filters(d, options.data_file_filters);
            end
        end

        % Pull off the x data
        x_all = d.(template.x_display.global_x_field);

        if (~isfield(template.x_display, 'ticks'))
            line_ti = 1 : numel(x_all);
            template.x_display.ticks = [x_all(1) x_all(end)];
        else
            line_ti = find( (x_all >= template.x_display.ticks(1)) & ...
                            (x_all <= template.x_display.ticks(end)) );
        end

        % Downsample if necessary
        if (numel(line_ti) > options.max_points_per_trace)
            skip = 1;
            first_ti = line_ti(1);
            last_ti = line_ti(end);
            while (numel(line_ti) > options.max_points_per_trace)
                skip = skip + 1;
                line_ti = first_ti : skip : last_ti;
            end
        end
    
        % Loop through each panel in the template to create subplots
        for panel_i = 1:numel(template.panels)
    
            % Work out which panel to plot to
            if (file_i == 1)
                ci = col_i(panel_i);
                ri = rows_plotted(ci) + 1;
                rows_plotted(ci) = ri;
                plot_index = ci + (ri - 1) * no_of_cols;
                subplot_for_panel(panel_i) = plot_index;
            else
                plot_index = subplot_for_panel(panel_i);
            end
    
            % Switch to the subplot
            subplot(subplots(plot_index));
    
            % Pull off the series information
            series_data = template.panels(panel_i).y_info.series;
    
            % Prepare for a new plot
    
            % Loop though the series
            for series_i = 1 : numel(series_data)

                % Pull off the data
                if ~( (isfield(series_data(series_i), 'reference')) && ...
                        (~ismissing(series_data(series_i).reference)) )
                    y = d.(series_data(series_i).field);
                end
    
                % Check for a scaling factor
                if (isfield(series_data(series_i), 'scaling_factor') && ...
                        ~ismissing(series_data(series_i).scaling_factor))
                    y = series_data(series_i).scaling_factor * y;
                end

                % Check for processing
                if (isfield(series_data(series_i), 'processing'))
                    if (~ismissing(series_data(series_i).processing))
                        switch (series_data(series_i).processing)
                            case 'sgolay'
                                y = smoothdata(y, 'sgolay');
                        end
                    end
                end
    
                formatting = return_formatting( ...
                    series_data, series_i, ...
                    template.formatting, ...
                    options);
    
                switch (formatting.style)
                    case 'reference'
                        % Reference value
                        x_ref = x_all(line_ti([1 end]));
                        y_ref = series_data(series_i).reference * [1 1];

                        h_leg(panel_i).trace(file_i, series_i) = ...
                                plot(x_ref, y_ref, ...
                                    'LineStyle', formatting.trace_line_style, ...
                                    'LineWidth', formatting.trace_line_width, ...
                                    'Color', formatting.color);
    
                    case 'line'
                        h_leg(panel_i).trace(file_i, series_i) = ...
                            plot(x_all(line_ti), y(line_ti), ...
                                'LineStyle', formatting.trace_line_style, ...
                                'LineWidth', formatting.trace_line_width, ...
                                'Color', formatting.color);

                    case 'envelope'
                        [x_env, y_env] = return_envelope( ...
                            x_all(line_ti), y(line_ti), options);

                        h_leg(panel_i).trace(file_i, series_i) = ...
                            patch(x_env, y_env, formatting.color, ...
                                    FaceAlpha = options.envelope_face_alpha, ...
                                    EdgeAlpha = options.envelope_edge_alpha, ...
                                    EdgeColor = formatting.color);


                
                end
    
                % Keep track of the labels
                if ( (isfield(series_data(series_i), 'field_label')) && ...
                        (~ismissing(series_data(series_i).field_label)) )
                    h_leg(panel_i).label(file_i, series_i) = ...
                        series_data(series_i).field_label;
                end
            end
        end
    end

    % We have now plotted everything so we can cycle back and
    % format the axes
    for panel_i = 1:numel(template.panels)

        % Switch to the right subplot
        plot_index = subplot_for_panel(panel_i);
        subplot(subplots(plot_index));

        % Check whether it is the bottom panel in column and use that
        % to determine whether to draw the x axis
        ci = col_i(panel_i);
        if (isapprox(rem(plot_index, no_of_cols), 0))
            ri = round(plot_index / no_of_cols);
        else
            ri = floor(plot_index / no_of_cols) + 1;
        end
        if (ri == sum(col_i == ci))
            % Bottom
            x_axis_off = 0;
        else
            x_axis_off = 1;
        end

        if (isfield(template.x_display, 'decimal_places'))
            x_decimal_places = template.x_display.decimal_places;
        else
            x_decimal_places = 0;
        end

        % Check whether we have specific y_label requirements
        if (isfield(template.panels(panel_i).y_info, 'ticks'))
            y_ticks = template.panels(panel_i).y_info.ticks;
        else
            if (isfield(template.panels(panel_i).y_info, 'scaling_type'))
                scaling_type = template.panels(panel_i).y_info.scaling_type;
            else
                scaling_type = "include_zero";
            end

            switch scaling_type
                case "include_zero"
                    y_lim = ylim;
                    y_ticks = [min([y_lim(1) 0]) max([y_lim(2) 0])];
                otherwise
                    y_ticks = ylim;
            end

            % Round
            y_range = diff(y_ticks);
            decade = round_to_largest_decade(y_range);
            y_ticks = [multiple_less_than(y_ticks(1), 0.02 * decade) ...
                multiple_greater_than(y_ticks(end), 0.02 * decade)];
        end

        if (isfield(template.panels(panel_i).y_info, 'decimal_places'))
            y_decimal_places = template.panels(panel_i).y_info.decimal_places;
        else
            % Try to make a good guess
            y_abs = max(abs(y_ticks));
            p10 = floor(log10(y_abs));
            if (p10 >= 1)
                y_decimal_places = 0;
            elseif ( (p10 >= 0) && (p10 < 1) )
                y_decimal_places = 1;
            else
                y_decimal_places = abs(p10);
            end
        end

        formatting = return_formatting(series_data, series_i, ...
            template.formatting, options);

        ax_data(plot_index) = improve_axes( ...
            'x_axis_offset', formatting.x_axis_offset, ...
            'x_ticks', template.x_display.ticks, ...
            'x_tick_decimal_places', x_decimal_places, ...
            'x_axis_label', template.x_display.label, ...
            'x_label_offset', formatting.x_label_offset, ...
            'x_tick_length', formatting.x_tick_length, ...
            'x_tick_label_vertical_offset', formatting.x_tick_label_vertical_offset, ...
            'x_axis_off', x_axis_off, ...
            'y_axis_offset', formatting.y_axis_offset, ...
            'y_axis_label', template.panels(panel_i).y_info.label, ...
            'y_label_offset', formatting.y_label_offset, ...
            'y_ticks', y_ticks, ...
            'y_tick_length', formatting.y_tick_length, ...
            'y_tick_label_horizontal_offset', formatting.y_tick_label_horizontal_offset, ...
            'y_tick_decimal_places', y_decimal_places, ...
            'label_font_size', formatting.label_font_size, ...
            'tick_font_size', formatting.tick_font_size);

        % Pull off the legend
        if (isfield(h_leg(panel_i), 'label'))
            labels = h_leg(panel_i).label;
            vi = find(~ismissing(labels));
            if (~isempty(vi))
                legend_uktcvr( ...
                    h_leg(panel_i).trace(vi), labels(vi), ...
                    FontSize = formatting.legend_font_size, ...
                    IconColumnWidth = formatting.legend_icon_col_width, ...
                    legend_position = formatting.legend_position);
            end
        end
    end

    % Delete the panels that were not used
    empty_panels = setdiff( (1 : (no_of_rows* no_of_cols)), ...
        subplot_for_panel);

    for panel_i = 1 : numel(empty_panels)
        sp = subplot(subplots(empty_panels(panel_i)));
        sp.Visible = 'off';
    end

    % Add a title
    if (~isempty(options.figure_title))
        sgtitle(options.figure_title, 'Interpreter', 'none');
    end

    % Add annotations
    handle_annotations(template, subplots, ax_data, ...
        subplot_for_panel, options);

    % Finally, export the figures if required
    if (options.output_file_string ~= "")

        for type_i = 1 : numel(options.output_file_types)
            output_file_string = sprintf('%s.%s', ...
                options.output_file_string, ...
                options.output_file_types(type_i));

            disp(sprintf("Saving figure to %s", output_file_string))

            exportgraphics(fig_options.figure_handle, output_file_string, ...
                ContentType = 'vector', ...
                Resolution = options.output_dpi);
        end
    end
end

% Helper functions
function formatting = return_formatting(series_data, series_i, ...
        template_formatting, options)
    % Returns formatting, where series takes priority over template formatting
    % If both are unspecified, use the local MATLAB options

    % Get the field_names for the series
    s_data = series_data(series_i);
    s_fields = fieldnames(s_data);
    
    % And the template formatting
    t_data = template_formatting;
    t_fields = fieldnames(template_formatting);
     
    % Now set the formatting
    style_fields = { ...}
        'style', 'color', 'label_font_size', 'tick_font_size',...
        'x_axis_offset', ...
        'x_label_offset', 'x_tick_length', 'x_tick_label_vertical_offset', ...
        'y_axis_offset', ...
        'y_label_offset', 'y_tick_length', 'y_tick_label_horizontal_offset', ...
        'trace_line_style', 'trace_line_width', ...
        'legend_font_size', 'legend_icon_col_width', ...
        'legend_alignment', 'legend_position'};
    for i = 1 : numel(style_fields)
        formatting.(style_fields{i}) = return_field_value(style_fields{i});
    end
    
        % Nested function
        function val = return_field_value(test_field)
            if ( (any(strcmp(s_fields, test_field))) && ...
                    (~isempty(s_data.(test_field))) )
                val = s_data.(test_field);
            elseif (any(strcmp(t_fields, test_field)))
                val = t_data.(test_field);
            elseif (any(strcmp(fieldnames(options), test_field)))
                val = options.(test_field);
            else
                val = [];
            end

            % Some special cases
            if ( all(isempty(val)) || all(ismissing(val)) )
                switch(test_field)
                    case 'color'
                        val = options.trace_color_map(series_i, :);
                    case 'style'
                        val = 'line';
                end
            end

            if ( isfield(s_data, 'reference') && ...
                    ~ismissing(s_data.reference) && ...
                    strcmp(test_field, 'style'))
                val = 'reference';
            end
        end
end

function [x_env, y_env] = return_envelope(x_all, y_all, options)
% Returns x and y coordinates for a patch

% Work out the x limits
x_min = min(x_all);
x_max = max(x_all);

x_bins = NaN * ones(options.envelope_no_of_bins, 1);
y_top = NaN * ones(options.envelope_no_of_bins, 1);
y_bottom = NaN * ones(options.envelope_no_of_bins, 1);

x_edges = linspace(x_min, x_max, (options.envelope_no_of_bins+1));
for bin_i = 1 : numel(x_bins)
    vi = find( (x_all >= x_edges(bin_i)) & (x_all <= x_edges(bin_i+1)) );
    if (~isempty(vi))
        x_bins(bin_i) = median(x_all(vi));
        y_top(bin_i) = max(y_all(vi));
        y_bottom(bin_i) = min(y_all(vi));
    else
        if (bin_i > 1)
            x_bins(bin_i) = x_bins(bin_i-1);
            y_top(bin_i) = y_top(bin_i-1);
            y_bottom(bin_i) = y_bottom(bin_i-1);
        else
            x_bins(bin_i) = x_all(1);
            y_top(bin_i) = y_all(1);
            y_bottom(bin_i) = y_all(1);
        end
    end
end

% Rearrange
x_env = [x_bins' x_bins(end:-1:1)'];
y_env = [y_top' y_bottom(end:-1:1)'];

end

function d = apply_data_file_filters(d, data_filter);
% Applies filters

    switch data_filter.type
        case 'isfinite'
            vi = find(isfinite(d.(data_filter.column)));
        case 'equals'
            vi = find(d.(data_filter.column) == data_filter.value);
        case 'greater_than'
            vi = find(d.(data_filter.column) >= data_filter.value);
        case 'less_than'
            vi = find(d.(data_filter.column) <= data_filter.value);
    end

    d = d(vi,:);
end

function handle_annotations(template, subplots, ax_data, ...
        subplot_for_panel, options)
% Adds annotations to figure

    arguments
        template
        subplots
        ax_data
        subplot_for_panel
        options
    end

    if (~isfield(template, 'annotations'))
        % Nothing to do
        return
    end
    
    % Loop through the annotations
    for an_i = 1 : numel(template.annotations)

        an = template.annotations(an_i);
    
        % Work out which panels to annotate
        panel_list = [];
        if ( (isstring(an.panel)) && (an.panel == "all") )
            panel_list = 1 : numel(subplots);
        else
            panel_list = an.panel;
        end
    
        for pan_i = 1 : numel(panel_list)

            % Switch to the subplot
            plot_index = subplot_for_panel(panel_list(pan_i));
            subplot(subplots(plot_index));
    
            switch an.type
                case "box"
                    xc = an.x_coords;
                    x = [xc(1) * [1 1], xc(end) * [1 1] xc(1)];
                    y_lim = ax_data(plot_index).y_ticks;
                    yc = an.y_rel_coords;
                    y = y_lim(1) + (diff(y_lim) * ...
                        [yc(1) yc(end) * [1 1] yc(1) * [1 1]]);
                    p = patch(x, y, options.box_fill_color, ...
                        EdgeColor = options.box_edge_color, ...
                        LineWidth = options.box_line_width, ...
                        FaceAlpha = options.box_fill_alpha, ...
                        Clipping = "off");
                    % Exclude from legend
                    p.Annotation.LegendInformation.IconDisplayStyle = 'off';

                    if (isfield(an, 'label'))
                        text(mean(xc), mean(y([1:2])), ...
                            an.label, ...
                            FontSize = options.annotation_font_size, ...
                            Color = options.annotation_font_color, ...
                            HorizontalAlignment = 'center', ...
                            VerticalAlignment = 'middle', ...
                            Clipping = 'off')
                    end

                case "vline"
                    x = an.x_coord
                    y = ax_data(plot_index).y_ticks;
                    p = plot(x * [1 1], y, ...
                        Color = options.vline_color, ...
                        LineStyle = options.vline_style, ...
                        LineWidth = options.vline_width);

                    % Exclude from legend
                    p.Annotation.LegendInformation.IconDisplayStyle = 'off';


                    if ( isfield(an, "label") && ~ismissing(an.label) )
                        x = x(1);
                        y_lim = ylim;
                        y = y_lim(1) + diff(y_lim) * an.label_y_rel_coord;

                        text(x, y, ...
                            an.label, ...
                            FontSize = options.annotation_font_size, ...
                            Color = options.annotation_font_color, ...
                            HorizontalAlignment = 'center', ...
                            VerticalAlignment = 'middle', ...
                            Clipping = 'off')
                    end

                case "text"
                    x = an.x_coord
                    y = ax_data(plot_index).y_ticks;

                    if (isfield(an, "label"))
                        x = x(1);
                        y_lim = ylim;
                        y = y_lim(1) + diff(y_lim) * an.label_y_rel_coord;

                        text(x, y, ...
                            an.label, ...
                            FontSize = options.annotation_font_size, ...
                            Color = options.annotation_font_color, ...
                            HorizontalAlignment = 'center', ...
                            VerticalAlignment = 'middle', ...
                            Clipping = 'off')
                    end
            end
        end
    end

end
