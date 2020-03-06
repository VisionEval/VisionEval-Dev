

## VEHouseholdVehicles

### *CreateVehicleTable*

- *Expected Results*
  
  - It should populate (store in Datastore) the vehicle table all the variables specified in the *azone_carsvc_characteristics.csv*.
  
- *Inputs*
  
  - ***azone_carsvc_characteristics.csv***: 
  
    | Geo   | Year | HighCarSvcCost.2010 | LowCarSvcCost.2010 | AveCarSvcVehicleAge | LtTrkCarSvcSubProp | AutoCarSvcSubProp | LowCarSvcDeadheadProp | HighCarSvcDeadheadProp |
    | ----- | ---- | ------------------- | ------------------ | ------------------- | ------------------ | ----------------- | --------------------- | ---------------------- |
    | RVMPO | 2010 | 1                   | 3                  | 3                   | 0.75               | 1                 | 0.1                   | 0.2                    |
    | RVMPO | 2038 | 1                   | 3                  | 2                   | 0.75               | 1                 | 0.2                   | 0.4                    |
  
- *Outputs*

  - ***Datastore***:

    | Year | HighCarSvcCost_USD_ | LowCarSvcCost_USD_ | AveCarSvcVehicleAge_DAY_ | LtTrkCarSvcSubProp_proportion_ | AutoCarSvcSubProp_proportion_ | LowCarSvcDeadheadProp_proportion_ | HighCarSvcDeadheadProp_proportion_ |
    | ---- | ------------------- | ------------------ | ------------------------ | ------------------------------ | ----------------------------- | --------------------------------- | ---------------------------------- |
    | 2010 | 1                   | 3                  | 1095                     | 0.75                           | 1                             | 0.1                               | 0.2                                |
    | 2038 | 1                   | 3                  | 730                      | 0.75                           | 1                             | 0.2                               | 0.4                                |
  
- *Conclusion*

  - The module works because the datastore shows the expected results.

### *AssignDriverlessVehicles*

- *Expected Results*
  
  - The module should assign a value of 0 (if not driverless) , 1(if driverless and household vehicle), and  between 0 and 1 if the for household with access to car services to all household vehicles based on the driverless vehicle proportion specified in *region_driverless_vehicle_prop.csv* (input) file. As the proportions are set to 0 we should expect to see no driverless vehicles.
  - The module should calculate the proportion of DVMT that is in driverless vehicles. As the proportion of driverless vehicles is set to 0 we should expect to see 0% of DVMT in driverless vehicles.
  
- *Inputs*
  
  - ***region_driverless_vehicle_prop.csv***: 
  
    | VehYear  | AutoSalesDriverlessProp | LtTrkSalesDriverlessProp | LowCarSvcDriverlessProp | HighCarSvcDriverlessProp | ComSvcDriverlessProp | HvyTrkDriverlessProp | PtVanDriverlessProp | BusDriverlessProp |
    | -------- | ----------------------- | ------------------------ | ----------------------- | ------------------------ | -------------------- | -------------------- | ------------------- | ----------------- |
    | 1990     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 1995     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2000     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2005     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2010     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2015     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2020     | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | **2025** | **0**                   | **0**                    | **0**                   | **0**                    | **0**                | **0**                | **0**               | **0**             |
    | **2030** | **0**                   | **0**                    | **0**                   | **0**                    | **0**                | **0**                | **0**               | **0**             |
    | **2035** | **0**                   | **0**                    | **0**                   | **0**                    | **0**                | **0**                | **0**               | **0**             |
    | **2040** | **0**                   | **0**                    | **0**                   | **0**                    | **0**                | **0**                | **0**               | **0**             |
    | **2045** | **0**                   | **0**                    | **0**                   | **0**                    | **0**                | **0**                | **0**               | **0**             |
    | **2050** | **0**                   | **0**                    | **0**                   | **0**                    | **0**                | **0**                | **0**               | **0**             |
  
- *Outputs*

  - ***Driverless (Datastore/Year/Vehicle)***:
  
    | Year     | VehicleAccess  | Driverless | Count       | Percentage |
    | -------- | -------------- | ---------- | ----------- | ---------- |
    | 2010     | Own            | 0          | 122,212     | 100%       |
    | 2010     | LowCarSvc      | 0          | 18,148      | 100%       |
    | **2038** | **Own**        | **0**      | **176,536** | **100%**   |
    | **2038** | **LowCarSvc**  | **0**      | **31,456**  | **100%**   |
    | **2038** | **HighCarSvc** | **0**      | **1,932**   | **100%**   |
  
  - ***DriverlessDvmtProp (Datastore/Year/Household)***:
  
    | Year     | Min.  | 1st Qu. | Median | Mean  | 3rd Qu. | Max.  |
    | -------- | ----- | ------- | ------ | ----- | ------- | ----- |
    | 2010     | -     | -       | -      | -     | -       | -     |
    | **2038** | **-** | **-**   | **-**  | **-** | **-**   | **-** |
  
- *Conclusion*

  - None of the household vehicles are identified as driverless as the value of proportion of vehicles that are driverless is set to 0.

## VETravelPerformance

### *CalculateRoadDvmt*

- *Expected Results*

  - The module should assign a value of 0 (if not driverless) , 1(if driverless and household vehicle), and  between 0 and 1 if the for household with access to car services to all household vehicles based on the driverless vehicle proportion specified in *region_driverless_vehicle_prop.csv* (input) file. As the proportions are set to 0 we should expect to see no driverless vehicles.
  - The module should calculate the proportion of DVMT that is in driverless vehicles. As the proportion of driverless vehicles is set to 0 we should expect to see 0% of DVMT in driverless vehicles.
  
- *Inputs*

  - ***Datastore/Global/RegionDriverlessProps***: 

    | VehYear | AutoSalesDriverlessProp | LtTrkSalesDriverlessProp | LowCarSvcDriverlessProp | HighCarSvcDriverlessProp | ComSvcDriverlessProp | HvyTrkDriverlessProp | PtVanDriverlessProp | BusDriverlessProp |
    | ------- | ----------------------- | ------------------------ | ----------------------- | ------------------------ | -------------------- | -------------------- | ------------------- | ----------------- |
    | 1990    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 1995    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2000    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2005    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2010    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2015    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2020    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2025    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2030    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2035    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2040    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2045    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |
    | 2050    | 0                       | 0                        | 0                       | 0                        | 0                    | 0                    | 0                   | 0                 |

  - ***DriverlessDvmtProp (Datastore/2010/Household)***:

    | Year     | Min.  | 1st Qu. | Median | Mean  | 3rd Qu. | Max.  |
    | -------- | ----- | ------- | ------ | ----- | ------- | ----- |
    | 2010     | -     | -       | -      | -     | -       | -     |
    | **2038** | **-** | **-**   | **-**  | **-** | **-**   | **-** |

- *Outputs*

  - *Driverless Proportion by vehicle class*
  
    | Year     | Table     | Iter  | LdvDriverlessProp | HhDriverlessDvmtProp | HvyTrkDriverlessProp | BusDriverlessProp |
    | -------- | --------- | ----- | ----------------- | -------------------- | -------------------- | ----------------- |
    | 2010     | Marea     | 1     | -                 | -                    | -                    | -                 |
    | 2010     | Marea     | 2     | -                 | -                    | -                    | -                 |
    | **2038** | **Marea** | **1** | **-**             | **-**                | **-**                | **-**             |
    | **2038** | **Marea** | **2** | **-**             | **-**                | **-**                | **-**             |
  
- *Conclusion*

  - All the driverless variables get populated by 0.

### *CalculateRoadPerformance*

- *Expected Results*
  
  - The 0% of driverless vehicles should not have any significant impact on delay due to congestion when compared to model with no implementation of driverless vehicles.
  
- *Inputs (Additional/Modified)*
  
  - ***other_ops_effectiveness.csv***:
  
    | Level | Fwy_Rcr  | Art_Rcr  | Fwy_NonRcr | Art_NonRcr |
    | ----- | -------- | -------- | ---------- | ---------- |
    | None  | 0        | 0        | 0          | 0          |
    | Mod   | 100      | -256.844 | 75         | 75         |
    | Hvy   | 47.42322 | -32.0267 | 75         | 75         |
    | Sev   | 51.90452 | 15.44278 | 75         | 75         |
    | Ext   | 51.081   | 47.03741 | 75         | 75         |
  
  - ***driverless_effect_adj_param.csv***:
  
    | Measure        | Beta |
    | -------------- | ---- |
    | FwyRcrDelay    | 8    |
    | ArtRcrDelay    | 10   |
    | FwyNonRcrDelay | 3    |
    | ArtNonRcrDelay | 3    |
    | FwySmooth      | 5    |
    | ArtSmooth      | 7    |
  
  - ***LdvDriverlessProp, HvyTrkDriverlessProp, and BusDriverlessProp (Datastore/Year/Marea)***:
  
    | Year     | Table     | Iter  | LdvDriverlessProp | HvyTrkDriverlessProp | BusDriverlessProp |
    | -------- | --------- | ----- | ----------------- | -------------------- | ----------------- |
    | 2010     | Marea     | 1     | -                 | -                    | -                 |
    | 2010     | Marea     | 2     | -                 | -                    | -                 |
    | **2038** | **Marea** | **1** | **-**             | **-**                | **-**             |
    | **2038** | **Marea** | **2** | **-**             | **-**                | **-**             |
  
- *Outputs*

  - *Proportion of congestion by road class and congestion level*:

    | Year     | Table     | Iter  | RoadClass | None      | Mod       | Hvy       | Sev       | Ext       |
    | -------- | --------- | ----- | --------- | --------- | --------- | --------- | --------- | --------- |
    | 2010     | Marea     | 1     | Art       | 51.7%     | 19.0%     | 13.3%     | 7.4%      | 8.6%      |
    | 2010     | Marea     | 1     | Fwy       | 79.2%     | 11.1%     | 5.5%      | 3.5%      | 0.7%      |
    | 2010     | Marea     | 2     | Art       | 51.7%     | 19.0%     | 13.3%     | 7.4%      | 8.6%      |
    | 2010     | Marea     | 2     | Fwy       | 79.2%     | 11.1%     | 5.5%      | 3.5%      | 0.7%      |
    | **2038** | **Marea** | **1** | **Art**   | **28.8%** | **17.9%** | **19.6%** | **14.6%** | **19.2%** |
    | **2038** | **Marea** | **1** | **Fwy**   | **42.0%** | **16.8%** | **14.6%** | **17.8%** | **8.8%**  |
    | **2038** | **Marea** | **2** | **Art**   | **32.5%** | **18.9%** | **18.3%** | **12.9%** | **17.4%** |
    | **2038** | **Marea** | **2** | **Fwy**   | **49.0%** | **16.8%** | **13.6%** | **14.4%** | **6.2%**  |

  - *Congestion speed by road class and congestion level*:

    | Year     | Table     | Iter  | RoadClass | None      | Mod       | Hvy       | Sev     | Ext     |
    | -------- | --------- | ----- | --------- | --------- | --------- | --------- | ------- | ------- |
    | 2010     | Marea     | 1     | Art       | 720       | 597       | 565       | 537     | 497     |
    | 2010     | Marea     | 1     | Fwy       | 1,440     | 1,217     | 1,071     | 843     | 586     |
    | 2010     | Marea     | 2     | Art       | 720       | 597       | 565       | 537     | 497     |
    | 2010     | Marea     | 2     | Fwy       | 1,440     | 1,217     | 1,071     | 843     | 586     |
    | **2038** | **Marea** | **1** | **Art**   | **720**   | **600**   | **568**   | **540** | **500** |
    | **2038** | **Marea** | **1** | **Fwy**   | **1,440** | **1,225** | **1,090** | **880** | **629** |
    | **2038** | **Marea** | **2** | **Art**   | **720**   | **600**   | **568**   | **540** | **500** |
    | **2038** | **Marea** | **2** | **Fwy**   | **1,440** | **1,225** | **1,090** | **880** | **629** |

  - *Average speed by vehicle type*:

    | Year     | Table     | Iter  | Bus     | HvyTrk  | Ldv     |
    | -------- | --------- | ----- | ------- | ------- | ------- |
    | 2010     | Marea     | 1     | 594     | 896     | 792     |
    | 2010     | Marea     | 2     | 594     | 896     | 792     |
    | **2038** | **Marea** | **1** | **564** | **805** | **721** |
    | **2038** | **Marea** | **2** | **569** | **826** | **741** |

  - *Average delay by vehicle type*:

    | Year     | Table     | Iter  | Bus      | HvyTrk     | Ldv        |
    | -------- | --------- | ----- | -------- | ---------- | ---------- |
    | 2010     | Marea     | 1     | 0.26     | 23.95      | 306.44     |
    | 2010     | Marea     | 2     | 0.26     | 23.95      | 306.44     |
    | **2038** | **Marea** | **1** | **2.44** | **109.30** | **952.48** |
    | **2038** | **Marea** | **2** | **2.28** | **95.97**  | **761.61** |

  - *Light duty vehicle DVMT by road class*:

    | Year     | Table     | Iter  | VehicleType | Art           | Fwy           |
    | -------- | --------- | ----- | ----------- | ------------- | ------------- |
    | 2010     | Marea     | 1     | Ldv         | 1,380,525     | 761,202       |
    | 2010     | Marea     | 2     | Ldv         | 1,380,525     | 761,202       |
    | **2038** | **Marea** | **1** | **Ldv**     | **2,256,086** | **1,226,348** |
    | **2038** | **Marea** | **2** | **Ldv**     | **1,980,959** | **1,135,796** |

  - *Average congestion price*:

    | Year     | Table     | Iter  | AveCongPrice_USD_ |
    | -------- | --------- | ----- | ----------------- |
    | 2010     | Marea     | 1     | -                 |
    | 2010     | Marea     | 2     | -                 |
    | **2038** | **Marea** | **1** | **0.013**         |
    | **2038** | **Marea** | **2** | **0.010**         |

- *Conclusions*

  - The model works as outlined by the methodology.

### *CalculateMpgMpkwhAdjustments*

- *Expected Results*

  - There should not be any impact on the fuel efficiency due to 0% driverless vehicles.
  - **The speed smoothing factor for 0% and 100% are the same. Unsure if this should be the case**
  
- *Inputs*

  - **LdvDriverlessProp, HvyTrkDriverlessProp, and BusDriverlessProp (Datastore/Year/Marea)***:

    | Year     | Table     | Iter  | LdvDriverlessProp | HvyTrkDriverlessProp | BusDriverlessProp |
    | -------- | --------- | ----- | ----------------- | -------------------- | ----------------- |
    | 2010     | Marea     | 1     | -                 | -                    | -                 |
    | 2010     | Marea     | 2     | -                 | -                    | -                 |
    | **2038** | **Marea** | **1** | **-**             | **-**                | **-**             |
    | **2038** | **Marea** | **2** | **-**             | **-**                | **-**             |

- *Outputs*

  - *Speed smoothing factor*:

    | Year     | Table     | Iter  | LdvSpdSmoothFactor | HvyTrkSpdSmoothFactor | BusSpdSmoothFactor |
    | -------- | --------- | ----- | ------------------ | --------------------- | ------------------ |
    | 2010     | Marea     | 1     | 1.019              | 1.027                 | 1.031              |
    | 2010     | Marea     | 2     | 1.019              | 1.027                 | 1.031              |
    | **2038** | **Marea** | **1** | **1.044**          | **1.070**             | **1.063**          |
    | **2038** | **Marea** | **2** | **1.043**          | **1.066**             | **1.062**          |

  - *Eco-drive factor*:

    | Year     | Table      | Iter  | LdvEcoDriveFactor | HvyTrkEcoDriveFactor | BusEcoDriveFactor |
    | -------- | ---------- | ----- | ----------------- | -------------------- | ----------------- |
    | 2010     | Marea      | 1     | 1.075             | 1.103                | 1.128             |
    | 2010     | Marea      | 2     | 1.075             | 1.103                | 1.128             |
    | **2038** | **Marea**  | **1** | **1.085**         | **1.130**            | **1.132**         |
    | **2038** | **Marea**  | **2** | **1.083**         | **1.124**            | **1.131**         |
    | 2010     | Region     | 1     | 1.072             | 1.090                | 1.123             |
    | 2010     | Region     | 2     | 1.072             | 1.090                | 1.123             |
    | **2038** | **Region** | **1** | **1.072**         | **1.090**            | **1.123**         |
    | **2038** | **Region** | **2** | **1.071**         | **1.090**            | **1.123**         |

  - *Congestion factor*:

    | Year     | Table      | Iter  | LdIceFactor | LdHevFactor | LdEvFactor | LdFcvFactor | HdIceFactor |
    | -------- | ---------- | ----- | ----------- | ----------- | ---------- | ----------- | ----------- |
    | 2010     | Marea      | 1     | 1.013       | 1.011       | 0.994      | 0.998       | 1.017       |
    | 2010     | Marea      | 2     | 1.013       | 1.011       | 0.994      | 0.998       | 1.017       |
    | **2038** | **Marea**  | **1** | **1.000**   | **1.004**   | **0.998**  | **0.997**   | **1.000**   |
    | **2038** | **Marea**  | **2** | **1.002**   | **1.005**   | **0.997**  | **0.997**   | **1.004**   |
    | 2010     | Region     | 1     | 1.032       | 1.021       | 0.996      | 1.008       | 1.029       |
    | 2010     | Region     | 2     | 1.032       | 1.021       | 0.996      | 1.008       | 1.029       |
    | **2038** | **Region** | **1** | **1.032**   | **1.021**   | **0.996**  | **1.008**   | **1.029**   |
    | **2038** | **Region** | **2** | **1.031**   | **1.022**   | **0.995**  | **1.008**   | **1.029**   |

- *Conclusions*

  - The speed smoothing factor is the maximum value it can attain.
  - The module works based on the outlined methodology.


### *CalculateVehicleOperatingCost*

- *Expected Results*

  - The total DVMT and driverless DVMT should go up with increase in proportion of driverless vehicles.

- *Inputs*

  - ***region_driverless_vehicle_parameter.csv***

    | Year     | RunTimeUtilityAdj | AccessTimeUtilityAdj | PropRemoteAccess | RemoteAccessDvmtAdj | PropParkingFeeAvoid |
    | -------- | ----------------- | -------------------- | ---------------- | ------------------- | ------------------- |
    | 2010     | 1                 | 1                    | 0                | 1                   | 0                   |
    | **2038** | **0.85**          | **0.85**             | **0.18**         | **1.36**            | **0.18**            |

  - ***LowCarSvcDeadheadProp, HighCarSvcDeadheadProp (Datastore/Year/Azone)***:

    | Year     | Table     | LowCarSvcDeadheadProp | HighCarSvcDeadheadProp |
    | -------- | --------- | --------------------- | ---------------------- |
    | 2010     | Azone     | 0                     | 0                      |
    | **2038** | **Azone** | **0**                 | **0**                  |

- *Outputs*

  - *Proportion of household DVMT in driverless vehicles by Marea*:

    | Year     | Table     | Iter  | HhDriverlessDvmtProp |
    | -------- | --------- | ----- | -------------------- |
    | 2010     | Marea     | 1     | -                    |
    | 2010     | Marea     | 2     | -                    |
    | **2038** | **Marea** | **1** | **-**                |
    | **2038** | **Marea** | **2** | **-**                |

  - Household Table Statistics:

    | Year     | Iter  | TotalDvmt     | DriverlessDvmt | DriverlessDvmtAdj | **DeadheadDvmtAdj** | DriverlessDvmtPerc | DriverlessDvmtAdjPerc | **DeadheadDvmtAdjPerc** |
    | -------- | ----- | ------------- | -------------- | ----------------- | ------------------- | ------------------ | --------------------- | ----------------------- |
    | 2010     | 1     | 3,436,281     | -              | -                 | -                   | -                  | -                     | -                       |
    | 2010     | 2     | 3,436,281     | -              | -                 | -                   | -                  | -                     | -                       |
    | **2038** | **1** | **5,673,285** | **-**          | **-**             | -                   | **-**              | **-**                 | -                       |
    | **2038** | **2** | **5,046,303** | **-**          | **-**             | -                   | **-**              | **-**                 | -                       |

    | Year     | Iter  | AveVehCostPM  | AveSocEnvCostPM | AveRoadUseTaxPM | AveGPM       | AveKWHPM  | AveCO2ePM     |
    | -------- | ----- | ------------- | --------------- | --------------- | ------------ | --------- | ------------- |
    | 2010     | 1     | 38,962.45     | 5,451.20        | 2,305.16        | 2,946.13     | -         | 32,298.73     |
    | 2010     | 2     | 38,962.45     | 5,451.20        | 2,305.16        | 2,946.13     | -         | 32,298.73     |
    | **2038** | **1** | **70,289.35** | **6,584.38**    | **2,394.98**    | **2,236.35** | **29.37** | **19,694.72** |
    | **2038** | **2** | **73,316.05** | **6,461.03**    | **3,498.94**    | **2,166.47** | **29.44** | **19,082.03** |

  - Vehicle Table Statistic:

    | Year     | Iter  | TotalDvmt     | DriverlessDvmt | DriverlessDvmtPerc |
    | -------- | ----- | ------------- | -------------- | ------------------ |
    | 2010     | 1     | 3,708,578     | -              | -                  |
    | 2010     | 2     | 3,296,970     | -              | -                  |
    | **2038** | **1** | **5,673,285** | **-**          | **-**              |
    | **2038** | **2** | **5,046,303** | **-**          | **-**              |

- *Conclusions*

  - The module works as outlined in methodology.

### *BudgetHouseholdDvmt*

- *Expected Results*

  - There should be no significant difference in the statistics between the 0% driverless vehicle scenario and the statistic produced by the module with no driverless vehicle implementation.

- *Outputs*

  - *Marea Table Statistics*:

    | Year     | Table     | Iter  | UrbanHhDvmt   | RuralHhDvmt | TownHhDvmt | TotalDvmt     |
    | -------- | --------- | ----- | ------------- | ----------- | ---------- | ------------- |
    | 2010     | Marea     | 1     | 2,970,469     | 465,812     | -          | 3,436,281     |
    | 2010     | Marea     | 2     | 2,970,469     | 465,812     | -          | 3,436,281     |
    | **2038** | **Marea** | **1** | **4,679,421** | **366,883** | **-**      | **5,046,303** |
    | **2038** | **Marea** | **2** | **4,533,435** | **359,752** | **-**      | **4,893,188** |

  - *Household Table Statistics*:

    | Year     | Table         | Iter  | TotalDvmt     | TotalDailyGGE | TotalDailyKWH | TotalDailyCO2e |
    | -------- | ------------- | ----- | ------------- | ------------- | ------------- | -------------- |
    | 2010     | Household     | 1     | 3,436,281     | 139,421       | -             | 1,528,490      |
    | 2010     | Household     | 2     | 3,436,281     | 139,421       | -             | 1,528,490      |
    | **2038** | **Household** | **1** | **5,046,303** | **98,924**    | **1,376**     | **871,398**    |
    | **2038** | **Household** | **2** | **4,893,188** | **92,770**    | **1,339**     | **817,329**    |

    | Year     | Table         | Iter  | TotalVehTrips | TotalWalkTrips | TotalBikeTrips | TotalTransitTrips |
    | -------- | ------------- | ----- | ------------- | -------------- | -------------- | ----------------- |
    | 2010     | Household     | 1     | 382,089       | 53,123         | 4,038          | 12,904            |
    | 2010     | Household     | 2     | 382,089       | 53,123         | 4,038          | 12,904            |
    | **2038** | **Household** | **1** | **569,826**   | **83,993**     | **5,542**      | **20,123**        |
    | **2038** | **Household** | **2** | **551,335**   | **85,057**     | **5,607**      | **21,339**        |
  
- *Conclusions*

  - The module works as outlined by the methodology.