
# CVAVOrientation Module
### January 5, 2022


## Model Parameter Estimation

.

## How the Module Works

 * The module calculates the likelihood of a household owning a level 5
   autonomous vehicle. A random draw then decides whether the household
   chooses to own a level 5 AV
 * 




## User Inputs
The following table(s) document each input file that must be provided in order for the module to run correctly. User input files are comma-separated valued (csv) formatted text files. Each row in the table(s) describes a field (column) in the input file. The table names and their meanings are as follows:

NAME - The field (column) name in the input file. Note that if the 'TYPE' is 'currency' the field name must be followed by a period and the year that the currency is denominated in. For example if the NAME is 'HHIncomePC' (household per capita income) and the input values are in 2010 dollars, the field name in the file must be 'HHIncomePC.2010'. The framework uses the embedded date information to convert the currency into base year currency amounts. The user may also embed a magnitude indicator if inputs are in thousand, millions, etc. The VisionEval model system design and users guide should be consulted on how to do that.

TYPE - The data type. The framework uses the type to check units and inputs. The user can generally ignore this, but it is important to know whether the 'TYPE' is 'currency'

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values may not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Value must be one of the listed values.

UNLIKELY - Values that are unlikely. Values that meet any of the listed conditions are permitted but a warning message will be given when the input data are processed.

DESCRIPTION - A description of the data.

### region_av_lev5_propensity_coef.csv
|   |NAME                 |TYPE   |UNITS   |PROHIBIT |ISELEMENTOF |UNLIKELY |DESCRIPTION                                                                      |
|:--|:--------------------|:------|:-------|:--------|:-----------|:--------|:--------------------------------------------------------------------------------|
|1  |Year                 |       |        |         |            |         |Must contain a record for each model run year                                    |
|9  |AVConstant           |double |numeric |NA       |            |         |Constant for AV level 5 propensity model                                         |
|10 |AVFracAge20to29Coef  |double |numeric |NA       |            |         |Age 20 to 29 household fraction coefficient for AV level 5 propensity model      |
|11 |AVFracAge55to64Coef  |double |numeric |NA       |            |         |Age 55 to 64 household fraction coefficient for AV level 5 propensity model      |
|12 |AVFracAge65pCoef     |double |numeric |NA       |            |         |Age 65+ household fraction coefficient for AV level 5 propensity model           |
|13 |AVKidsCoef           |double |numeric |NA       |            |         |Transformed kids number coefficient for car service propoensity model            |
|14 |AVHHIncBelow50KCoef  |double |numeric |NA       |            |         |Household income below 50K USD 2010 coefficient for AV level 5 propensity model  |
|15 |AVHHIncAboce100KCoef |double |numeric |NA       |            |         |Household income aboce 100K USD 2010 coefficient for AV level 5 propensity model |
|16 |AVDistToWrkCoef      |double |numeric |NA       |            |         |Distance to work coefficient for AV level 5 propensity model                     |
### region_car_svc_propensity_coef.csv
|NAME                     |TYPE   |UNITS   |PROHIBIT |ISELEMENTOF |UNLIKELY |DESCRIPTION                                                                       |
|:------------------------|:------|:-------|:--------|:-----------|:--------|:---------------------------------------------------------------------------------|
|Year                     |       |        |         |            |         |Must contain a record for each model run year                                     |
|CSConstant               |double |numeric |NA       |            |         |Constant for car service propensity model                                         |
|CSFracAge20to29Coef      |double |numeric |NA       |            |         |Age 20 to 29 household fraction coefficient for car service propensity model      |
|CSFracAge55to64Coef      |double |numeric |NA       |            |         |Age 55 to 64 household fraction coefficient for car service propensity model      |
|CSFracAge65pCoef         |double |numeric |NA       |            |         |Age 65+ household fraction coefficient for car service propensity model           |
|CSLowCarSvcFlagCoef      |double |numeric |NA       |            |         |Low car service level flag coefficient for car service propensity model           |
|CSHHIncBelow50KFlagCoef  |double |numeric |NA       |            |         |Household income below 50K USD 2010 coefficient for car service propensity model  |
|CSHHIncAbove100KFlagCoef |double |numeric |NA       |            |         |Household income aboce 100K USD 2010 coefficient for car service propensity model |
|CSD1BCoef                |double |numeric |NA       |            |         |D1B coefficient for car service propensity model                                  |

## Datasets Used by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year group. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

|NAME                     |TABLE     |GROUP |TYPE      |UNITS     |PROHIBIT |ISELEMENTOF |
|:------------------------|:---------|:-----|:---------|:---------|:--------|:-----------|
|HhId                     |Household |Year  |character |ID        |         |            |
|Bzone                    |Household |Year  |character |ID        |         |            |
|CarSvcLevel              |Household |Year  |character |category  |         |Low, High   |
|Age0to14                 |Household |Year  |people    |PRSN      |NA, < 0  |            |
|Age15to19                |Household |Year  |people    |PRSN      |NA, < 0  |            |
|Age20to29                |Household |Year  |people    |PRSN      |NA, < 0  |            |
|Age30to54                |Household |Year  |people    |PRSN      |NA, < 0  |            |
|Age55to64                |Household |Year  |people    |PRSN      |NA, < 0  |            |
|Age65Plus                |Household |Year  |people    |PRSN      |NA, < 0  |            |
|Income                   |Household |Year  |currency  |USD.2010  |NA, < 0  |            |
|Bzone                    |Bzone     |Year  |character |ID        |         |            |
|D1B                      |Bzone     |Year  |compound  |PRSN/SQMI |NA, < 0  |            |
|HhId                     |Worker    |Year  |character |ID        |         |            |
|DistanceToWork           |Worker    |Year  |distance  |MI        |NA, <= 0 |            |
|CSConstant               |Region    |Year  |double    |numeric   |NA       |            |
|CSFracAge20to29Coef      |Region    |Year  |double    |numeric   |NA       |            |
|CSFracAge55to64Coef      |Region    |Year  |double    |numeric   |NA       |            |
|CSFracAge65pCoef         |Region    |Year  |double    |numeric   |NA       |            |
|CSLowCarSvcFlagCoef      |Region    |Year  |double    |numeric   |NA       |            |
|CSHHIncBelow50KFlagCoef  |Region    |Year  |double    |numeric   |NA       |            |
|CSHHIncAbove100KFlagCoef |Region    |Year  |double    |numeric   |NA       |            |
|CSD1BCoef                |Region    |Year  |double    |numeric   |NA       |            |
|AVConstant               |Region    |Year  |double    |numeric   |NA       |            |
|AVFracAge20to29Coef      |Region    |Year  |double    |numeric   |NA       |            |
|AVFracAge55to64Coef      |Region    |Year  |double    |numeric   |NA       |            |
|AVFracAge65pCoef         |Region    |Year  |double    |numeric   |NA       |            |
|AVKidsCoef               |Region    |Year  |double    |numeric   |NA       |            |
|AVHHIncBelow50KCoef      |Region    |Year  |double    |numeric   |NA       |            |
|AVHHIncAboce100KCoef     |Region    |Year  |double    |numeric   |NA       |            |
|AVDistToWrkCoef          |Region    |Year  |double    |numeric   |NA       |            |

## Datasets Produced by the Module
The following table documents each dataset that is placed in the datastore by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is placed in.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The native units that are created in the datastore. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

DESCRIPTION - A description of the data.

|NAME             |TABLE     |GROUP |TYPE   |UNITS      |PROHIBIT   |ISELEMENTOF |DESCRIPTION                                                  |
|:----------------|:---------|:-----|:------|:----------|:----------|:-----------|:------------------------------------------------------------|
|AVLvl5Propensity |Household |Year  |double |proportion |NA, <0, >1 |            |Probability of household to own level 5 autonomous vehicles. |
|CarSvcPropensity |Household |Year  |double |proportion |NA, <0, >1 |            |Probability of household to use car service                  |
