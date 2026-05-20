---
layout: default
title: return_neat_ticks
has_children: false
parent: Figures
grand_parent: Demos
nav_order: 20
---

# Return_neat_ticks

[`return_neat_ticks.m`](../../../code/figures/return_neat_ticks/return_neat_ticks.m) returns intelligently-chosen ticks and neatly formatted tick labels.

## Examples

```
x = [3, 6];
[a, b] = return_neat_ticks(x)

a =
     0     6
b = 
  1×2 string array
    "0"    "6"

x = [3, 600];
[a, b] = return_neat_ticks(x)

a =
     0   600
b = 
  1×2 string array
    "0"    "600"

x = [-2, 6];
[a, b] = return_neat_ticks(x)

a =
  -200     0   600
b = 
  1×3 string array
    "-200"    "0"    "600"

x = [-21000, 4000];
[a, b] = return_neat_ticks(x)

a =
      -40000           0       20000
b = 
  1×3 string array
    "-40000"    "0"    "20000"

x = [0 0.34];
[a, b] = return_neat_ticks(x)

a =
            0          0.4
b = 
  1×2 string array
    "0.0"    "0.4"

x = [-0.23 0.34];
[a, b] = return_neat_ticks(x)
a =
         -0.4            0          0.4
b = 
  1×3 string array
    "-0.4"    "0.0"    "0.4"

x = [-0.23 0.34 ] * 1e-4
[a, b] = return_neat_ticks(x)

a =
      -0.0004            0       0.0004
b = 
  1×3 string array
    "-0.0004"    "0"    "0.0004"

x = [-0.23 0.34 ] * 1e-5
[a, b] = return_neat_ticks(x)

a =
       -4e-05            0        4e-05
b = 
  1×3 string array
    "-4e-05"    "0"    "4e-05"

x = [-0.23 0.34 ] * 1e-5
[a, b] = return_neat_ticks(x)

a =
       -4e-06            0        4e-06
b = 
  1×3 string array
    "-4e-06"    "0"    "4e-06"
```
