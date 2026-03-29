---
layout: default
title: figure_multi_x
has_children: false
parent: Figures
grand_parent: Code
nav_order: 15
---

# figure_multi_x.m

## Overview

Function creates a figure that shows one or more columns of a table plotted against another column

## Examples

+ [figure_multi_x](../../../demos/figures/fig_multi_x/fig_multi_x.html)

## Function arguments

```matlab
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
```

## Details

### Inputs

| Parameter | Values | Needed | Description |
| --- | --- | --- | --- |
| data_file_strings | string | Required | Full path to the data file |
| template_file_string | string | Required | Full path to the template file |
| data_file_filters | char | Optional | Data type specific thresholds |
| max_points_per_trace | double | Optional | The maximum number of data points for plots |
| envelope_no_of_bins | double | Optional | The number of bins to generate the envelope |
| envelope_face_alpha | double | Optional | Face transparency of the envelope |
| envelope_edge_alpha | double | Optional | Edge transparency of the envelope |
| output_file_string | string | Optional | File name of the output figure |
| output_file_types | string | Optional | Export type |
| output_dpi | double | Optional | Output resolution |
| figure_number | double | Optional | Figure number |
| figure_title | double | Optional | Title |
| trace_color_map | double | Optional | Trace colormap |
| trace_line_width | double | Optional | Trace width |
| trace_line_style | char | Optional | Trace style |
| legend_font_size | double | Optional | Legend font size |
| legend_icon_col_width | double | Optional | Size of the legend icons |
| legend_alignment | double | Optional | Legend alignment  |
| legend_position | double | Optional | Legend position with respect to subplot |
| annotation_font_size | double | Optional | Label font size |
| annotation_font_color | double | Optional | Label color |
| box_line_width | double | Optional | Area plot line width  |
| box_edge_color | double | Optional | Area plot edge color |
| box_fill_color | double | Optional | Area plot infill color |
| box_fill_alpha | double | Optional | Area plot face transparency |
| vline_style | char | Optional | Vertical line style |
| vline_width | double | Optional | Vertical line width |
| vline_color | double | Optional | Vertical line color |

