

## VEHouseholdVehicles

### *CreateVehicleTable*

- *Expected Results*
  
  - It should populate (store in Datastore) the vehicle table all the variables specified in the *azone_carsvc_characteristics.csv*.
  
- *Inputs*
  
  - ***azone_carsvc_characteristics.csv***: 
  
    | Geo       | Year     | HighCarSvcCost.2010 | LowCarSvcCost.2010 | AveCarSvcVehicleAge | LtTrkCarSvcSubProp | AutoCarSvcSubProp | LowCarSvcDeadheadProp | HighCarSvcDeadheadProp |
    | --------- | -------- | ------------------- | ------------------ | ------------------- | ------------------ | ----------------- | --------------------- | ---------------------- |
    | RVMPO     | 2010     | 1                   | 3                  | 3                   | 0.75               | 1                 | 0.1                   | 0.2                    |
    | **RVMPO** | **2038** | **1**               | **3**              | **2**               | **0.75**           | **1**             | **0.2**               | **0.4**                |
  
- *Outputs*

  - ***Datastore***:

    | Year     | HighCarSvcCost_USD_ | LowCarSvcCost_USD_ | AveCarSvcVehicleAge_DAY_ | LtTrkCarSvcSubProp_proportion_ | AutoCarSvcSubProp_proportion_ | LowCarSvcDeadheadProp_proportion_ | HighCarSvcDeadheadProp_proportion_ |
    | -------- | ------------------- | ------------------ | ------------------------ | ------------------------------ | ----------------------------- | --------------------------------- | ---------------------------------- |
    | 2010     | 1                   | 3                  | 1095                     | 0.75                           | 1                             | 0.1                               | 0.2                                |
    | **2038** | **1**               | **3**              | **730**                  | **0.75**                       | **1**                         | **0.2**                           | **0.4**                            |
  
- *Conclusion*

  - The module works because the datastore shows the expected results.



### *AssignDriverlessVehicles*

- *Expected Results*
  
  - The module should assign a value of 0 (if not driverless) , 1(if driverless and household vehicle), and  between 0 and 1 if the for household with access to car services to all household vehicles based on the driverless vehicle proportion specified in *region_driverless_vehicle_prop.csv* (input) file.
  - The module should calculate the proportion of DVMT that is in driverless vehicles.
  
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
    | **2025** | **0.03**                | **0.03**                 | **0.03**                | **0.03**                 | **0.03**             | **0.03**             | **0.03**            | **0.03**          |
    | **2030** | **0.06**                | **0.06**                 | **0.06**                | **0.06**                 | **0.06**             | **0.06**             | **0.06**            | **0.06**          |
    | **2035** | **0.12**                | **0.12**                 | **0.12**                | **0.12**                 | **0.12**             | **0.12**             | **0.12**            | **0.12**          |
    | **2040** | **0.24**                | **0.24**                 | **0.24**                | **0.24**                 | **0.24**             | **0.24**             | **0.24**            | **0.24**          |
    | **2045** | **0.48**                | **0.48**                 | **0.48**                | **0.48**                 | **0.48**             | **0.48**             | **0.48**            | **0.48**          |
    | **2050** | **0.96**                | **0.96**                 | **0.96**                | **0.96**                 | **0.96**             | **0.96**             | **0.96**            | **0.96**          |
  
- *Outputs*

  - ***Driverless (Datastore/Year/Vehicle)***:
  
    | Year     | VehicleAccess  | Driverless | Count       | Percentage |
    | :------- | :------------- | :--------- | :---------- | :--------- |
    | 2010     | Own            | -          | 121,560     | 100%       |
    | 2010     | LowCarSvc      | -          | 18,709      | 100%       |
    | **2038** | **Own**        | **-**      | **166,275** | **94%**    |
    | **2038** | **Own**        | **1.000**  | **9,936**   | **6%**     |
    | **2038** | **LowCarSvc**  | **0.144**  | **31,605**  | **100%**   |
    | **2038** | **HighCarSvc** | **0.144**  | **2,052**   | **100%**   |
  
  - ***DriverlessDvmtProp (Datastore/Year/Household)***:
    *All Households*
  
    |   Year   | Min.  | 1st Qu. | Median |   Mean   | 3rd Qu. |   Max.   |
    | :------: | :---: | :-----: | :----: | :------: | :-----: | :------: |
    |   2010   |   -   |    -    |   -    |    -     |    -    |    -     |
    | **2038** | **-** |  **-**  | **-**  | **0.05** |  **-**  | **1.00** |
  
    *Households that either own driverless vehicle or have access to high level car service*
  
    |   Year   |   Min.   | 1st Qu.  |  Median  |   Mean   | 3rd Qu.  |   Max.   |
    | :------: | :------: | :------: | :------: | :------: | :------: | :------: |
    | **2038** | **0.03** | **0.33** | **0.50** | **0.51** | **0.50** | **1.00** |
  
- *Conclusion*

  - There are about 6% of household owned vehicles are driverless. The 6% value is close to 5.8% obtained as a weighted average of the proportion of vehicles sold since 2025 until 2038 weighted by vehicle age in years.
  - All the vehicles having access to car service (either low car service or high car service) are assigned a *LowCarSvcDriverlessProp* or *HighCarSvcDriverlessProp* value based on access type.
  - On average 5% of household DVMT (consist of all households including one that do not own any driverless vehicles) is in driverless vehicles. About 51% of household DVMT on average is in driverless vehicles for households that either own driverless vehicle or have access to high level car service.



## VETravelPerformance

### *CalculateRoadDvmt*

- *Expected Results*

  - The module should calculate proportions of DVMT in driverless vehicles for following category of vehicles
  - Heavy Truck: A value between 12% and 24% for the year 2038
    - Bus: A value between 12% and 24% for the year 2038
    - Light Duty Vehicles: A value between 5% and 19.2 % for the year 2038 because it is the weighted average of proportion of household (~5%), commercial service (~19.2%), and public transit (~19.2%) DVMT in driverless vehicles.
    - Household Vehicles: A value > 0%, <100%, and close to 5%.
  
- *Inputs (Additional inputs for driverless modifications)*

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
    | 2025    | 0.03                    | 0.03                     | 0.03                    | 0.03                     | 0.03                 | 0.03                 | 0.03                | 0.03              |
    | 2030    | 0.06                    | 0.06                     | 0.06                    | 0.06                     | 0.06                 | 0.06                 | 0.06                | 0.06              |
    | 2035    | 0.12                    | 0.12                     | 0.12                    | 0.12                     | 0.12                 | 0.12                 | 0.12                | 0.12              |
    | 2040    | 0.24                    | 0.24                     | 0.24                    | 0.24                     | 0.24                 | 0.24                 | 0.24                | 0.24              |
    | 2045    | 0.48                    | 0.48                     | 0.48                    | 0.48                     | 0.48                 | 0.48                 | 0.48                | 0.48              |
    | 2050    | 0.96                    | 0.96                     | 0.96                    | 0.96                     | 0.96                 | 0.96                 | 0.96                | 0.96              |

  - ***DriverlessDvmtProp (Datastore/Year/Household)***:

    | Year     | Min.  | 1st Qu. | Median | Mean     | 3rd Qu. | Max.     |
    | -------- | ----- | ------- | ------ | -------- | ------- | -------- |
    | 2010     | -     | -       | -      | -        | -       | -        |
    | **2038** | **-** | **-**   | **-**  | **0.05** | **-**   | **1.00** |

- *Outputs*

  - *Driverless Proportion by vehicle class*
  
    | Year     | Table     | Iter  | LdvDriverlessProp | HhDriverlessDvmtProp | HvyTrkDriverlessProp | BusDriverlessProp |
    | :------- | :-------- | :---- | :---------------- | :------------------- | :------------------- | :---------------- |
    | 2010     | Marea     | 1     | -                 | -                    | -                    | -                 |
    | 2010     | Marea     | 2     | -                 | -                    | -                    | -                 |
    | **2038** | **Marea** | **1** | **0.065**         | **0.058**            | **0.192**            | **0.192**         |
    | **2038** | **Marea** | **2** | **0.089**         | **0.083**            | **0.192**            | **0.192**         |
  
- *Conclusion*

  - Around 6.5% light duty vehicle DVMT is in driverless vehicles which is the weighted sum of the proportion of driverless vehicles of household vehicles, commercial service vehicles, and public transit vehicles. This value truly falls between 5.8% (prop of household DVMT in driverless vehicles) and 19.2 % (prop of commercial service and public transit DVMT in driverless vehicles).
  - On average 5.8% of household DVMT is in driverless vehicles. This is obtained as a weighted average of proportion of DVMT in driverless vehicles weighted by household DVMT and is close to the 5% observed in the previous step.
  - The 19.2% heavy truck and bus DVMT is in driverless vehicles which is close to value of 18.2% obtained by using generating function for the year 2038.

### *CalculateRoadPerformance*

- *Expected Results*
  
  - The effect of other ops due to driverless vehicles has an impact after certain proportion of driverless vehicles based on the road class. Following image will show a glimpse of these thresholds based on the current set of inputs:
    ![Driverless Proportion vs Delay Factor](.\other_ops_driverless_factor.png)
    As the proportion of vehicles that are driverless is around 8% (weighted average based on DVMT) we should expect to see no difference in congestion metrics between the current scenario and the scenario where the proportion of driverless vehicles is 0.
  
- *Inputs (Additional or modified for driverless vehicles)*
  
  - ***other_ops_effectiveness.csv*** *(modified)*:
  
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
    | **2038** | **Marea** | **1** | **0.065**         | **0.192**            | **0.192**         |
    | **2038** | **Marea** | **2** | **0.089**         | **0.192**            | **0.192**         |
  
- *Outputs*

  - *Proportion of congestion by road class and congestion level*:

    | Year     | Table     | Iter  | RoadClass | None      | Mod       | Hvy       | Sev       | Ext       |
    | :------- | :-------- | :---- | :-------- | :-------- | :-------- | :-------- | :-------- | :-------- |
    | 2010     | Marea     | 1     | Art       | 51.6%     | 19.0%     | 13.3%     | 7.4%      | 8.6%      |
    | 2010     | Marea     | 1     | Fwy       | 79.2%     | 11.1%     | 5.6%      | 3.5%      | 0.7%      |
    | 2010     | Marea     | 2     | Art       | 51.6%     | 19.0%     | 13.3%     | 7.4%      | 8.6%      |
    | 2010     | Marea     | 2     | Fwy       | 79.2%     | 11.1%     | 5.6%      | 3.5%      | 0.7%      |
    | **2038** | **Marea** | **1** | **Art**   | **28.8%** | **17.8%** | **19.6%** | **14.6%** | **19.2%** |
    | **2038** | **Marea** | **1** | **Fwy**   | **42.0%** | **16.8%** | **14.6%** | **17.9%** | **8.8%**  |
    | **2038** | **Marea** | **2** | **Art**   | **31.4%** | **18.7%** | **18.7%** | **13.3%** | **17.9%** |
    | **2038** | **Marea** | **2** | **Fwy**   | **47.4%** | **16.9%** | **13.9%** | **15.2%** | **6.8%**  |

  - *Congestion speed by road class and congestion level*:

    | Year     | Table     | Iter  | RoadClass | None      | Mod       | Hvy       | Sev     | Ext     |
    | :------- | :-------- | :---- | :-------- | :-------- | :-------- | :-------- | :------ | :------ |
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
    | :------- | :-------- | :---- | :------ | :------ | :------ |
    | 2010     | Marea     | 1     | 594     | 896     | 792     |
    | 2010     | Marea     | 2     | 594     | 896     | 792     |
    | **2038** | **Marea** | **1** | **564** | **805** | **721** |
    | **2038** | **Marea** | **2** | **567** | **821** | **736** |

  - *Average delay by vehicle type*:

    | Year     | Table     | Iter  | Bus      | HvyTrk     | Ldv        |
    | :------- | :-------- | :---- | :------- | :--------- | :--------- |
    | 2010     | Marea     | 1     | 0.26     | 24.05      | 307.64     |
    | 2010     | Marea     | 2     | 0.26     | 24.05      | 307.64     |
    | **2038** | **Marea** | **1** | **2.44** | **109.09** | **954.42** |
    | **2038** | **Marea** | **2** | **2.33** | **99.00**  | **806.41** |

  - *Light duty vehicle DVMT by road class*:

    | Year     | Table     | Iter  | VehicleType | Art           | Fwy           |
    | :------- | :-------- | :---- | :---------- | :------------ | :------------ |
    | 2010     | Marea     | 1     | Ldv         | 1,382,718     | 762,431       |
    | 2010     | Marea     | 2     | Ldv         | 1,382,718     | 762,431       |
    | **2038** | **Marea** | **1** | **Ldv**     | **2,259,778** | **1,227,327** |
    | **2038** | **Marea** | **2** | **Ldv**     | **2,043,711** | **1,157,705** |

  - *Average congestion price*:

    | Year     | Table     | Iter  | AveCongPrice_USD_ |
    | :------- | :-------- | :---- | :---------------- |
    | 2010     | Marea     | 1     | -                 |
    | 2010     | Marea     | 2     | -                 |
    | **2038** | **Marea** | **1** | **0.013**         |
    | **2038** | **Marea** | **2** | **0.011**         |

- *Conclusions*

  - The proportion of driverless vehicles is small to make any noticeable impact on the congestion metrics. The results do not show any big difference between the values observed in the current scenario and the scenario with 0% driverless vehicles.

### *CalculateMpgMpkwhAdjustments*

- *Expected Results*
  
  - The effect of other ops due to driverless vehicles should have an impact after certain proportion of driverless vehicles. This impact should be directly seen on the speed smoothing factors. Thus, we should observe a change in speed smoothing factor. The speed smoothing factors should be closer to 1 since the proportion of driverless vehicles in the current scenario is low (~8%).
    There's one *issue*:
  - **The speed smoothing factor for 100% driverless vehicles and 0% driverless vehicles are the same. I am not sure if that is the intention.**
  - The addition of driverless vehicles should have a minimal effect on the eco-drive factors and the congestion factors.
  
- *Inputs*
  
  - ***LdvDriverlessProp, HvyTrkDriverlessProp, and BusDriverlessProp (Datastore/Year/Marea)***:
  
    | Year     | Table     | Iter  | LdvDriverlessProp | HvyTrkDriverlessProp | BusDriverlessProp |
    | -------- | --------- | ----- | ----------------- | -------------------- | ----------------- |
    | 2010     | Marea     | 1     | -                 | -                    | -                 |
    | 2010     | Marea     | 2     | -                 | -                    | -                 |
    | **2038** | **Marea** | **1** | **0.065**         | **0.192**            | **0.192**         |
    | **2038** | **Marea** | **2** | **0.089**         | **0.192**            | **0.192**         |
  
- *Outputs*

  - *Speed smoothing factor*:
  
    | Year     | Table     | Iter  | LdvSpdSmoothFactor | HvyTrkSpdSmoothFactor | BusSpdSmoothFactor |
    | :------- | :-------- | :---- | :----------------- | :-------------------- | :----------------- |
    | 2010     | Marea     | 1     | 1.000              | 1.000                 | 1.000              |
    | 2010     | Marea     | 2     | 1.000              | 1.000                 | 1.000              |
    | **2038** | **Marea** | **1** | **1.000**          | **1.000**             | **1.000**          |
    | **2038** | **Marea** | **2** | **1.000**          | **1.000**             | **1.000**          |
    
  - *Eco-drive factor*:
  
    | Year     | Table      | Iter  | LdvEcoDriveFactor | HvyTrkEcoDriveFactor | BusEcoDriveFactor |
    | :------- | :--------- | :---- | :---------------- | :------------------- | :---------------- |
    | 2010     | Marea      | 1     | 1.075             | 1.103                | 1.128             |
    | 2010     | Marea      | 2     | 1.075             | 1.103                | 1.128             |
    | **2038** | **Marea**  | **1** | **1.085**         | **1.130**            | **1.132**         |
    | **2038** | **Marea**  | **2** | **1.083**         | **1.125**            | **1.131**         |
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
    | **2038** | **Marea**  | **2** | **1.002**   | **1.005**   | **0.997**  | **0.997**   | **1.003**   |
    | 2010     | Region     | 1     | 1.032       | 1.021       | 0.996      | 1.008       | 1.029       |
    | 2010     | Region     | 2     | 1.032       | 1.021       | 0.996      | 1.008       | 1.029       |
    | **2038** | **Region** | **1** | **1.032**   | **1.021**   | **0.996**  | **1.008**   | **1.029**   |
    | **2038** | **Region** | **2** | **1.032**   | **1.022**   | **0.996**  | **1.008**   | **1.029**   |
  
- *Conclusions*

  - The speed smoothing factors are closer to 1 as expected.
  - The eco-drive factors and congestion factors remain unchanged compared to 0% driverless vehicles scenario.
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
    | 2010     | Azone     | 0.1                   | 0.2                    |
    | **2038** | **Azone** | **0.2**               | **0.4**                |

- *Outputs*

  - *Proportion of household DVMT in driverless vehicles by Marea*:
  
    | Year     | Table     | Iter  | HhDriverlessDvmtProp |
    | -------- | --------- | ----- | -------------------- |
    | 2010     | Marea     | 1     | -                    |
    | 2010     | Marea     | 2     | -                    |
    | **2038** | **Marea** | **1** | **0.087**            |
    | **2038** | **Marea** | **2** | **0.085**            |
  
  - Household Table Statistics:
  
    | Year     | Iter  | TotalDvmt     | DriverlessDvmt | DriverlessDvmtAdj | DeadheadDvmtAdj | DriverlessDvmtProp | DriverlessDvmtAdjProp | DeadheadDvmtAdjProp | AveVehCostPM |
    | :------- | :---- | :------------ | :------------- | :---------------- | :-------------- | :----------------- | :-------------------- | :------------------ | :----------- |
    | 2010     | 1     | 3,420,294     | 0              | 0                 | 0               | 0.00%              | 0.00%                 | 0.00%               | 40201.74     |
    | 2010     | 2     | 3,420,294     | 0              | 0                 | 0               | 0.00%              | 0.00%                 | 0.00%               | 40201.74     |
    | **2038** | **1** | **5,818,196** | **488,967**    | **114,551**       | **50,776**      | **8.40%**          | **1.97%**             | **0.87%**           | **70571.04** |
    | **2038** | **2** | **5,164,111** | **428,393**    | **101,656**       | **32,336**      | **8.30%**          | **1.97%**             | **0.63%**           | **73634.06** |
  
    | Year     | Iter  | AveVehCostPM  | AveSocEnvCostPM | AveRoadUseTaxPM | AveGPM       | AveKWHPM  | AveCO2ePM     |
    | :------- | :---- | :------------ | :-------------- | :-------------- | :----------- | :-------- | :------------ |
    | 2010     | 1     | 40,201.74     | 5,532.11        | 2,319.36        | 3,009.73     | 0.00      | 32,995.98     |
    | 2010     | 2     | 40,201.74     | 5,532.11        | 2,319.36        | 3,009.73     | 0.00      | 32,995.98     |
    | **2038** | **1** | **70,571.04** | **6,612.50**    | **2,410.44**    | **2,252.19** | **29.73** | **19,834.64** |
    | **2038** | **2** | **73,634.06** | **6,529.55**    | **3,569.13**    | **2,205.19** | **29.80** | **19,422.67** |
  
  - Vehicle Table Statistic:
  
    | Year     |  Iter | TotalDvmt     | DriverlessDvmt | DriverlessDvmtProp |
    | :------- | ----: | :------------ | :------------- | :----------------- |
    | 2010     |     1 | 3,420,294     | -              | -                  |
    | 2010     |     2 | 3,420,294     | -              | -                  |
    | **2038** | **1** | **5,818,196** | **488,967**    | **8.40%**          |
    | **2038** | **2** | **5,164,111** | **428,393**    | **8.30%**          |
  
- *Conclusions*

  - The module works as outlined in methodology.

### *BudgetHouseholdDvmt*

- *Expected Results*

  - With increase in total DVMT due to additional driverless miles there should be an increase in power consumption.
  - There should be an increase vehicle trips due to additional driverless DVMT.
  - There should be a decrease in alt mode trips due to more vehicle travel budget spent on additional vehicle trips.

- *Outputs*

  - *Marea Table Statistics*

    | Year     | Table     | Iter  | UrbanHhDvmt   | RuralHhDvmt | TownHhDvmt | TotalDvmt     |
    | :------- | :-------- | :---- | :------------ | :---------- | :--------- | :------------ |
    | 2010     | Marea     | 1     | 2,953,810     | 466,484     | -          | 3,420,294     |
    | 2010     | Marea     | 2     | 2,953,810     | 466,484     | -          | 3,420,294     |
    | **2038** | **Marea** | **1** | **4,790,061** | **375,384** | **-**      | **5,165,445** |
    | **2038** | **Marea** | **2** | **4,631,675** | **367,506** | **-**      | **4,999,181** |
    
  - *Household Table Statistics*

    | Year     | Table         | Iter  | TotalDvmt     | TotalDailyGGE | TotalDailyKWH | TotalDailyCO2e |
    | :------- | :------------ | :---- | :------------ | :------------ | :------------ | :------------- |
    | 2010     | Household     | 1     | 3,420,294     | 141,950       | -             | 1,556,210      |
    | 2010     | Household     | 2     | 3,420,294     | 141,950       | -             | 1,556,210      |
    | **2038** | **Household** | **1** | **5,165,445** | **101,768**   | **1,411**     | **896,441**    |
    | **2038** | **Household** | **2** | **4,999,181** | **96,271**    | **1,371**     | **848,120**    |

    | Year     | Table         | Iter  | TotalVehTrips | TotalWalkTrips | TotalBikeTrips | TotalTransitTrips |
    | :------- | :------------ | :---- | :------------ | :------------- | :------------- | :---------------- |
    | 2010     | Household     | 1     | 380,694       | 53,401         | 4,049          | 13,075            |
    | 2010     | Household     | 2     | 380,694       | 53,401         | 4,049          | 13,075            |
    | **2038** | **Household** | **1** | **580,110**   | **83,794**     | **5,529**      | **20,002**        |
    | **2038** | **Household** | **2** | **560,251**   | **84,966**     | **5,600**      | **21,396**        |

- *Conclusions*

  - In comparison with the scenario with 0% driverless vehicles
    - There is an increase in the number of vehicle trips as expected, and
    - There is a decrease in the number of alt mode trips.

