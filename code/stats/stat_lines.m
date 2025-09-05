function stat_lines(post_hoc_table, axes_data, options)

arguments
    post_hoc_table (:,:) table
    axes_data (1,1) struct

    options.rel_y_length (1,1) double = 0.04
    options.rel_y_spacing (1,1) double = 0.15
    options.line_width (1,1) double = 1
    options.line_style (1,1) string = "-"
    options.line_color (1,3) double = [0 0 0]
    options.font_size (1,1) double = 10
    options.label_rel_y_offset (1,1) double = 0.02
end

if (isempty(post_hoc_table))
    return
end

% Code

pht = post_hoc_table

axes_height = abs(axes_data.y_ticks(end) - axes_data.y_ticks(1));
y_spacing = options.rel_y_spacing * axes_height;
y_height = options.rel_y_length * axes_height;
y_anchor = axes_data.y_ticks(end) + y_spacing;

for i = 1 : size(post_hoc_table, 1)

    if (post_hoc_table.p_corrected(i) > 0.05)
        break
    end

    % We have a statistical goal-post to draw
    x1 = post_hoc_table.x1(i);
    x2 = post_hoc_table.x2(i);

    y1 = y_anchor;
    y2 = y_anchor + y_height;

    x = [x1 x1 x2 x2]
    y = [y1 y2 y2 y1]

    plot(x, y, options.line_style, ...
        Color = options.line_color, ...
        LineWidth = options.line_width, ...
        Clipping = 'off');

    % Now label it
    text(mean(x), y2 + 0.1 * y_spacing, ...
            format_p_string(post_hoc_table.p_corrected(i)), ...
        HorizontalAlignment = 'center', ...
        VerticalAlignment = 'bottom', ...
        FontSize = options.font_size);

    % And move for the next
    y_anchor = y_anchor + y_spacing;
end
% 
% 
% no_of_lines=numel(line_data);
% 
% % Loop
% y_axis_length = diff(ylim);
% 
% for line_counter=1:no_of_lines
%     x=[line_data(line_counter).data{1} line_data(line_counter).data{1} ...
%         line_data(line_counter).data{2} line_data(line_counter).data{2}];
%     y=line_data(line_counter).data{4} + ...
%         params.rel_y_length*y_axis_length*[-1 0 0 -1];
% 
%     plot(x,y, ...
%         'LineStyle',params.line_style, ...
%         'Color',params.line_color, ...
%         'LineWidth',params.line_width, ...
%         'Clipping','off');
% 
%     text(mean(x)+line_data(line_counter).data{5},...
%         max(y)+params.label_y_offset*y_axis_length, ...
%         line_data(line_counter).data{3}, ...
%         'VerticalAlignment','bottom', ...
%         'HorizontalAlignment','center', ...
%         'FontSize',params.font_size);
% end
% 
% 
% 
