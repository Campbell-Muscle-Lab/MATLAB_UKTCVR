---
layout: default
title: layout_subplots
has_children: false
parent: Figures
grand_parent: Demos
nav_order: 1
---

# Layout subplots

[`layout_subplots.m`](../../../code/figures/layout_subplots/layout_subplots.html) creates subplots with well-defined sizes and positions in a figure. It can be useful for creating publication quality figures.

### Note on sizing

`layout_subplots()` creates figures with a default width of 3.5 inches. The images in this documentation will be resized by the browser and will likely appear at a different width. You can adjust the width of the figure with the `figure_width` option - see examples.

## Single panel with default padding

```matlab
layout_subplots();
```
<img src = "layout_subplots_media/figure_0.png" width = "50%">

## Change figure width

```matlab
layout_subplots( ...
    figure_width = 6);
```

<img src = "layout_subplots_media/figure_1.png" width = "100%">

## Two panels across

```matlab
layout_subplots( ...
    panels_wide = 2);
```

<img src = "layout_subplots_media/figure_2.png" width = "50%">

## Change horizontal padding

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    padding_left = 0.3, ...
    padding_right = 0.6);
```
<img src = "layout_subplots_media/figure_3.png" width = "50%">

## Multiple rows

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2);
```

<img src = "layout_subplots_media/figure_4.png" width = "50%">

## Change vertical padding

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    padding_top = 0.5, ...
    padding_bottom = 0.1);
```

<img src = "layout_subplots_media/figure_5.png" width = "50%">

## Different padding for different columns

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    padding_left = [1 0.2]);
```

<img src = "layout_subplots_media/figure_6.png" width = "50%">

## Different padding for different rows

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    padding_top = [1 0.2]);
```

<img src = "layout_subplots_media/figure_7.png" width = "50%">

## Omit panels

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    omit_subplots = [2 3]);
```

<img src = "layout_subplots_media/figure_8.png" width = "50%">

## Padding craziness

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 3, ...
    padding_left = [1 0.5 0.1 0.1 0.5 1]);
```
<img src = "layout_subplots_media/figure_9.png" width = "50%">

## Change aspect ratio

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 3, ...
    x_to_y_ratio = 3);
```

<img src = "layout_subplots_media/figure_10.png" width = "50%">

