
# CalculateAltModeTrips Module
### November 23, 2018

This module calculates household transit trips, walk trips, and bike trips. The models are sensitive to household DVMT so they are run after all household DVMT adjustments (e.g. to account for cost on household DVMT) are made.

## Model Parameter Estimation

Hurdle models are estimated for calculating the numbers of household transit, walk, and bike trips using the [pscl](https://cran.r-project.org/web/packages/pscl/vignettes/countreg.pdf) package. Separate models are calculated for metropolitan and non-metropolitan households to account for the additional variables available in metropolitan areas.

Following are the estimation statistics for the metropolitan and nonmetropolitan **walk** trip models.

**Metropolitan Walk Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-4.7365 -1.3363 -0.5991  0.5863 32.2141 

Count model coefficients (truncated poisson with log link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   4.584e+00  6.697e-03  684.44   <2e-16 ***
HhSize        3.170e-01  8.369e-04  378.78   <2e-16 ***
LogIncome     1.417e-01  6.562e-04  215.99   <2e-16 ***
LogDensity   -3.723e-03  3.342e-04  -11.14   <2e-16 ***
BusEqRevMiPC  1.630e-03  1.302e-05  125.21   <2e-16 ***
Urban         4.595e-02  6.120e-04   75.08   <2e-16 ***
LogDvmt      -2.184e-01  7.172e-04 -304.48   <2e-16 ***
Age0to14     -3.256e-01  9.079e-04 -358.62   <2e-16 ***
Age15to19    -8.738e-02  1.099e-03  -79.53   <2e-16 ***
Age20to29     4.691e-02  9.317e-04   50.35   <2e-16 ***
Age30to54     2.092e-02  7.154e-04   29.24   <2e-16 ***
Age65Plus    -3.500e-02  8.485e-04  -41.25   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -2.2823316  0.2614442  -8.730  < 2e-16 ***
HhSize        0.4591272  0.0385322  11.915  < 2e-16 ***
LogIncome     0.2793231  0.0260118  10.738  < 2e-16 ***
LogDensity    0.0236387  0.0137691   1.717 0.086018 .  
BusEqRevMiPC -0.0038123  0.0005494  -6.939 3.96e-12 ***
Urban         0.0645734  0.0260819   2.476 0.013294 *  
LogDvmt      -0.2546829  0.0313266  -8.130 4.30e-16 ***
Age0to14     -0.3714437  0.0422615  -8.789  < 2e-16 ***
Age15to19    -0.1960779  0.0555817  -3.528 0.000419 ***
Age20to29     0.0929791  0.0428980   2.167 0.030201 *  
Age30to54     0.0648855  0.0309899   2.094 0.036281 *  
Age65Plus    -0.0372282  0.0344144  -1.082 0.279358    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 18 
Log-likelihood: -2.475e+06 on 24 Df
```

**Nonmetropolitan Walk Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-2.9713 -1.2631 -0.5841  0.5359 34.5811 

Count model coefficients (truncated poisson with log link):
              Estimate Std. Error z value Pr(>|z|)    
(Intercept)  6.1531783  0.0044802 1373.43   <2e-16 ***
HhSize       0.3303164  0.0006747  489.59   <2e-16 ***
LogIncome   -0.0237945  0.0005587  -42.59   <2e-16 ***
LogDensity  -0.0377121  0.0001842 -204.78   <2e-16 ***
LogDvmt     -0.0413761  0.0010314  -40.12   <2e-16 ***
Age0to14    -0.3605733  0.0007033 -512.65   <2e-16 ***
Age15to19   -0.1465347  0.0008401 -174.42   <2e-16 ***
Age20to29    0.0241467  0.0006777   35.63   <2e-16 ***
Age30to54   -0.0190296  0.0005360  -35.50   <2e-16 ***
Age65Plus   -0.0301504  0.0006137  -49.12   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.497978   0.159756  -3.117  0.00183 ** 
HhSize       0.145183   0.029146   4.981 6.32e-07 ***
LogIncome    0.058058   0.019814   2.930  0.00339 ** 
LogDensity  -0.034540   0.006875  -5.024 5.05e-07 ***
LogDvmt      0.117499   0.036044   3.260  0.00111 ** 
Age0to14    -0.190571   0.030044  -6.343 2.25e-10 ***
Age15to19    0.021176   0.038480   0.550  0.58210    
Age20to29    0.092830   0.028744   3.230  0.00124 ** 
Age30to54    0.064078   0.021310   3.007  0.00264 ** 
Age65Plus   -0.049953   0.023210  -2.152  0.03138 *  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 16 
Log-likelihood: -4.195e+06 on 20 Df
```

Following are the estimation statistics for the metropolitan and nonmetropolitan **bike** trip models.

**Metropolitan Bike Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-1.2353 -0.3524 -0.2790 -0.2282 34.1246 

Count model coefficients (truncated poisson with log link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   6.3283616  0.0247456  255.74   <2e-16 ***
HhSize        0.1106022  0.0042712   25.89   <2e-16 ***
LogIncome    -0.0672254  0.0029054  -23.14   <2e-16 ***
BusEqRevMiPC -0.0022431  0.0000602  -37.26   <2e-16 ***
LogDvmt      -0.1700974  0.0033299  -51.08   <2e-16 ***
Age0to14     -0.1938028  0.0044803  -43.26   <2e-16 ***
Age15to19    -0.1357069  0.0052912  -25.65   <2e-16 ***
Age20to29     0.0788543  0.0044252   17.82   <2e-16 ***
Age30to54     0.0789147  0.0036175   21.82   <2e-16 ***
Age65Plus     0.0491381  0.0043173   11.38   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -4.7714145  0.3803000 -12.546  < 2e-16 ***
HhSize        0.1658499  0.0580473   2.857 0.004275 ** 
LogIncome     0.2005661  0.0431870   4.644 3.42e-06 ***
BusEqRevMiPC -0.0061592  0.0008651  -7.120 1.08e-12 ***
LogDvmt      -0.0398758  0.0495918  -0.804 0.421350    
Age0to14      0.0452372  0.0599548   0.755 0.450536    
Age15to19     0.2071904  0.0717227   2.889 0.003867 ** 
Age20to29     0.2301472  0.0614262   3.747 0.000179 ***
Age30to54     0.1712970  0.0483193   3.545 0.000392 ***
Age65Plus    -0.0756225  0.0613722  -1.232 0.217876    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 43 
Log-likelihood: -1.193e+05 on 20 Df
```

**Nonmetropolitan Bike Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-2.4416 -0.3567 -0.2792 -0.2273 57.2737 

Count model coefficients (truncated poisson with log link):
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  5.889636   0.017452  337.48   <2e-16 ***
HhSize       0.242386   0.002575   94.12   <2e-16 ***
LogIncome    0.033452   0.002126   15.74   <2e-16 ***
LogDvmt     -0.386477   0.003246 -119.07   <2e-16 ***
Age0to14    -0.289419   0.002742 -105.55   <2e-16 ***
Age15to19   -0.092265   0.003160  -29.20   <2e-16 ***
Age20to29    0.095809   0.002578   37.16   <2e-16 ***
Age30to54    0.024555   0.002280   10.77   <2e-16 ***
Age65Plus   -0.033623   0.002863  -11.74   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -4.62360    0.27758 -16.657  < 2e-16 ***
HhSize       0.21599    0.04552   4.745 2.08e-06 ***
LogIncome    0.19379    0.03288   5.895 3.75e-09 ***
LogDvmt     -0.12194    0.05755  -2.119 0.034116 *  
Age0to14    -0.05081    0.04528  -1.122 0.261802    
Age15to19    0.18231    0.05279   3.454 0.000553 ***
Age20to29    0.25782    0.04318   5.971 2.36e-09 ***
Age30to54    0.17485    0.03476   5.031 4.88e-07 ***
Age65Plus   -0.18270    0.04440  -4.115 3.88e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 18 
Log-likelihood: -2.874e+05 on 18 Df
```

Following are the estimation statistics for the metropolitan and nonmetropolitan **transit** trip models.

**Metropolitan Transit Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-3.8971 -0.3420 -0.2262 -0.1478 34.7335 

Count model coefficients (truncated poisson with log link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   6.027e+00  1.044e-02 577.395  < 2e-16 ***
HhSize        1.344e-02  6.684e-04  20.113  < 2e-16 ***
LogIncome     5.804e-02  1.001e-03  57.977  < 2e-16 ***
LogDensity    4.504e-02  5.876e-04  76.662  < 2e-16 ***
BusEqRevMiPC  1.886e-03  2.542e-05  74.194  < 2e-16 ***
LogDvmt      -9.579e-02  1.005e-03 -95.353  < 2e-16 ***
Urban         3.459e-02  1.076e-03  32.158  < 2e-16 ***
Age15to19    -1.219e-03  1.207e-03  -1.010    0.313    
Age20to29     6.578e-02  1.333e-03  49.358  < 2e-16 ***
Age30to54     4.875e-02  1.262e-03  38.641  < 2e-16 ***
Age65Plus     8.671e-03  1.662e-03   5.216 1.83e-07 ***
Zero hurdle model coefficients (binomial with logit link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -4.1943544  0.4119409 -10.182  < 2e-16 ***
HhSize        0.5179732  0.0245815  21.072  < 2e-16 ***
LogIncome     0.3451648  0.0403832   8.547  < 2e-16 ***
LogDensity   -0.0386913  0.0214044  -1.808 0.070663 .  
BusEqRevMiPC  0.0097474  0.0008816  11.056  < 2e-16 ***
LogDvmt      -1.0651178  0.0416333 -25.583  < 2e-16 ***
Urban         0.0720125  0.0400020   1.800 0.071826 .  
Age15to19     0.3071301  0.0470229   6.532 6.51e-11 ***
Age20to29     0.1941434  0.0521210   3.725 0.000195 ***
Age30to54     0.3874914  0.0466742   8.302  < 2e-16 ***
Age65Plus    -0.5823466  0.0644653  -9.033  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 21 
Log-likelihood: -3.382e+05 on 22 Df
```

**Nonmetropolitan Transit Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-6.3342 -0.2401 -0.1567 -0.1048 45.2167 

Count model coefficients (truncated poisson with log link):
              Estimate Std. Error z value Pr(>|z|)    
(Intercept)  6.7686333  0.0105625 640.815  < 2e-16 ***
HhSize       0.0532423  0.0018394  28.946  < 2e-16 ***
LogIncome    0.0588827  0.0012725  46.273  < 2e-16 ***
LogDensity  -0.0124192  0.0004655 -26.678  < 2e-16 ***
LogDvmt     -0.1351689  0.0019850 -68.096  < 2e-16 ***
Age0to14    -0.0084243  0.0018218  -4.624 3.76e-06 ***
Age15to19    0.0235982  0.0020681  11.411  < 2e-16 ***
Age20to29   -0.0323185  0.0021757 -14.855  < 2e-16 ***
Age30to54   -0.0274501  0.0017202 -15.958  < 2e-16 ***
Age65Plus   -0.0709362  0.0027658 -25.648  < 2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -1.45053    0.35064  -4.137 3.52e-05 ***
HhSize       0.49031    0.06451   7.601 2.94e-14 ***
LogIncome    0.23265    0.04345   5.354 8.60e-08 ***
LogDensity  -0.17530    0.01441 -12.161  < 2e-16 ***
LogDvmt     -1.27347    0.06922 -18.398  < 2e-16 ***
Age0to14     0.25463    0.06337   4.018 5.87e-05 ***
Age15to19    0.38506    0.07126   5.403 6.54e-08 ***
Age20to29    0.06974    0.07214   0.967    0.334    
Age30to54    0.53252    0.05692   9.355  < 2e-16 ***
Age65Plus   -0.60581    0.08593  -7.050 1.79e-12 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 21 
Log-likelihood: -2.818e+05 on 20 Df
```

## How the Module Works

This module is run after all household DVMT adjustments are made due to cost, travel demand management, and light-weight vehicle (e.g. bike, scooter) diversion, so that alternative mode travel reflects the result of those influences. The alternative mode trip models are run and the results are saved.


## User Inputs
This module has no user input requirements.

## Datasets Used by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year group. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

|NAME            |TABLE     |GROUP |TYPE      |UNITS      |PROHIBIT |ISELEMENTOF        |
|:---------------|:---------|:-----|:---------|:----------|:--------|:------------------|
|Marea           |Marea     |Year  |character |ID         |         |                   |
|TranRevMiPC     |Marea     |Year  |compound  |MI/PRSN/YR |NA, < 0  |                   |
|Marea           |Bzone     |Year  |character |ID         |         |                   |
|Bzone           |Bzone     |Year  |character |ID         |         |                   |
|D1B             |Bzone     |Year  |compound  |PRSN/SQMI  |NA, < 0  |                   |
|Marea           |Household |Year  |character |ID         |         |                   |
|Bzone           |Household |Year  |character |ID         |         |                   |
|Age0to14        |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age15to19       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age20to29       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age30to54       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age55to64       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age65Plus       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|LocType         |Household |Year  |character |category   |NA       |Urban, Town, Rural |
|HhSize          |Household |Year  |people    |PRSN       |NA, <= 0 |                   |
|Income          |Household |Year  |currency  |USD.2001   |NA, < 0  |                   |
|Vehicles        |Household |Year  |vehicles  |VEH        |NA, < 0  |                   |
|IsUrbanMixNbrhd |Household |Year  |integer   |binary     |NA       |0, 1               |
|Dvmt            |Household |Year  |compound  |MI/DAY     |NA, < 0  |                   |

## Datasets Produced by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

DESCRIPTION - A description of the data.

|NAME         |TABLE     |GROUP |TYPE     |UNITS   |PROHIBIT |ISELEMENTOF |DESCRIPTION                                                          |
|:------------|:---------|:-----|:--------|:-------|:--------|:-----------|:--------------------------------------------------------------------|
|WalkTrips    |Household |Year  |compound |TRIP/YR |NA, < 0  |            |Average number of walk trips per year by household members           |
|BikeTrips    |Household |Year  |compound |TRIP/YR |NA, < 0  |            |Average number of bicycle trips per year by household members        |
|TransitTrips |Household |Year  |compound |TRIP/YR |NA, < 0  |            |Average number of public transit trips per year by household members |
