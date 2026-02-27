function legend_uktcvr(h_plot, h_label, options)
% Adds a legend with some options

arguments
    h_plot
    h_label

    options.FontSize = 12
    options.IconColumnWidth = 30
    options.legend_alignment = "top_left"
    options.legend_position = []

end

h_leg = legend(h_plot, h_label, ...
            FontSize = options.FontSize, ...
            IconColumnWidth = options.IconColumnWidth, ...
            Location = 'northeast');


if (~isempty(options.legend_position))
    % Need to move the legend

    subplot_position = get(gca, 'Position');
    legend_position = h_leg.Position;

    switch options.legend_alignment
        case "top_left"

            left = subplot_position(1) + ...
                options.legend_position(1) * subplot_position(3);
            bot = sum(subplot_position([2 4])) - ...
                    legend_position(4);
            width = legend_position(3);
            height = legend_position(4);

    end

    h_leg.Position = [left bot width height]
end
