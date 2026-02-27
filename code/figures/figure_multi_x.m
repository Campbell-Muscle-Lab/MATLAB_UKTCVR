function figure_multi_x(data_file_string, template_file_string, options)
% Creates a figure from a json layout %

    arguments
        data_file_string (1,1) = ""
        template_file_string (1,1) = ""

        options.figure_number (1,1) = 1

        options.trace_color_map (:,3) = return_matplotlib_default_colors()
        options.trace_line_width (1,1) = 1
        options.trace_line_style (1,1) = '-'

        options.legend_font_size (1,1) = 9
        options.legend_icon_col_width (1,1) = 10
        options.legend_alignment (1,1) = "top_left"
        options.legend_position (1,2) = [1 1]
    end

    % Load the JSON layout
    template = readstruct(template_file_string)

    % Deduce subplots
    col_i = [];
    for i = 1 : numel(template.panels)
        col_i(i) = template.panels(i).column;
    end
    col_stats = summary_stats(col_i);
    no_of_cols = col_stats.max
    no_of_rows = sum(col_i == col_stats.mode)

    % Deduce pads
    if (numel(template.layout.padding_top) == 2)
        padding_top = [template.layout.padding_top(1), ...
            template.layout.padding_top(2) * ones(1, no_of_rows-1)];
    else
        padding_top = template.layout_padding_top;
    end
    if (numel(template.layout.padding_bottom) == 2)
        padding_bottom = [ ...
            template.layout.padding_bottom(1) * ones(1, no_of_rows-1) ...
            template.layout.padding_bottom(2)];
    else
        padding_bottom = template.layout_padding_bottom;
    end



    % Now make the figure
    subplots = layout_subplots( ...
        figure_handle = options.figure_number, ...
        figure_width = template.layout.fig_width, ...
        panels_wide = no_of_cols, ...
        panels_high = no_of_rows, ...
        padding_left = template.layout.padding_left, ...
        padding_right = template.layout.padding_right, ...
        padding_top = padding_top, ...
        padding_bottom = padding_bottom, ...
        x_to_y_ratio = template.layout.x_to_y_ratio, ...
        panel_label = false)

    % Track how many panels have been added to each column
    rows_plotted = zeros(1, no_of_cols)

    % Now load data
    d = readtable(data_file_string);
    dn = d.Properties.VariableNames;

    % Pull off the x data
    x_all = d.(template.x_display.global_x_field);
    line_ti = find( (x_all >= template.x_display.x_ticks(1)) & ...
                        (x_all <= template.x_display.x_ticks(end)) );

    % Loop through each panel in the template to create subplots
    for panel_i = 1:numel(template.panels)

        % Work out which panel to plot to
        ci = col_i(panel_i);
        ri = rows_plotted(ci) + 1;
        rows_plotted(ci) = ri;

        plot_index = ci + (ri - 1) * no_of_cols;

        % Switch to the subplot
        subplot(subplots(plot_index));

        % Pull off the series information
        series_data = template.panels(panel_i).y_info.series;

        % Prepare for a new plot

        h_plot = [];
        h_label = strings(numel(series_data), 1);

        % Loop though the series
        for series_i = 1 : numel(series_data)

            formatting = return_formatting( ...
                series_data, series_i, ...
                template.formatting, ...
                options);

            switch (formatting.style)
                case 'reference'
                    % Reference value
                    x_ref = x_all(line_ti([1 end]));
                    y_ref = series_data(series_i).reference * [1 1];
    
                    h_plot(series_i) = plot(x_ref, y_ref, ...
                                'LineStyle', formatting.trace_line_style, ...
                                'LineWidth', formatting.trace_line_width, ...
                                'Color', formatting.color);

                case 'line'
                    h_plot(series_i) = ...
                        plot(x_all(line_ti), ...
                            d.(series_data(series_i).field)(line_ti), ...
                            'LineStyle', formatting.trace_line_style, ...
                            'LineWidth', formatting.trace_line_width, ...
                            'Color', formatting.color);
            end

            % Keep track of the labels
            if ( (isfield(series_data(series_i), 'field_label')) && ...
                    (~ismissing(series_data(series_i).field_label)) )
                h_label(series_i) = series_data(series_i).field_label;
            end
        end

        % Format the axes

        % Check whether it is the bottom panel in column
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
            y_ticks = template.panels(panel_i).ticks;
        else
            y_ticks = [];
        end
        if (isfield(template.panels(panel_i).y_info, 'decimal_places'))
            y_decimal_places = template.panels(panel_i).y_info.decimal_places;
        else
            y_decimal_places = 0;
        end

        % Check for specific y-ticks
        if (isfield(template.panels(panel_i).y_info, 'ticks'))
            y_ticks = template.panels(panel_i).y_info.ticks;
        else
            if (isfield(template.panels(panel_i).y_info, 'scaling_type'))
                scaling_type = template.panels(panel_i).y_info.scaling_type;
            else
                scaling_type = "include_zero";
            end

            ylim

            switch scaling_type
                case "include_zero"
                    y_lim = ylim;
                    if (y_lim(1) >= 0)
                        y_ticks = [0 y_lim(2)];
                    else
                        y_ticks = [ylim(1) 0];
                    end
                otherwise
                    y_ticks = ylim;
            end

            % Round
            y_range = round_to_significant_figures(diff(y_ticks), 2)
            y_ticks = [multiple_less_than(y_ticks(1), 0.1 * y_range) ...
                multiple_greater_than(y_ticks(end), 0.1 * y_range)];
        end

        y_ticks

        improve_axes( ...
            'x_ticks', template.x_display.x_ticks, ...
            'x_tick_decimal_places', x_decimal_places, ...
            'x_axis_label', template.x_display.label, ...
            'x_label_offset', template.formatting.x_label_offset, ...
            'x_axis_off', x_axis_off, ...
            'y_axis_label', template.panels(panel_i).y_info.label, ...
            'y_label_offset', template.formatting.y_label_offset, ...
            'y_ticks', y_ticks, ...
            'y_tick_decimal_places', y_decimal_places, ...
            'label_font_size', template.formatting.label_font_size, ...
            'tick_font_size', template.formatting.tick_font_size);

        % Add a legend if we have h_label strings > 0
        vi = find(strlength(h_label));
        if (~isempty(vi))
            legend_uktcvr(h_plot(vi), h_label(vi), ...
                    FontSize = formatting.legend_font_size, ...
                    IconColumnWidth = formatting.legend_icon_col_width, ...
                    legend_position = formatting.legend_position)
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
    formatting.style = return_field_value('style');
    formatting.color = return_field_value('color');
    formatting.trace_line_style = return_field_value('trace_line_style');
    formatting.trace_line_width = return_field_value('trace_line_width');
    formatting.legend_font_size = return_field_value('legend_font_size');
    formatting.legend_icon_col_width = return_field_value('legend_icon_col_width');
    formatting.legend_alginment = return_field_value('legend_alignment');
    formatting.legend_position = return_field_value('legend_position');
    
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





