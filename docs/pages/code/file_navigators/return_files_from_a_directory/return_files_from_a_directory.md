---
layout: default
title: return_files_from_a_directory
has_children: false
parent: File Navigators
grand_parent: Code
nav_order: 5
---

# return_files_from_a_directory

## Overview

Function helps users to find files similar to click-based "File Explorer/Finder"

## Function arguments

```matlab
function file_list = return_files_from_a_directory(options)

arguments
    options.recursive (1,1) = 0;
end

```

## Details

### Inputs

| Parameter | Values | Needed | Description |
| --- | --- | --- | --- |
| recursive | double | Optional | Descend into subdirectories |

### Return values

| Parameter | Values | Description |
| --- | --- | --- |
| file_list | cell | List of files with full paths |

