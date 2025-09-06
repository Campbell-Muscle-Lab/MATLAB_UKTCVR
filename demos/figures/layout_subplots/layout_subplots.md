

Header


\-\-\-


Single panel with default padding

```matlab
layout_subplots();
```

![figure_0.png](layout_subplots_media/figure_0.png)

Change figure width

```matlab
layout_subplots( ...
    figure_width = 6);
```

![figure_1.png](layout_subplots_media/figure_1.png)

Two panels across

```matlab
layout_subplots( ...
    panels_wide = 2);
```

![figure_2.png](layout_subplots_media/figure_2.png)

Change horizontal padding

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    padding_left = 0.3, ...
    padding_right = 0.6);
```

![figure_3.png](layout_subplots_media/figure_3.png)

Multiple rows

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2);
```

![figure_4.png](layout_subplots_media/figure_4.png)

Change vertical padding

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    padding_top = 0.5, ...
    padding_bottom = 0.1);
```

![figure_5.png](layout_subplots_media/figure_5.png)

Different padding for different columns

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    padding_left = [1 0.2]);
```

![figure_6.png](layout_subplots_media/figure_6.png)

Different padding for different rows

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    padding_top = [1 0.2]);
```

![figure_7.png](layout_subplots_media/figure_7.png)

Omit panels

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 2, ...
    omit_subplots = [2 3]);
```

![figure_8.png](layout_subplots_media/figure_8.png)

Padding craziness

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 3, ...
    padding_left = [1 0.5 0.1 0.1 0.5 1]);
```

![figure_9.png](layout_subplots_media/figure_9.png)

Change aspect ratio

```matlab
layout_subplots( ...
    panels_wide = 2, ...
    panels_high = 3, ...
    x_to_y_ratio = 3);
```

![figure_10.png](layout_subplots_media/figure_10.png)
