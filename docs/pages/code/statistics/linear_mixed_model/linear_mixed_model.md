---
layout: default
title: linear_mixed_model
has_children: false
parent: Statistics
grand_parent: Code
nav_order: 1
---

# Linear mixed model

## Overview

This function uses [fitlme](https://www.mathworks.com/help/stats/fitlme.html) to fit one-way or two-way linear mixed models with an optional grouping variable to data.

Models can be of the form:
+ y ~ factor_1
+ y ~ factor_1 + (1 \| grouping)
+ y ~ factor_1 + factor_2 + (factor_1 * factor_2)
+ y ~ factor_1 + factor_2 + (factor_1 * factor_2) + (1 \| grouping)

Main effects are dervied using [anova](https://www.mathworks.com/help/stats/linearmixedmodel.anova.html)

Post-hoc tests are calculated using [coefTest](https://www.mathworks.com/help/stats/linearmixedmodel.coeftest.html) and then corrected using the [Holm-Bonferroni](https://en.wikipedia.org/wiki/Holm%E2%80%93Bonferroni_method) method.


## Function arguments

```
function stats = linear_mixed_model(t, data_label, f1_label, options);

    arguments
        t (:,:) table
        data_label (1,1) string
        f1_label (1,1) string
        options.f2_label (1,1) string = ""
        options.grouping_label (1,1) string = ""
        options.figure_handle (1,1) double = 0
        options.subplot_handle (1,1) double = 0

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

### Return values

| Parameter | Fields | Description |
| --- | --- | --- |
| stats | | Structure |
|  | main_effects | A main effects table, derived from [anova](https://www.mathworks.com/help/stats/linearmixedmodel.anova.html) |
|  | post_hoc | A table showing post-hoc tests with Holm-Bonferonni corrections |
|  | model_string | A string with the model that was tested in Wilkinson notation |
|  | main_effects_string | A string summarizing the main effects |


## Examples

+ [Linear mixed model demos](../../../demos/statistics/linear_mixed_model/linear_mixed_model.html)


