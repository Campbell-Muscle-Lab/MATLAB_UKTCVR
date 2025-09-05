

Two way linear mixed model with grouping.

```matlab
% Create data
n_f1 = 2;
n_f2 = 2;
n = 10;
noise = 0.5;
for i = 1 : n_f1
    for j = 1 : n_f2
        vi = (i-1)*(n_f2*n) + (j-1)*n + (1:n);
        y(vi) = 1 + 0.2*i + 0.2*j
        f1(vi) = repmat(sprintf("%i", i), [1, n]);
        f2(vi) = repmat(sprintf("%c", j+64), [1, n]);
    end
end
```

```matlabTextOutput
y = 1x10
1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4

y = 1x20
1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6

y = 1x30
1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6

y = 1x40
1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.4          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.6          1.8          1.8          1.8          1.8          1.8          1.8          1.8          1.8          1.8          1.8

```

```matlab
% Add some jitter, resetting randon number generator for consistency
rng(1)
y = y + noise * (rand(size(y)) - 0.5);

% Add a grouping variable
g = randi(5,size(y));

% Form the table
t = table(y', f1', f2', g', ...
    VariableNames = ["y", "Block", "City", "ID"])
```
| |y|Block|City|ID|
|:--:|:--:|:--:|:--:|:--:|
|1|1.3585|"1"|"A"|5|
|2|1.5102|"1"|"A"|4|
|3|1.1501|"1"|"A"|2|
|4|1.3012|"1"|"A"|4|
|5|1.2234|"1"|"A"|1|
|6|1.1962|"1"|"A"|3|
|7|1.2431|"1"|"A"|5|
|8|1.3228|"1"|"A"|2|
|9|1.3484|"1"|"A"|2|
|10|1.4194|"1"|"A"|1|
|11|1.5596|"1"|"B"|1|
|12|1.6926|"1"|"B"|4|
|13|1.4522|"1"|"B"|2|
|14|1.7891|"1"|"B"|2|
|15|1.3637|"1"|"B"|3|
|16|1.6852|"1"|"B"|1|
|17|1.5587|"1"|"B"|3|
|18|1.6293|"1"|"B"|1|
|19|1.4202|"1"|"B"|3|
|20|1.4491|"1"|"B"|4|
|21|1.7504|"2"|"A"|1|
|22|1.8341|"2"|"A"|3|
|23|1.5067|"2"|"A"|4|
|24|1.6962|"2"|"A"|3|
|25|1.7882|"2"|"A"|1|
|26|1.7973|"2"|"A"|3|
|27|1.3925|"2"|"A"|4|
|28|1.3695|"2"|"A"|3|
|29|1.4349|"2"|"A"|5|
|30|1.7891|"2"|"A"|3|
|31|1.5992|"2"|"B"|5|
|32|1.7606|"2"|"B"|1|
|33|2.0289|"2"|"B"|1|
|34|1.8166|"2"|"B"|5|
|35|1.8959|"2"|"B"|2|
|36|1.7078|"2"|"B"|1|
|37|1.8933|"2"|"B"|5|
|38|1.9673|"2"|"B"|2|
|39|1.5591|"2"|"B"|4|
|40|1.9251|"2"|"B"|4|

```matlab

% Run the stats test
stats = linear_mixed_model(t, "y", "Block", ...
    f2_label = "City", ...
    grouping_label = "ID", ...
    figure_handle = 1);
```

```matlabTextOutput
lin_mix_mod_effects = 
Linear mixed-effects model fit by REML

Model information:
    Number of observations              40
    Fixed effects coefficients           4
    Random effects coefficients          5
    Covariance parameters                2

Formula:
    y ~ 1 + Block*City + (1 | ID)

Model fit statistics:
    AIC        BIC       LogLikelihood    Deviance
    -7.4353    2.0659    9.7176           -19.435 
Fixed effects coefficients (95% CIs):
    Name                      Estimate     SE          tStat       DF    pValue        Lower        Upper    
    {'(Intercept)'   }           1.5796    0.023796      66.383    36    3.0077e-39       1.5314       1.6279
    {'Block_1'       }           -0.146    0.023796     -6.1354    36    4.5838e-07     -0.19426    -0.097736
    {'City_A'        }         -0.10803    0.023796       -4.54    36     6.069e-05     -0.15629    -0.059773
    {'Block_1:City_A'}        -0.018292    0.023796    -0.76872    36       0.44707    -0.066552     0.029968
Random effects covariance parameters (95% CIs):
Group: ID (5 Levels)
    Name1                  Name2                  Type           Estimate      Lower    Upper
    {'(Intercept)'}        {'(Intercept)'}        {'std'}        0.00014986    0        Inf  
Group: Error
    Name               Estimate    Lower      Upper 
    {'Res Std'}        0.1505      0.11946    0.1896
```

![figure_0.png](untitled2_media/figure_0.png)

```matlab

% Expand the output
me = stats.main_effects
```

```matlabTextOutput
me = 
    ANOVA marginal tests: DFMethod = 'Satterthwaite'

    Term                  FStat      DF1    DF2    pValue    
    {'Block'     }         37.643    1      36     4.5839e-07
    {'City'      }         20.612    1      36     6.0691e-05
    {'Block:City'}        0.59094    1      36        0.44707
```

```matlab
pc = stats.post_hoc
```
| |varname_1|varname_2|p_raw|F|df1|df2|p_corrected|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"1:A"|"2:A"|2.154e-05|23.833|1|36|8.6158e-05|
|2|"1:A"|"1:B"|0.00061419|14.091|1|36|0.0012284|
|3|"1:B"|"2:B"|0.00054617|14.401|1|36|0.0016385|
|4|"2:A"|"2:B"|0.011402|7.1114|1|36|0.011402|

```matlab
ms = stats.model_string
```

```matlabTextOutput
ms = "y ~ 1 + Block + City + (Block * City) + (1 | ID)"
```

```matlab
mes = stats.main_effects_string
```

```matlabTextOutput
mes = 
    "Block: p < 0.001
     City: p < 0.001
     Block * City: p = 0.447"
```
