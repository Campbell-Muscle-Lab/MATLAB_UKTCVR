---
layout: default
title: layout_subplots
has_children: false
parent: Figures
grand_parent: Code
nav_order: 5
---

# layout_subplots.m

## Overview

Function creates subplots with well-defined sizes and positions in a new figure.

## Examples

+ [layout_subplots](../../../demos/figures/layout_subplots/layout_subplots.html)

## Function arguments

```
function subplots = layout_subplots(options);
% Function creates a reproducible panel layout

    arguments
        options.figure_handle (1,1) double = NaN
        options.panels_wide (1,1) double = 1
        options.panels_high (1,1) double = 1
        options.page_height (1,1) double = 11
        options.page_width (1,1) double = 8.5
        options.figure_width (1,1) double = 3.5
        options.top_margin (1,1) double = 0.0
        options.bottom_margin (1,1) double = 0.5
        options.left_margin (1,1) double = 0.5
        options.padding_top (1,:) double = 0.2
        options.padding_bottom (1,:) double = 0.5
        options.padding_left (1,:) double = 0.75
        options.padding_right (1,:) double = 0.25
        options.right_margin (1,1) double = NaN
        options.x_to_y_ratio (1,1) double = 1
        options.padding_left_adjustments (1,:) = 0
        options.padding_right_adjustments (1,:) = 0
        options.padding_top_adjustments (1,:) = 0
        options.padding_bottom_adjustments (1,:) = 0
        options.omit_subplots = NaN
        options.panel_label_font_size (1,1) double = 12
        options.panel_label_font_name (1,1) string = "Helvetica"
        options.panel_label_font_weight (1,1) string = "Bold"
        options.panel_labels (1,:) string = ""
    end
```

## Details

### Inputs

| Parameter | Values | Needed | Description |
| --- | --- | --- | --- |
| figure_handle | double | Optional | A figure handle |
| panels_wide | double | Optional | Number of panels across |
| panels_high | double | Optional | Number of panels down |
| page_height | double | Optional | Height of page in inches (US letter assumed) |
| page_width | double | Optional | Width of page in inches (US letter assumed) |
| top_margin | double | Optional | Top margin for figure in inches |
| bottom_margin | double | Optional | Bottom margin for figure in inches |
| left_margin | double | Optional | Left margin for figure in inches |
| right_margin | double | Optional | Right margin for figure in inches |
| padding_top | double | Optional | Padding above each panel in inches, see padding notes |
| padding_bottom | double | Optional | Padding below each panel in inches, see padding notes |
| padding_left | double | Optional | Padding to left of each panel in inches, see padding notes |
| padding_right | double | Optional | Padding to right of each panel in inches, see padding notes |
| omit_subplots | double | Optional | Array of panels numbers that will not be drawn |
| panel_label_font_size | double | Optional | Font size for labels left of and above each panel |
| panel_label_font_name | double | Optional | Font style for labels left of and above each panel |
| panel_label_font_weight | double | Optional | Font weight for labels left of and above each panel |
| panel_labels | double | Optional | Labels to replace "A", "B", "C" ... default |

### Return values

| Parameter | Values | Description |
| --- | --- | --- |
| subplots | handles | Array of subplot handles |

### Padding notes

+ If there is more than one subplot, `padding` values are interpreted intelligently
  + If the length of the `padding` array is equal to the number of subplots, the ith subplot will use the ith value in the array
  + For `padding_left` and `padding_right`, if the length of the `padding` array is equal to the number of columns, each row will be duplicated with the same left and right values
  + For `padding_top` and `padding_bottom`, if the length of the `padding` array is equal to the number of rows, each column will be duplicated with the same top and bottom values
