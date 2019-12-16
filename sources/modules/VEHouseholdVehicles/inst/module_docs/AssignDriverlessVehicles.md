
# AssignDriverlessVehicles Module
### October 30, 2019

This module determines whether a household vehicle is driverless or not. It also determines the driverless DVMT proportion of car service vehicles (commercial service vehicles, heavey trucks, and public transit vehicles).

## How the Module Works

The module randomly assigns  value of 1 for driverless vehicle owned by the household and 0 for other household vehicles.


## User Inputs
The following table(s) document each input file that must be provided in order for the module to run correctly. User input files are comma-separated valued (csv) formatted text files. Each row in the table(s) describes a field (column) in the input file. The table names and their meanings are as follows:

NAME - The field (column) name in the input file. Note that if the 'TYPE' is 'currency' the field name must be followed by a period and the year that the currency is denominated in. For example if the NAME is 'HHIncomePC' (household per capita income) and the input values are in 2010 dollars, the field name in the file must be 'HHIncomePC.2010'. The framework uses the embedded date information to convert the currency into base year currency amounts. The user may also embed a magnitude indicator if inputs are in thousand, millions, etc. The VisionEval model system design and users guide should be consulted on how to do that.

TYPE - The data type. The framework uses the type to check units and inputs. The user can generally ignore this, but it is important to know whether the 'TYPE' is 'currency'

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values may not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Value must be one of the listed values.

UNLIKELY - Values that are unlikely. Values that meet any of the listed conditions are permitted but a warning message will be given when the input data are processed.

DESCRIPTION - A description of the data.

### region_driverless_vehicle_prop.csv
|NAME                     |TYPE   |UNITS      |PROHIBIT |ISELEMENTOF |UNLIKELY |DESCRIPTION                                                                                                                                                                                |
|:------------------------|:------|:----------|:--------|:-----------|:--------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|VehYear                  |time   |YR         |NA, < 0  |            |         |The year represents the vehicle model year for household vehicles (automobile and light truck) and operation year for car service vehicles, commercial service vehicles, and heavy trucks. |
|AutoDriverlessProp       |double |proportion |NA, < 0  |            |> 1.5    |The proportion of automobiles sold in the corresponding year that are driverless. Values for intervening years are interpolated                                                            |
|LtTrkDriverlessProp      |double |proportion |NA, < 0  |            |> 1.5    |The proportion of light trucks sold in the corresponding year that are driverless. Values for intervening years are interpolated                                                           |
|LowCarSvcDriverlessProp  |double |proportion |NA, < 0  |            |> 1.5    |The proportion of the car service fleet DVMT in low car service areas in the corresponding year that are driverless. Values for intervening years are interpolated                         |
|HighCarSvcDriverlessProp |double |proportion |NA, < 0  |            |> 1.5    |The proportion of the car service fleet DVMT in high car service areas in the corresponding year that are driverless. Values for intervening years are interpolated                        |
|ComSvcDriverlessProp     |double |proportion |NA, < 0  |            |> 1.5    |The proportion of the commercial service vehicle fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.                                  |
|HvyTrkDriverlessProp     |double |proportion |NA, < 0  |            |> 1.5    |The proportion of the heavy truck fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated                                                  |
|PtVanDriverlessProp      |double |proportion |NA, < 0  |            |> 1.5    |The proportion of public transit van DVMT in the corresponding year that are driverless. Values for intervening years are interpolated                                                     |
|BusDriverlessProp        |double |proportion |NA, < 0  |            |> 1.5    |The proportion of bus fleet DVMT in the corresponding year that are driverless. Values for intevening years are interpolated                                                               |

## Datasets Used by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year group. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

|NAME                     |TABLE                 |GROUP  |TYPE      |UNITS      |PROHIBIT |ISELEMENTOF                |
|:------------------------|:---------------------|:------|:---------|:----------|:--------|:--------------------------|
|VehYear                  |RegionDriverlessProps |Global |time      |YR         |NA, < 0  |                           |
|AutoDriverlessProp       |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|LtTrkDriverlessProp      |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|LowCarSvcDriverlessProp  |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|HighCarSvcDriverlessProp |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|ComSvcDriverlessProp     |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|HvyTrkDriverlessProp     |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|PtVanDriverlessProp      |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|BusDriverlessProp        |RegionDriverlessProps |Global |double    |proportion |NA, < 0  |                           |
|HhId                     |Vehicle               |Year   |character |ID         |NA       |                           |
|VehId                    |Vehicle               |Year   |character |ID         |NA       |                           |
|Age                      |Vehicle               |Year   |time      |YR         |NA, < 0  |                           |
|VehicleAccess            |Vehicle               |Year   |character |category   |         |Own, LowCarSvc, HighCarSvc |
|Type                     |Vehicle               |Year   |character |category   |NA       |Auto, LtTrk                |
|HhId                     |Household             |Year   |character |ID         |NA       |                           |
|NumLtTrk                 |Household             |Year   |vehicles  |VEH        |NA, < 0  |                           |
|NumAuto                  |Household             |Year   |vehicles  |VEH        |NA, < 0  |                           |
|NumHighCarSvc            |Household             |Year   |vehicles  |VEH        |NA, < 0  |                           |

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

|NAME               |TABLE     |GROUP |TYPE   |UNITS       |PROHIBIT     |ISELEMENTOF |DESCRIPTION                                                                                 |
|:------------------|:---------|:-----|:------|:-----------|:------------|:-----------|:-------------------------------------------------------------------------------------------|
|DriverlessDvmtProp |Household |Year  |double |proportion  |NA, < 0      |            |The proportion of household DVMT that is in driverless vehicles.                            |
|Driverless         |Vehicle   |Year  |double |proportions |NA, < 0, > 1 |            |Driverless vehicle identifier. A value of 1 indicates that the owned vehicle is driverless. |
