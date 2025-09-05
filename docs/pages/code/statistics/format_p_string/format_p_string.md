---
layout: default
title: format_p_string
has_children: false
parent: Statistics
grand_parent: Code
nav_order: 5
---

# format_p_string

## Overview

Function takes a numeric p-value as input and returns a string of the form:
+ p = 0.323
+ p < 0.001

## Function arguments

```
function s = format_p_string(p, options)
    % Returns a nicely formatted p string

    arguments
        p (1,1) double
        options.threshold (1,1) double = 0.001;
    end
end
```

## Details

### Inputs

| Parameter | Values | Needed | Description |
| --- | --- | --- | --- |
| p | double | Required | p-value |
| threshold | double | Optional | Value x below which string becomes "p < x" |

### Return values

| Parameter | Values | Description |
| --- | --- | --- |
| p_string | string | Formatted p-string |

