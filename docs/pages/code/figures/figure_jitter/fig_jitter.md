---
layout: default
title: fig_jitter
has_children: false
parent: Figures
grand_parent: Code
nav_order: 1
---

# fig_jitter

## Overview

This function calls calls [swarmchart](https://www.mathworks.com/help/matlab/ref/swarmchart.html) with different combinations of the input data to create pretty-looking figures for one-way and two-designs with  an optional grouping variable.

The figure can work [linear mixed model.m](../../statistics/linear_mixed_model/linear_mixed_model.html) to show the results of statistical tests.

## Examples

+ [fig_jitter](../../../demos/figures/fig_jitter/fig_jitter.html)


## Function arguments

```
function fig_jitter(t, data_label, f1_label, options)
% Make a jitter figure

    arguments
        t (:,:) table
        data_label (1,1) string
        f1_label (1,1) string

        options.f2_label (1,1) string = ""
        options.grouping_label (1,1) string = ""
        
        options.figure_handle (1,1) double = 1
        options.subplot_handle (1,1) double = 0
        
        options.f2_spacing = 1

        options.marker_size (1,:) double = 40

        options.symbols (1,:) string = ["o", "s", "v", "^", "<", ">", "p"]
        options.group_colors logical = false
        options.color_map (:,:) double = []
        options.alpha = 0.1
        options.XJitterWidth = 0.5
        options.edge_width = 0.5
        options.edge_brightening = -0.5

        options.draw_y_from_zero = false
        options.y_ticks (:,:) double = []

        options.super_plot logical = true
        options.super_plot_size_offset double = 60;
        options.super_plot_XJitterWidth = 0.2;
        options.super_plot_alpha = 0.7;

        options.join_points = false
        options.join_line_width = 1
        options.join_line_color (1,:) double = [0 0 0]

        options.f1_font_size = 12
        options.f1_label_rotation = 45
        options.f1_vertical_offset = -0.1
        
        options.f2_font_size = 12
        options.f2_label_rel_pos = -0.5
        
        options.title_string (1,1) string = ""
        options.title_font_size = 12
        options.title_rel_y_pos (1,1) double = 1.7
        options.title_text_interpreter (1,1) = "tex"

        options.post_hoc_table (:,:) table = []
        options.post_hoc_font_size (1,1) double = 10
        options.post_hoc_rel_y_spacing (1,1) double = 0.15
    end

    end
```

## Details

### Inputs

| Parameter | Values | Needed | Description |
| --- | --- | --- | --- |
| t | table | Required | Data in tidyverse format |
| data_label | string | Required | Table variable for test data |
| f1_label | string | Required | Table variable for factor 1 |
| f2_label | string | Optional | Table variable for factor 2 |
| grouping_label | string | Optional | Table variable for grouping parameter |
| figure_handle | double | Optional | Figure handle, if provided code will create a new figure with this handle showing data as a simple swarmchart|
| subplot_handle | double | Optional | Subplot handle, if provided code will add a simple swarmchart to the subplot |
| f2_spacing | double | Optional | Spacing between f2 categories |
| marker_size | double | Optional | Size in points of f1 data |
| symvbols | string | Optional | Marker symbols for different groups |
| group_colors | logical | Optional | If true, plot groups within an f1 category in different colors |
| color_map | double | Optional | Colors for different f1 categroies or groups |
| alpha | double | Optional | Face-marker alpha (transparency) for f1 data |
| XJitterWidth | double | Optional | scatter width for f1 data |
| edge_width | double | Optional | width in points of f1 edges |
| edge_brightening | double | Optional | factor adjusting the edge of f1 markers, negative values darken the edge |
| draw_y_from_zero | logical | Optional | if true, force the y axis to start at 0 |
| y_ticks | double | Optional | If provided, force y-axis from [y_ticks(1) to y_ticks(end)]
| super_plot_logical | logical | Optional | If true, show group means as a super-plot |
| super_plot_size_offset_double | double | Optional | super-plot symbols are drawn with size `marker_size` + `subper_plot_size_offset` |
| super_plot_XJitterW0dth | double | Optional | width in scatter of super_plot symbols |
| super_plot_alpha | double | Optional | Face-marker alpha (transparency) for super-plot symbols |
| join_points | logical | Optional | If true, link super-plot points from same group in different categories with a line |
| join_line_width | double | Optional | Width of line joining super-plot points |
| join_line_color | double | Optional | Color of joining line |



### Return values

| Parameter | Fields | Description |
| --- | --- | --- |
| stats | | Structure |
|  | main_effects | A main effects table, derived from [anova](https://www.mathworks.com/help/stats/linearmixedmodel.anova.html) |
|  | post_hoc | A table showing post-hoc tests corrected for multiple comparisons using the [Holm-Bonferroni](https://en.wikipedia.org/wiki/Holm%E2%80%93Bonferroni_method) method |
|  | model_string | A string with the model that was tested in [Wilkinson notation](https://www.mathworks.com/help/stats/wilkinson-notation.html) |
|  | main_effects_string | A string summarizing the main effects |



