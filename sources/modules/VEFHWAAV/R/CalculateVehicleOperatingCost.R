#==================================
#CalculateHhVehicleOperatingCosts.R
#==================================

#<doc>
#
## CalculateHhVehicleOperatingCosts Module
#### June 5, 2020
#
#This module calculates vehicle operating costs per mile of travel and uses those costs to determine the proportional split of DVMT among household vehicles. The module also calculates the average out-of-pocket costs per mile of vehicle travel by household, as well as the cost of social and environmental impacts, and road use taxes per mile of vehicle travel. Three operating costs are calculated:
#
#* *Out-of-pocket cost* to use the vehicle including fuel (energy), maintenance/tires/repairs, road use taxes, pollution taxes (e.g. carbon tax), parking charges, and pay-as-you-drive insurance cost;
#* *Social/environmental costs* including air pollution, water pollution, and energy security costs; and,
#* *Composite cost* which is the sum of the out-of-pocket cost and the monetary equivalent for the time spend accessing and traveling in the vehicle. The module reflects the presence of driverless vehicles by adjusting these costs.
#
# The effect of driverless vehicles on these costs are accounted by allowing the following for driverless vehicles:
#* lower travel time disutility;
#* lower access time;
#* parking fee avoidance;
#* additional DVMT; and
#* deadhead mileage for car services.
#
### Model Parameter Estimation
#
#This section describes the model for splitting household DVMT among household vehicles as a function of the unit cost of using each vehicle. It also describes the estimation of model parameters for calculating cost components.
#
#### Model for Splitting DVMT among Household Vehicles
#
#The model for splitting DVMT among household vehicles is assumed to be a Cobb-Douglas utility function where the total utility is as follows for a household owning 2 vehicles:
#
#![](vehicle_use_utility_eq1.png)
#
#**Equation 1. Cobb-Douglas Utility for 2-Vehicle Household**
#
#Where:
#*  *U* is the utility
#*  *X* and *Y* are the miles driven in vehicles *X* and *Y*
#*  *a* and *b* are exponents that determine the relative utilities of miles driven in vehicles *X* and *Y*
#
#The values of *X* and *Y* are subject to the following budget constraint:
#
#![](budget_constraint_eq2.png)
#
#**Equation 2. Budget Constraint for 2-Vehicle Household**
#
#Where:
#*  *B* is the vehicle travel budget
#*  *Px* and *Py* are the prices (i.e. unit costs) of travel by vehicles *X* and *Y* respectively
#
#The prices (unit costs) of travel by each vehicle are calculated as composite costs which combine out-of-pocket costs and travel time costs. The out-of-pocket unit costs for households (dollars / mile) are calculated as the sum of the unit costs for the following:
#
#*  Fuel (energy),
#*  Mainance, tires and repairs,
#*  Road use taxes,
#*  Pollution taxes (e.g. carbon tax),
#*  Parking charges, and
#*  Pay-as-you-drive insurance cost.
#
#The out-of-pocket costs for using high and low level car services are the assumed rates (dollars / mile) which are user inputs.
#
#The equivalent travel time unit cost is calculated as follows:
#
#![](time_cost_eq3.png)
#
#**Equation 3. Calculation of Equivalent Time Cost Per Mile**
#
#Where:
#*  *TimeCost* is the equivalent time unit cost in dollars per mile
#*  *AveSpeed* is the average vehicle travel speed (miles per hour) calculated for the household
#*  *AccessTime* is the average amount of time spent on each end of the vehicle trip to get from the origin to the vehicle and from the vehicle to the destination (user input for household vehicles and car service vehicles by service level)
#*  *Trips* is the average number of daily vehicle trips of the household
#*  *DVMT* is the average daily vehicle miles traveled of the household
#*  *VOT* is the value-of-time (a model parameter)
#
# The equivalent travel time unit cost for driverless vehicles are calculated by making following adjustments to the above equation
#
#* Adjusting the utility of travel time
#
#![](driverless_run_time_utility.png)
#
#**Equation 4. Adjustment of travel time utility for driverless vehicles**
#
#Where:
#*  *AveSpeed* is the average vehicle travel speed (miles per hour) calculated for the household
#*  *RunTimeUtilityAdj* is the travel time utility adjustment for driverless vehicles provided by user as input in *region_driverless_vehicle_parameters.csv*
#
#* Adjusting the access time utility
#
#![](driverless_access_time_utility.png)
#
#**Equation 5. Adjustment of access time utility for driverless vehicles**
#
#Where:
#*  *AccessTime* is the average amount of time spent on each end of the vehicle trip to get from the origin to the vehicle and from the vehicle to the destination (user input for household vehicles and car service vehicles by service level)
#*  *Trips* is the average number of daily vehicle trips of the household
#*  *DVMT* is the average daily vehicle miles traveled of the household
#*  *PropRemoteAccess* is the proportion of trips in driverless vehicles that are remotely controlled provided by user as input in *region_driverless_vehicle_parameters.csv*
#*  *AccessTimeUtilityAdj* is the access time utility adjustment for driverless vehicles provided by user as input in *region_driverless_vehicle_parameters.csv*
#
#The values of *X* and *Y*, the miles traveled by each vehicle, are calculated by determining the values that maximize utility subject to the budget constraint. The calculation is simplified by assuming that the values of *a* and *b* are 1. In other words, it is assumed that all household vehicles provide that same travel utility to the household independent of price. Factors like comfort, convenience, performance, dependability, and style that may affect percieved utility are not considered for the following reasons:
#
#*  The model includes a limited number of vehicle characteristics (auto or light truck, age, powertrain) that may be weakly related to the vehicle attributes that affect perceived vehicle utility; and,
#
#*  Estimation vehicle utility is complicated by how vehicles may be allocated among household members. For example, an older and less valuable vehicle may be primarily used by a young adult in the household who drives a lot whereas a newer and more valuable vehicle might be driven by an older adult who drives less.
#
#Future researchers may be able to determine reasonable exponents which better represent perceived household utility (independent of price) but until that is done, the most sensible approach is to assume that a household percieves the relative utilities of travel in their vehicles (independent of price) to be the same.
#
#Economic theory can be applied to determine how travel is allocated between the vehicles *X* and *Y* given a budget constraint. Utility will be maximized when the marginal rate of substitution (MRS) is equal to the the price ratio. The marginal rate of substitution is the marginal utility of *X* (partial derivative of U with respect to X) divided by the marginal utility of *Y*. In the case of the asserted utility, the relationship is as follows:
#
#![](mrs_eq4.png)
#
#**Equation 6. Marginal Rate of Substitution and Price Ratio**
#
#The implication of Equation 4 is that the utility of using the 2 household vehicles will be maximized when the value of *X* times the price of *X* is equal to the value of *Y* times the price of *Y*:
#
#![](quantity_price_relationship_eq5.png)
#
#**Equation 7. Quantity-Price Relationship Which Maximizes Utility**
#
#The values of *X* and *Y* can be replaced by a constant *K* times the reciprocal of the price so that the equality is shown in Equation 6 and Equation 7:
#
#![](reciprocal_price_relation_eq6.png)
#
#**Equation 8. Utility Maximizing Quantity Replaced by Constant and Reciprocal of Price**
#
#![](reciprocal_price_relation_eq7.png)
#
#**Equation 9. Replacing Reciprocal of Price**
#
#Given that the DVMT of each vehicle can be calculated as a constant multiplied by a reciprocal of price, total DVMT (*T*) is calculated as follows:
#
#![](total_dvmt_eq8.png)
#
#**Equation 10. Total DVMT of 2-Vehicle Household**
#
#The proportion of DVMT allocated to each vehicle is therefore the ratio of *K* and *T* times the reciprocal of price.
#
#![](dvmt_proportions_eq9.png)
#
#**Equation 11. Proportional Allocation of DVMT**
#
#Finally since the ratio of *K* and *T* is equal to the inverse of the sum of the price reciprocals, the utility maximixing proportion of household DVMT allocated to a household vehicle is the reciprocal of the the price (i.e. unit cost) of using that vehicle divided by the sum of the price reciprocals of all household vehicles. This relationship holds for any number of household vehicles.
#
#![](dvmt_proportions_eq10.png)
#
#**Equation 12. Utility Maximizing Proportion of Household DVMT Allocated to a Vehicle**
#
#### Models for Calculating Out-of-pocket Costs
#
#Most of the out-of-pocket cost calculations are simple products of rates that are user inputs and quantities consumed or produced by each vehicle. For example:
#
#* Fuel cost per mile is the product of the input fuel cost exclusive of taxes and the vehicle fuel consumption rate (gallons per mile)
#
#* Fuel tax per mile is the product of the input fuel tax and the vehicle fuel consumption rate
#
#* Mileage tax is the mileage tax rate
#
#* The pay-as-you-drive (PAYD) insurance cost rate for households which have PAYD insurance is the household vehicle insurance cost calculated by the CalculateVehicleOwnCost module divided by total household DVMT
#
#Model cost parameters are estimated for maintenance, repair, and tire (MRT) costs and for social costs as described below.
#
##### Maintenance, Repair, and Tire Cost
#
#A model is developed for calculating vehicle maintenance, repair, and tire cost as a function of the vehicle type and age using data from the American Automobile Association (AAA) and the Bureau of Labor Statistics (BLS). AAA publishes reports yearly on the cost of vehicle use by vehicle type over the first 5 years of the vehicle's life. The AAA vehicle types are small sedan, medium sedan, large sedan, small SUV, medium SUV, minivan, pickup truck, hybrid vehicle, electric vehicle. These reports, in addition to estimating the total cost per mile, split out cost estimates by category. Vehicle maintenance, repair, and tire (MRT) cost is one of the categories. The 2017 report, a copy of which is included as the '17-0013_Your-Driving-Costs-Brochure-2017-FNL-CX-1.pdf' file in the 'inst/extdata/sources' directory of this package, is used to calculate baseline MRT cost for the following vehicle and powertrain types by calculating mean values of corresponding AAA vehicle types as shown in the following table. Cost is shown to the nearest tenth of a cent.
#
#|Vehicle Type|Powertrain|AAA Types|Cents/Mile|
#|---|---|---|
#|Auto|ICEV|Small Sedan, Medium Sedan, Large Sedan|7.7|
#|Light Truck|ICEV|Small SUV, Medium SUV, Minivan, Pickup Truck|8.1|
#|Auto, Light Truck|HEV, PHEV|Hybrid Vehicle|7.0|
#|Auto, Light Truck|BEV|Electric Vehicle|6.6|
#
#**Table 1. Correspondence Between Vehicle and Powertrain Types and AAA Vehicle Types and Average Mileage Cost (2017)**
#
#Data from a BLS report, "Beyond the Numbers, Prices and Spending, Americans' Aging Autos, BLS, May 2014, Vol.3/No.9", are used to establish the relationship between MRT cost and vehicle age. A copy of the report is included as the 'americans-aging-autos.pdf' file in the 'inst/extdata/sources' directory of this package. This report includes estimates of average MRT cost by vehicle age category for all household vehicles. Table 2. shows the MRT costs ($2012) by vehicle age category and the ratio to the 0-5 year age group cost.
#
#<tab:OpCosts_ls$BLSOpCost_df>
#
#**Table 2. Household Vehicle Operating Cost by Vehicle Age**
#
#The MRT costs by vehicle type and age are calculated as the outer product of the AAA costs by vehicle type and the BLS ratio of MRT cost by vehicle age. Since the BLS data don't distinguish between vehicle types, it is assumed that the effect of age on MRT expenses is the same for all vehicle types. The results are shown in Table 3.
#
#<tab:OpCosts_ls$VehCostByAgeAndType_df>
#
#**Table 3. 2017 Household Vehicle Maintenance, Repair, and Tire Cost (Cents/Mile)**
#
##### Social Costs
#
#Social costs are costs borne by present and future generations due to the impacts of transportation. For example, transportation emissions increase the incidence of asthma and other lung diseases and impose costs to affected individuals in terms of reduced life expectancy, reduced quality of life, and increased medical treatments. Typically vehicle users do not compensate society for these costs, but increasingly economists and others interested in transportation policy are proposing that social costs be included in vehicle pricing to reduce unwanted outcomes. For example, carbon pricing has been proposed at the state and federal level to reduce carbon-dioxide emissions which are increasing global temperatures and causing increased damages from extreme weather, flooding, drought, etc.
#
#The CalculateVehicleOperatingCost module calculates social costs in two categories: climate change related costs, and other social costs. This categorization is used because carbon pricing is a policy option that is being seriously considered by many policy-makers, and so the module enables users to calculate the effects of carbon pricing by proposed carbon price as a scenario input. Although the rationale for charging users for other social costs is similar, policy proposals to do this are uncommon and so these costs are lumped together. Users may specify separately the proportions of climate change costs and social costs paid by vehicle travelers.
#
#The module estimates default climate change costs but also allows users to provide inputs that override the default values. The default values are from "Technical Support Document: Technical Update of the Social Cost of Carbon for Regulatory Impact Analysis Under Executive Order 12866, Interagency Working Group on Social Cost of Greenhouse Gases, United States Government, August 2016". A copy of the report is included as the 'sc_co2_tsd_august_2016.pdf' file in the 'inst/extdata/sources' directory of this package. Carbon costs are estimated by year and assumed discount rate scenarios: 5%, 3%, 2.5%. In addition, they are calculated for a lower probability but higher impact scenario. Table 4 shows the estimated cost of carbon in 2007 dollars per metric ton of CO2.
#
#<tab:OpCosts_ls$CO2eCost_df>
#
#**Table 4. Social Cost of CO2, 2010 – 2050 (in 2007 dollars per metric ton of CO2)**
#
#The default carbon costs used in the model are the values listed for the 3% discount rate. These are the default values recommended for use by the interagency working group. Users may provide inputs to override these values.
#
#Values for other social costs are derived from a white paper prepared for the Oregon Department of Transportation (ODOT) to support the development of ODOT's statewide transportation strategy for reducing greenhouse gas emissions from the transportation sector. This paper is included as the 'STS_White_Paper_on_External_Costs_9-21-2011.pdf' file in the 'inst/extdata/sources' directory of this package. Table 5 shows unit costs by type in 2010 dollars.
#
#<tab:OpCosts_ls$OtherExtCost_df>
#
### How the Module Works
#
#Following are the steps for calculating vehicle costs, allocating household DVMT among household vehicles, and calculating related performance measures.
#
#* **Revise household DVMT**: Remove added driverless DVMT and the car service deadhead DVMT, if any, were added in previous iterations to household DVMT.
#
#* **Calculate maintenance, repair, and tire (MRT) cost**: The MRT cost for each vehicle is selected from Table 3 based on the vehicle type, powertrain, and age.
#
#* **Fuel and energy cost**: The fuel energy cost per mile is calculated by multiplying the fuel cost ($/gallon) by the fuel consumption rate (gallons/mile). The electric energy cost per mile is calculated similarly; electricity cost ($/KWH) times electricity consumption rate (KWH/mile). The composite cost for each vehicle is calculated as a weighted average where the fuel and electricity costs per mile are weighted by the proportions of vehicle DVMT powered by fuel and electricity respectively.
#
#* **Vehicle use taxes**: Fuel tax is computed by multiplying the fuel tax rate ($/gallon by the fuel consumption rate (gallons/mile)). An equivalent fuel tax for electric vehicles is calculated by calculating the average fuel tax for all vehicles and multiplying by the user input for plug-in vehicle surcharge tax proportion (can be a value between 0 and 1). The composite cost of fuel and electricity surcharge taxes is calculated as a weighted average where the weights are the proportions of DVMT powered by fuel and electricity. Mileage tax (i.e. VMT tax) is a user input. Congestion tax is calculated from the average congestion price ($/mile) calculated for travel in urban roads in the marea multiplied by the proportion of household travel occurring on urban roads. In addition, if the BalanceRoadCostsAndRevenues module is run so that an extra VMT tax is calculated to balance road costs and revenues, that tax is added.
#
#* **Carbon tax**: The respective fuel and electricity carbon emissions rates (grams/mile) for each vehicle are averaged using the proportions of DVMT powered by fuel and by electricity as the weights. The rates are converted to tonne/mile and multiplied by the carbon price (dollars/tonne) to estimate the social cost of carbon emissions. The social cost is multiplied by the user input on the proportion paid by users to calculate the user cost per mile.
#
#* **Other social costs**: The 'energy security' cost component (dollars/gallon) is multiplied by the vehicle fuel consumption rate (gallons/mile) and the proportion of the vehicle DVMT powered by fuel to calculate an equivalent rate per mile. This cost rate and the other social cost component rates are summed to calculate a total other social cost rate per mile. This value is multiplied by the user input for the proportion of other social costs paid by the user to calculate the user cost per mile.
#
#* **Parking cost**: Parking cost is calculated from the household work parking cost and other parking cost. The residential parking cost is not counted because it is included in the vehicle ownership cost calculations. The total daily work parking cost for each household is the sum of parking costs of workers who pay for parking (see AssignParkingRestrictions module). The other parking cost (i.e. cost of parking for shopping) is the average daily rate assigned each household (see AssignParkingRestrictions) normalized by the ratio of household vehicle trips and the average number of trips of all households. The daily work and other parking costs for the household are summed and divided by the household DVMT to get the average cost per mile. This is applied to all household vehicles.The parking fee for driverless vehicles is then calculated by multiplying the ParkingFeeAvoidance parameter with parking costs calculated in the earlier step.
#
#* **Pay-as-you-drive (PAYD) insurance**: For households who have PAYD insurance, the average rate (dollars/mile) for the household is calculated by summing the annual insurance cost for all the household vehicles and dividing by the annual VMT for the household. This rate is applied uniformly to all of the household's vehicles.
#
#* **Car-service cost**: The cost of using a car service (dollars/mile) is a user input by car service level (low, high).
#
#* **Cost equivalent of travel time (driverless effect)**: An average vehicle travel rate (hours/mile) is calculated and converted into an equivalent dollar value using Equation 3 with the modification detailed in Equation 4 and Equation 5.
#
#* **Calculate composite cost rate**: The out-of-pocket cost rates are summed with the cost equivalent travel time to arrive at a composite cost rate.
#
#* **Allocate household DVMT to vehicles**: The proportion of household DVMT allocated to each vehicle is calculated using Equation 10.
#
#* **Cost equivalent of travel time (w/o driverless effect)**: An average vehicle travel rate (hours/mile) is calculated and converted into an equivalent dollar value using Equation 3.
#
#* **Calculate added passenger DVMT**: The increase in DVMT for driverless vehicle is equivalent to percentage increase in cost equivalent of travel time w/o utility adjustment for driverless vehicles when compared to one with the adjustments for driverless vehicles.
#
#* **Calculate remote access DVMT**: For driverless vehicles the remote access DVMT is calculated as a product of vehicle DVMT, PropRemoteAccess, and RemoteAccessDvmtAdj.
#
#* **Calculate car service deadhead DVMT**: For driverless vehicle with access type either low or high the deadhead DVMT is calculated by using respective deadhead proportions provided as input by user in *region_driverless_vehicle_parameters.csv*.
#
#* **Re-calculate vehicle DVMT**: The vehicle DVMT is adjusted by summing initial allocation of DVMT and the driverless vehicle and car service deadhead adjustments.
#
#* **Re-calculate DVMT split between household vehicles**: The DVMT split between household vehicles is re-calculated using vehicle DVMT calculated in the previous step.
#
#* **Calculate household averages**: Once household DVMT proportions have been computed for each vehicle, household average values can be computed. These include:
#
#   * Average out-of-pocket travel cost rate (dollars/mile): this is used in the household travel budget model which adjust for deadhead mileage
#
#   * Average social impacts cost (dollars/mile): this is a performance measure
#
#   * Average road use tax rate (dollars/mile): this is used in calculations to balance road costs and revenues
#
#   * Average fuel consumption rate (gallons/mile): this is a performance measure
#
#   * Average electric energy consumption rate (KWH/mile): this is a performance measure
#
#   * Average carbon emissions rate (grams CO2e/mile): this is a performance measure
#
#* **Re-calculate total household DVMT**: The DVMT for the households is re-calculated by summing up the household vehicles DVMT calculated in the earlier step.
#
#</doc>


#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================

#------------------------------------------------------------
#Establish deflators to convert all money values to same year
#------------------------------------------------------------
#Load table of deflators
#Specify input file attributes
Inp_ls <- items(
  item(
    NAME = "Year",
    TYPE = "character",
    PROHIBIT = "NA",
    ISELEMENTOF = c("2007", "2010", "2012", "2017"),
    UNLIKELY = "",
    TOTAL = ""
  ),
  item(
    NAME = "Value",
    TYPE = "double",
    PROHIBIT = c("NA", "<= 0"),
    ISELEMENTOF = "",
    UNLIKELY = "",
    TOTAL = ""
  )
)
#Load and process climate change cost data
#Cost data are in year 2010 dollars
Deflators_df <-
  processEstimationInputs(
    Inp_ls,
    "deflators.csv",
    "CalculateVehicleOperatingCost.R")
Deflators_Yr <- Deflators_df$Value
names(Deflators_Yr) <- Deflators_df$Year
rm(Inp_ls, Deflators_df)


#-----------------------------------------------
#Vehicle maintenance, repair and tire cost model
#-----------------------------------------------
#Vehicle operating cost data from the American Automobile Association (AAA) and
#from the Bureau of Labor Statistics (BLS) are used to estimate a model of
#vehicle maintenance, repair, and tire cost by vehicle type and age.

#AAA vehicle maintenance, repair, and tire cost data
#---------------------------------------------------
#Specify input file attributes
Inp_ls <- items(
  item(
    NAME = "VehicleType",
    TYPE = "character",
    PROHIBIT = "NA",
    ISELEMENTOF = c(
      "SmallSedan",
      "MediumSedan",
      "LargeSedan",
      "SmallSUV",
      "MediumSUV",
      "Minivan",
      "PickupTruck",
      "HybridCar",
      "ElectricCar"
    ),
    UNLIKELY = "",
    TOTAL = ""
  ),
  item(
    NAME = "CentsPerMile",
    TYPE = "double",
    PROHIBIT = c("NA", "<= 0"),
    ISELEMENTOF = "",
    UNLIKELY = "",
    TOTAL = ""
  )
)
#Load and process AAA vehicle maintenance, repair, and tire cost data
#Cost data are for the year 2017
AAAOpCost_df <-
  processEstimationInputs(
    Inp_ls,
    "aaa_vehicle_operating_costs.csv",
    "CalculateVehicleOperatingCost.R")
AAAOpCost_ <- c(
  AutoIcev = mean(AAAOpCost_df$CentsPerMile[AAAOpCost_df$VehicleType %in% c("SmallSedan", "MediumSedan", "LargeSedan")]),
  LtTrkIcev = mean(AAAOpCost_df$CentsPerMile[AAAOpCost_df$VehicleType %in% c("SmallSUV", "MediumSUV", "Minivan", "PickupTruck")]),
  Hev = AAAOpCost_df$CentsPerMile[AAAOpCost_df$VehicleType == "HybridCar"],
  Bev = AAAOpCost_df$CentsPerMile[AAAOpCost_df$VehicleType == "ElectricCar"]
)
#Convert from cents per mile to dollars per mile
AAAOpCost_ <- AAAOpCost_ / 100
rm(Inp_ls, AAAOpCost_df)

#BLS vehicle maintenance, repair, and tire cost data
#---------------------------------------------------
#Specify input file attributes
Inp_ls <- items(
  item(
    NAME = "VehicleAge",
    TYPE = "character",
    PROHIBIT = "NA",
    ISELEMENTOF = c(
      "Age0to5",
      "Age6to10",
      "Age11to15",
      "Age16to20",
      "Age21to25",
      "Age26Plus",
      "Average"
    ),
    UNLIKELY = "",
    TOTAL = ""
  ),
  item(
    NAME = "DollarsPerYear",
    TYPE = "double",
    PROHIBIT = c("NA", "<= 0"),
    ISELEMENTOF = "",
    UNLIKELY = "",
    TOTAL = ""
  )
)
#Load and process BLS vehicle maintenance, repair, and tire cost data
#Cost data are for the year 2012
BLSOpCost_df <-
  processEstimationInputs(
    Inp_ls,
    "bls_vehicle_operating_costs.csv",
    "CalculateVehicleOperatingCost.R")
BLSOpCost_df$Ratio <- round(BLSOpCost_df$DollarsPerYear / BLSOpCost_df$DollarsPerYear[1], 2)
BLSOpCost_ <- BLSOpCost_df$DollarsPerYear
names(BLSOpCost_) <- BLSOpCost_df$VehicleAge
#Remove average
BLSOpCost_ <- BLSOpCost_[-length(BLSOpCost_)]
#Normalize values by cost for first 5 years
RelBLSOpCost_ <- BLSOpCost_ / BLSOpCost_[1]
#
rm(Inp_ls, BLSOpCost_)

#Model maintenance, repair and tires as a function of vehicle age and type
#-------------------------------------------------------------------------
#Create table of annual cost by age and vehicle type ($2017)
VehCost_AgTy <- outer(RelBLSOpCost_, AAAOpCost_)
#Save a copy to display in documentation
VehCostByAgeAndType_df <- data.frame(round(100 * VehCost_AgTy, 1))
#Convert to 2010 dollar values
VehCost_AgTy <- VehCost_AgTy * Deflators_Yr["2010"] / Deflators_Yr["2017"]

#------------------------------------------------
#Externality cost (i.e. social costs) assumptions
#------------------------------------------------

#Climate change costs
#--------------------
#Specify input file attributes
Inp_ls <- items(
  item(
    NAME = "Year",
    TYPE = "integer",
    PROHIBIT = "NA",
    ISELEMENTOF = c(
      "2010", "2015", "2020", "2025", "2030",
      "2035", "2040", "2045", "2050"),
    UNLIKELY = "",
    TOTAL = ""
  ),
  item(
    NAME = items(
      "DiscRate5Pct",
      "DiscRate3Pct",
      "DiscRate2.5Pct",
      "HighImpact"),
    TYPE = "double",
    PROHIBIT = c("NA", "<= 0"),
    ISELEMENTOF = "",
    UNLIKELY = "",
    TOTAL = ""
  )
)
#Load and process climate change cost data
#Cost data are in year 2007 dollars
CO2eCost_df <-
  processEstimationInputs(
    Inp_ls,
    "co2e_costs.csv",
    "CalculateVehicleOperatingCost.R")
CO2eCost_ <- CO2eCost_df$DiscRate3Pct
names(CO2eCost_) <- CO2eCost_df$Year
rm(Inp_ls)

#Convert to 2010 dollar values
CO2eCost_ <- CO2eCost_ * Deflators_Yr["2010"] / Deflators_Yr["2007"]

#Other externality costs
#-----------------------
#Specify input file attributes
Inp_ls <- items(
  item(
    NAME = "CostCategory",
    TYPE = "character",
    PROHIBIT = "NA",
    ISELEMENTOF = c(
      "AirPollution", "OtherResource", "EnergySecurity", "Safety", "Noise"),
    UNLIKELY = "",
    TOTAL = ""
  ),
  item(
    NAME = "UnitCost",
    TYPE = "double",
    PROHIBIT = c("NA", "<= 0"),
    ISELEMENTOF = "",
    UNLIKELY = "",
    TOTAL = ""
  ),
  item(
    NAME = "Units",
    TYPE = "character",
    PROHIBIT = "",
    ISELEMENTOF = "",
    UNLIKELY = "",
    TOTAL = ""
  )
)
#Load and process other externality cost data
#Cost data are in year 2010 dollars
OtherExtCost_df <-
  processEstimationInputs(
    Inp_ls,
    "ldv_externality_costs.csv",
    "CalculateVehicleOperatingCost.R")
OtherExtCost_ <- OtherExtCost_df$UnitCost
names(OtherExtCost_) <- OtherExtCost_df$CostCategory
rm(Inp_ls)

#---------------------------------
#Save the default cost assumptions
#---------------------------------
#Combine values into a list
OpCosts_ls <- list(
  VehCost_AgTy = VehCost_AgTy,
  CO2eCost_ = CO2eCost_,
  OtherExtCost_ = OtherExtCost_,
  BLSOpCost_df = BLSOpCost_df,
  VehCostByAgeAndType_df = VehCostByAgeAndType_df,
  CO2eCost_df = CO2eCost_df,
  OtherExtCost_df = OtherExtCost_df
)

#' Vehicle operations costs
#'
#' A list containing vehicle operations cost items for maintenance, repair,
#' tires, greenhouse gas emissions costs, and other social costs.
#'
#' @format A list containing the following three components:
#' \describe{
#'   \item{VehCost_AgTy}{a matrix of annual vehicle maintenance, repair and tire costs by vehicle type and age category in 2010 dollars}
#'   \item{CO2eCost_}{a vector of greenhouse gas emissions costs by forecast year in 2010 dollars per metric ton of carbon dioxide equivalents}
#'   \item{OtherExtCost_}{a vector of other social costs by cost category. Values are in 2010 dollars per vehicle mile except for EnergySecurity which is in 2010 dollars per gasoline equivalent gallon}
#'   \item{BLSOpCost_df}{a data frame of household vehicle annual maintenance, repair, and tire cost by vehicle age}
#'   \item{VehicleCostByAgeAndType_df}{a data frame of calculated vehicle maintenance, repair, and tire cost per mile by vehicle type and age}
#'   \item{CO2eCost_df}{a data frame of estimated cost of carbon in dollars per tonne by year under various scenarios}
#'   \item{OtherExtCost_df}{a data frame of other social costs by type}
#' }
#' @source CalculateVehicleOperatingCost.R script.
"OpCosts_ls"
visioneval::savePackageDataset(OpCosts_ls, overwrite = TRUE)
rm(VehCost_AgTy, AAAOpCost_, RelBLSOpCost_, CO2eCost_, Deflators_Yr, OtherExtCost_)


#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

#Define the data specifications
#------------------------------
CalculateVehicleOperatingCostSpecifications <- list(
  #Level of geography module is applied at
  RunBy = "Region",
  #Specify new tables to be created by Inp if any
  Inp = items(
    item(
      NAME =
        items(
          "OwnedVehAccessTime",
          "HighCarSvcAccessTime",
          "LowCarSvcAccessTime",
          "ShdCarSvcAccessTime",
          "UnShdCarSvcAccessTime"),
      FILE = "azone_vehicle_access_times.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "time",
      UNITS = "MIN",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION =
        items(
          "Average amount of time in minutes required for access to and egress from a household-owned vehicle for a trip",
          "Average amount of time in minutes required for access to and egress from a high service level car service for a trip",
          "Average amount of time in minutes required for access to and egress from a low service level car service for a trip",
          "Average amount of time in minutes required for access to and egress from a shared car service for a trip",
          "Average amount of time in minutes required for access to and egress from a unshared car service for a trip"
        )
    ),
    item(
      NAME = "ShdCarSvcAveOccup",
      FILE = "region_carsvc_shd_occup.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "multiplier",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = "Proportional increase in passenger destinations for shared car services vs unshared car services"
    ),
    item(
      NAME = items(
        "FuelCost",
        "PowerCost"),
      FILE = "azone_fuel_power_cost.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = items(
        "Retail cost of fuel per gas gallon equivalent in dollars",
        "Retail cost of electric power per kilowatt-hour in dollars"
      )
    ),
    item(
      NAME = items(
        "FuelTax",
        "VmtTax"),
      FILE = "azone_veh_use_taxes.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = items(
        "Tax per gas gallon equivalent of fuel in dollars",
        "Tax per mile of vehicle travel in dollars"
      )
    ),
    item(
      NAME = "PevSurchgTaxProp",
      FILE = "azone_veh_use_taxes.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = "Proportion of equivalent gas tax per mile paid by hydrocarbon fuel consuming vehicles to be charged to plug-in electric vehicles per mile of travel powered by electricity"
    ),
    item(
      NAME = items(
        "PropClimateCostPaid",
        "PropOtherExtCostPaid"),
      FILE = "region_prop_externalities_paid.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = items(
        "Proportion of climate change costs paid by users (i.e. ratio of carbon taxes to climate change costs)",
        "Proportion of other social costs paid by users")
    ),
    item(
      NAME = "CO2eCost",
      FILE = "region_co2e_costs.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = "Environmental and social cost of CO2e emissions per metric ton",
      OPTIONAL = TRUE
    ),
    item(
      NAME = items(
        "RunTimeUtilityAdj",
        "AccessTimeUtilityAdj",
        "RemoteAccessDvmtAdj"),
      FILE = "region_av_lev5_parameter.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "multiplier",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = items("Adjustment factor that is used to adjust the travel time component of composite vehicle operating cost of level 5 autonomous vehicles",
                          "Adjustment factor that is used to adjust the access time component of composite vehicle operating cost of level 5 autonomous vehicles when vehicle access is remotely controlled.",
                          "Adjustment factor that specifies the proportional adjustment to level 5 autonomous vehicle DVMT assumed to occur as a result of remote vehicle access for convenience, avoiding parking, and/or avoiding/reducing parking charges.")
    ),
    item(
      NAME = items(
        "PropRemoteAccess",
        "PropParkingFeeAvoid"),
      FILE = "region_av_lev5_parameter.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = items("The proportion of trips in level 5 autonomous vehicles for which travelers use capabilities of driverless vehicles to remotely control their vehicles to avoid having to park their vehicle and retrieve their vehicle from parking.",
                          "The proportion of parking fees avoided for travel in owned driverless vehicles.")
    )
  ),
  #Specify new tables to be created by Set if any
  #Specify input data
  Get = items(
    item(
      NAME = "ValueOfTime",
      TABLE = "Model",
      GROUP = "Global",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("<= 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "CO2eCost",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
    ),
    item(
      NAME = items(
        "RunTimeUtilityAdj",
        "AccessTimeUtilityAdj",
        "RemoteAccessDvmtAdj"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "multiplier",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
    ),
    item(
      NAME = items(
        "PropRemoteAccess",
        "PropParkingFeeAvoid"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
    ),
    item(
      NAME = items(
        "PropClimateCostPaid",
        "PropOtherExtCostPaid"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ExtraVmtTax",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
    ),
    item(
      NAME = "Marea",
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "LdvAveSpeed",
        "NonUrbanAveSpeed"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "MI/HR",
      PROHIBIT = "< 0",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "AveCongPrice",
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = "< 0",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Azone",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "LowCarSvcDeadheadProp",
          "HighCarSvcDeadheadProp"),
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "ShdCarSvcDeadheadFactor",
          "UnShdCarSvcDeadheadFactor"),
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "multiplier",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "OwnedVehAccessTime",
          "HighCarSvcAccessTime",
          "LowCarSvcAccessTime",
          "ShdCarSvcAccessTime",
          "UnShdCarSvcAccessTime"),
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "time",
      UNITS = "MIN",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ShdCarSvcAveOccup",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "multiplier",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "FuelCost",
        "PowerCost"),
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "FuelTax",
        "VmtTax"),
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "PevSurchgTaxProp",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "HighCarSvcCost",
          "LowCarSvcCost",
          "ShdCarSvcCost",
          "UnShdCarSvcCost"),
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "Marea",
        "Azone"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "HhId",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Income",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Dvmt",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "MI/DAY",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "UrbanDvmtProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "AVLvl5DvmtAdjProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
    ),
    item(
      NAME = "CarSvcDeadheadDvmtAdjProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
    ),
    item(
      NAME = "HasPaydIns",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      PROHIBIT = "",
      ISELEMENTOF = c(0, 1)
    ),
    item(
      NAME = "VehicleTrips",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "TRIP/DAY",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "OtherParkingCost",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "Azone",
        "Marea",
        "HhId",
        "VehId"),
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "NA",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Type",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "NA",
      ISELEMENTOF = c("Auto", "LtTrk")
    ),
    item(
      NAME = "Age",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "time",
      UNITS = "YR",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "VehicleAccess",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "",
      ISELEMENTOF = c("Own", "LowCarSvc", "HighCarSvc")
    ),
    item(
      NAME = "Powertrain",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "",
      ISELEMENTOF = c("ICEV", "HEV", "PHEV", "BEV", "NA")
    ),
    item(
      NAME = "AVLvl",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      NAVALUE = "NA",
      PROHIBIT = "",
      ISELEMENTOF = c("L0", "L3", "L5"),
      SIZE = 2,
      DESCRIPTION = "Identifier for vehicle level of automation"
    ),
    item(
      NAME = "GPM",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GGE/MI",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "KWHPM",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "KWH/MI",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ElecDvmtProp",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "FuelCO2ePM",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/MI",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ElecCO2ePM",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/MI",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "InsCost",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "HhId",
      TABLE = "Worker",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ParkingCost",
      TABLE = "Worker",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "IsCashOut",
      TABLE = "Worker",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      PROHIBIT = "",
      ISELEMENTOF = c(0, 1)
    ),
    item(
      NAME = "PaysForParking",
      TABLE = "Worker",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      PROHIBIT = "",
      ISELEMENTOF = c(0, 1)
    ),
    item(
      NAME = "Bzone",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Bzone",
      TABLE = "Bzone",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ShdSvcAvail",
      TABLE = "Bzone",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      PROHIBIT = c("NA"),
      ISELEMENTOF = c(0, 1)
    )
  ),
  #Specify data to saved in the data store
  Set = items(
    item(
      NAME = "AveVehCostPM",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      NAVALUE = -1,
      PROHIBIT = c("< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average out-of-pocket cost in dollars per mile of vehicle travel"
    ),
    item(
      NAME = "AveSocEnvCostPM",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      NAVALUE = -1,
      PROHIBIT = c("< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average cost in dollars of the social and environmental impacts per mile of vehicle travel"
    ),
    item(
      NAME = "AveRoadUseTaxPM",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      NAVALUE = -1,
      PROHIBIT = c("< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average road use taxes in dollars collected per mile of vehicle travel"
    ),
    item(
      NAME = "AveGPM",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GGE/MI",
      NAVALUE = -1,
      PROHIBIT = c("< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average gasoline equivalent gallons per mile of household vehicle travel"
    ),
    item(
      NAME = "AveKWHPM",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "KWH/MI",
      NAVALUE = -1,
      PROHIBIT = c("< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average kilowatt-hours per mile of household vehicle travel"
    ),
    item(
      NAME = "AveCO2ePM",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/MI",
      NAVALUE = -1,
      PROHIBIT = c("< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average grams of carbon-dioxide equivalents produced per mile of household vehicle travel"
    ),
    item(
      NAME = "Dvmt",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "MI/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Average daily vehicle miles traveled by the household in autos or light trucks"
    ),
    item(
      NAME = "AVLvl3DvmtProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = c("> 1.5"),
      TOTAL = "",
      DESCRIPTION ="Proportion of household DVMT by level 3 autonomous vehicles."
    ),
    item(
      NAME = "AVLvl5DvmtProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = c("> 1.5"),
      TOTAL = "",
      DESCRIPTION ="Proportion of household DVMT by level 5 autonomous vehicles."
    ),
    item(
      NAME = "AVLvl5DvmtAdjProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Proportion of total DVMT that is added based on level 5 autonomous vehicle driverless use"
    ),
    item(
      NAME = "CarSvcDeadheadDvmtAdjProp",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Proportion of total DVMT that is the added deadhead mileage of level 5 autonomous vehicles"
    ),
    item(
      NAME = "DvmtProp",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Proportion of household DVMT allocated to vehicle"
    ),
    item(
      NAME = "HhAVLvl3DvmtProp",
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Proportion of household DVMT that is level 3 autonomous vehicles"
    ),
    item(
      NAME = "HhAVLvl5DvmtProp",
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Proportion of household DVMT that is level 5 autonomous vehicles"
    )
  )
)

#Save the data specifications list
#---------------------------------
#' Specifications list for CalculateVehicleOperatingCost module
#'
#' A list containing specifications for the CalculateVehicleOperatingCost module.
#'
#' @format A list containing 5 components:
#' \describe{
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{Inp}{scenario input data to be loaded into the datastore for this
#'  module}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#'  \item{Call}{list of modules called by the module}
#' }
#' @source CalculateVehicleOperatingCost.R script.
"CalculateVehicleOperatingCostSpecifications"
visioneval::savePackageDataset(CalculateVehicleOperatingCostSpecifications, overwrite = TRUE)


#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================

#Main module function that calculates vehicle operating costs
#------------------------------------------------------------
#' Calculate vehicle operating costs.
#'
#' \code{CalculateVehicleOperatingCost} calculates vehicle operating costs and
#' determines how household DVMT is split between vehicles.
#'
#' This function calculates vehicle operating costs, splits household DVMT
#' between vehicles, and calculates household average vehicle operating cost,
#' social/environmental impact cost, and road use taxes per mile of household
#' vehicle travel.
#'
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#' @return A list containing the components specified in the Set
#' specifications for the module.
#' @name CalculateVehicleOperatingCost
#' @import visioneval
#' @export
#'
CalculateVehicleOperatingCost <- function(L) {
  
  #Adjust household total DVMT if the module has been called earlier
  if(!is.null(L$Year$Household[["AVLvl5DvmtAdjProp"]]) &
     !is.null(L$Year$Household[["CarSvcDeadheadDvmtAdjProp"]])){
    DvmtHh_ <- L$Year$Household$Dvmt
    AVLvl5DvmtAdjProp <- L$Year$Household[["AVLvl5DvmtAdjProp"]]
    CarSvcDeadheadDvmtAdjProp <-  L$Year$Household[["CarSvcDeadheadDvmtAdjProp"]]
    DvmtHh_ <- DvmtHh_ * (1 - (AVLvl5DvmtAdjProp + CarSvcDeadheadDvmtAdjProp))
    L$Year$Household$Dvmt <- DvmtHh_
    rm(DvmtHh_, AVLvl5DvmtAdjProp, CarSvcDeadheadDvmtAdjProp)
  }
  
  #Define vector of Mareas
  Ma <- L$Year$Marea$Marea
  #Index to match household data with vehicle data
  HhToVehIdx_Ve <- match(L$Year$Vehicle$HhId, L$Year$Household$HhId)
  #Index to match household data with worker data
  HhToWkrIdx_Wk <- match(L$Year$Worker$HhId, L$Year$Household$HhId)
  #Index to match Azone data with vehicle data
  AzToVehIdx_Ve <- match(L$Year$Vehicle$Azone, L$Year$Azone$Azone)
  #Index to match Marea data with vehicle data
  MaToVehIdx_Ve <- match(L$Year$Vehicle$Marea, L$Year$Marea$Marea)
  #Proportion of vehicle DVMT on urban roads
  UrbanVmtProp_Ve <- L$Year$Household$UrbanDvmtProp[HhToVehIdx_Ve]

  OpCosts_ls <- VEFHWAAV::OpCosts_ls

  #Calculate vehicle cost components
  #---------------------------------
  #Calculate maintenance, repair, tire cost per mile (only for owned vehicles)
  MRTCostRate_Ve <- local({
    NumVeh <- length(L$Year$Vehicle$VehId)
    #Categorize by vehicle age group
    VehAgeGroup_Ve <-
      cut(L$Year$Vehicle$Age,
          breaks = c(0, 5, 10, 15, 20, 25, max(L$Year$Vehicle$Age)),
          labels = FALSE, include.lowest = TRUE)
    #Categorize vehicle type
    MRTType_Ve <- character(length(NumVeh))
    MRTType_Ve[with(L$Year$Vehicle, Powertrain == "BEV")] <- "Bev"
    MRTType_Ve[with(L$Year$Vehicle, Powertrain == "HEV")] <- "Hev"
    MRTType_Ve[with(L$Year$Vehicle, Powertrain == "PHEV")] <- "Hev"
    MRTType_Ve[with(L$Year$Vehicle, Powertrain == "ICEV" & Type == "Auto")] <- "AutoIcev"
    MRTType_Ve[with(L$Year$Vehicle, Powertrain == "ICEV" & Type == "LtTrk")] <- "LtTrkIcev"
    MRTType_Ve[with(L$Year$Vehicle, VehicleAccess != "Own")] <- NA
    MRTTypeIdx_Ve <- match(MRTType_Ve, colnames(OpCosts_ls$VehCost_AgTy))
    #Get annual maintenance, repair, tire cost
    MRTCostRate_Ve <- OpCosts_ls$VehCost_AgTy[cbind(VehAgeGroup_Ve, MRTTypeIdx_Ve)]
    MRTCostRate_Ve[is.na(MRTCostRate_Ve)] <- 0
    #Set the rate for car services to 0 because assumed to be included in car service rate
    MRTCostRate_Ve[L$Year$Vehicle$VehicleAccess != "Own"] <- 0
    #Return the result
    unname(MRTCostRate_Ve)
  })

  #Calculate energy cost rate (fuel and electric power)
  NetGPM_Ve <- L$Year$Vehicle$GPM * (1 - L$Year$Vehicle$ElecDvmtProp)
  NetKWHPM_Ve <- L$Year$Vehicle$KWHPM * L$Year$Vehicle$ElecDvmtProp
  EnergyCostRate_Ve <- local({
    FuelCostRate_Ve <- NetGPM_Ve * L$Year$Azone$FuelCost[AzToVehIdx_Ve]
    ElecCostRate_Ve <- NetKWHPM_Ve * L$Year$Azone$PowerCost[AzToVehIdx_Ve]
    unname(FuelCostRate_Ve + ElecCostRate_Ve)
  })

  #Road use taxes
  RoadUseCostRate_Ve <- local({
    FuelTax_Ve <- L$Year$Azone$FuelTax[AzToVehIdx_Ve] * L$Year$Vehicle$GPM
    PevChrg <- mean(FuelTax_Ve) * L$Year$Azone$PevSurchgTaxProp[AzToVehIdx_Ve]
    ElecProp_Ve <- L$Year$Vehicle$ElecDvmtProp
    VmtTax_Ve <- L$Year$Azone$VmtTax[AzToVehIdx_Ve]
    if (!is.null(L$Year$Region$ExtraVmtTax)) {
      ExtraVmtTax <- L$Year$Region$ExtraVmtTax
    } else {
      ExtraVmtTax <- 0
    }
    CongPrice_Ve <- L$Year$Marea$AveCongPrice[MaToVehIdx_Ve] * UrbanVmtProp_Ve
    unname(VmtTax_Ve + ElecProp_Ve * PevChrg + (1 - ElecProp_Ve) * FuelTax_Ve + ExtraVmtTax + CongPrice_Ve)
  })

  #Average CO2e per mile
  CO2ePM_Ve <-
    with(L$Year$Vehicle, FuelCO2ePM * (1 - ElecDvmtProp) + ElecCO2ePM * ElecDvmtProp)
  #Climate impacts cost per mile
  ClimateImpactsRate_Ve <- local({
    #Calculate CO2e cost per metric ton for year
    if (!is.null(L$Year$Region$CO2eCost)) {
      CO2eCost <- L$Year$Region$CO2eCost
    } else {
      CO2eCost_ <- OpCosts_ls$CO2eCost_
      Years_ <- as.numeric(names(CO2eCost_))
      CO2eCost_SS <- smooth.spline(Years_, CO2eCost_)
      CO2eCost <- predict(CO2eCost_SS, as.numeric(L$G$Year))$y
    }
    unname(CO2ePM_Ve * CO2eCost / 1e6)
  })
  #Climate costs paid
  ClimateCostRate_Ve <- ClimateImpactsRate_Ve * L$Year$Region$PropClimateCostPaid

  #Other social impacts cost per mile
  SocialImpactsRate_Ve <- local({
    #Calculate energy security cost (convert cost per gallon to cost per mile)
    ESCost <- OpCosts_ls$OtherExtCost_["EnergySecurity"]
    ESCost_Ve <-
      ESCost * L$Year$Vehicle$GPM * (1 - L$Year$Vehicle$ElecDvmtProp)
    #Calculate other social costs (is function of miles)
    OtherSocialCost <- sum(OpCosts_ls$OtherExtCost_) - ESCost
    #Sum social costs per mile
    unname(ESCost_Ve + OtherSocialCost)
  })
  #Social costs paid
  SocialCostRate_Ve <- SocialImpactsRate_Ve * L$Year$Region$PropOtherExtCostPaid

  #Parking cost
  ParkingCostRate_Ve <- local({
    #Calculate work parking cost for each household
    WrkPkgCost_Wk <- with(L$Year$Worker, ParkingCost * PaysForParking)
    WrkPkgCost_Hx <- tapply(WrkPkgCost_Wk, HhToWkrIdx_Wk, sum)
    WrkPkgCost_Hh <- numeric(length(L$Year$Household$HhId))
    WrkPkgCost_Hh[as.numeric(names(WrkPkgCost_Hx))] <- WrkPkgCost_Hx
    rm(WrkPkgCost_Wk, WrkPkgCost_Hx)
    #Retrieve other parking cost for each household
    OthPkgCost_Hh <- L$Year$Household$OtherParkingCost
    #Scale by normalized number of vehicle trips for the Marea
    VehTrp_Hh <- L$Year$Household$VehicleTrips
    MeanVehTrp_Ma <-
      tapply(L$Year$Household$VehicleTrips, L$Year$Household$Marea, mean)
    OthPkgCost_Hh <-
      OthPkgCost_Hh * with(L$Year$Household, VehicleTrips / MeanVehTrp_Ma[Marea])
    #Sum daily parking cost and calculate cost per mile
    PkgCost_Hh <- WrkPkgCost_Hh + OthPkgCost_Hh
    PkgCostRate_Hh <- PkgCost_Hh / L$Year$Household$Dvmt
    MaxPkgCostRate <- quantile(PkgCostRate_Hh, 0.99)
    PkgCostRate_Hh[PkgCostRate_Hh > MaxPkgCostRate] <- MaxPkgCostRate
    #Assign values to owned household vehicles
    ParkingCostRate_Ve <- PkgCostRate_Hh[HhToVehIdx_Ve]
    #Adjust parking cost rate for level 5 autonomous vehicles by the proportion of fees avoided
    IsAVLvl5_ <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Vehicle$AVLvl == "L5"
    ParkingCostRate_Ve[IsAVLvl5_] <- ParkingCostRate_Ve[IsAVLvl5_] * (1 - L$Year$Region$PropParkingFeeAvoid)
    ParkingCostRate_Ve[L$Year$Vehicle$VehicleAccess != "Own"] <- 0
    unname(ParkingCostRate_Ve)
  })

  #PAYD insurance cost
  PaydInsCostRate_Ve <- local({
    HasPaydIns_Hh <- L$Year$Household$HasPaydIns
    InsCost_Ve <- L$Year$Vehicle$InsCost
    InsCost_Hx <- tapply(InsCost_Ve, HhToVehIdx_Ve, sum)
    InsCost_Hh <- numeric(length(L$Year$Household$HhId))
    InsCost_Hh[as.numeric(names(InsCost_Hx))] <- InsCost_Hx
    InsCostRate_Hh <- HasPaydIns_Hh * InsCost_Hh / L$Year$Household$Dvmt / 365
    MaxInsCostRate <- quantile(InsCostRate_Hh[InsCostRate_Hh > 0], 0.99)
    InsCostRate_Hh[InsCostRate_Hh > MaxInsCostRate] <- MaxInsCostRate
    InsCostRate_Ve <- unname(InsCostRate_Hh[HhToVehIdx_Ve])
    InsCostRate_Ve[L$Year$Vehicle$VehicleAccess != "Own"] <- 0
    InsCostRate_Ve
  })

  # Shared vs Unshared
  BzToVehIdx_Ve <- L$Year$Vehicle$Bzone
  # Shared vs Unshared
  # Calculate shared car service cost rate by bzone
  SharedCarSvcCostRate_Bz <- local({
    VehAccType_Ve <- L$Year$Vehicle$VehicleAccess
    #Access time equivalent rate of travel
    TripsPerDvmt_Ve <- with(L$Year$Household, VehicleTrips / Dvmt)[HhToVehIdx_Ve]
    MaxTripsPerDvmt <- quantile(TripsPerDvmt_Ve, probs = 0.99)
    TripsPerDvmt_Ve[TripsPerDvmt_Ve > MaxTripsPerDvmt] <- MaxTripsPerDvmt
    TripsPerDvmt_Ve[VehAccType_Ve=="Own"] <- 0
    SharedCarSvcCostRate_Ve <- rep(0, length(VehAccType_Ve))
    SharedCarSvcCostRate_Ve <- (L$Year$Azone$ShdCarSvcAccessTime/60)[AzToVehIdx_Ve] * 
      TripsPerDvmt_Ve * L$Global$Model$ValueOfTime
    SharedCarSvcCostRate_Ve[VehAccType_Ve=="Own"] <- 0
    SharedCarSvcCostRate_Bz <- tapply(SharedCarSvcCostRate_Ve, BzToVehIdx_Ve, sum)
    SharedCarSvcCostRate_Bz <- SharedCarSvcCostRate_Bz[L$Year$Bzone$Bzone] *
      L$Year$Bzone$ShdSvcAvail
    #SharedCarSvcCostRate_Bz <- 1/SharedCarSvcCostRate_Bz
    #SharedCarSvcCostRate_Bz[is.infinite(SharedCarSvcCostRate_Bz)] <- 0
    SharedCarSvcCostRate_Bz[is.na(SharedCarSvcCostRate_Bz)] <- 0
    SharedCarSvcCostRate_Bz
  })
  
  # Calculate unshared car service cost rate by bzone
  UnSharedCarSvcCostRate_Bz <- local({
    VehAccType_Ve <- L$Year$Vehicle$VehicleAccess
    #Access time equivalent rate of travel
    TripsPerDvmt_Ve <- with(L$Year$Household, VehicleTrips / Dvmt)[HhToVehIdx_Ve]
    MaxTripsPerDvmt <- quantile(TripsPerDvmt_Ve, probs = 0.99)
    TripsPerDvmt_Ve[TripsPerDvmt_Ve > MaxTripsPerDvmt] <- MaxTripsPerDvmt
    TripsPerDvmt_Ve[VehAccType_Ve=="Own"] <- 0
    UnSharedCarSvcCostRate_Ve <- rep(0, length(VehAccType_Ve))
    UnSharedCarSvcCostRate_Ve <- L$Year$Azone$UnShdCarSvcAccessTime[AzToVehIdx_Ve] * 
      TripsPerDvmt_Ve * L$Global$Model$ValueOfTime
    UnSharedCarSvcCostRate_Ve[VehAccType_Ve=="Own"] <- 0
    UnSharedCarSvcCostRate_Bz <- tapply(UnSharedCarSvcCostRate_Ve, BzToVehIdx_Ve, sum)
    UnSharedCarSvcCostRate_Bz <- UnSharedCarSvcCostRate_Bz[L$Year$Bzone$Bzone] *
      L$Year$Bzone$ShdSvcAvail
    #UnSharedCarSvcCostRate_Bz <- 1/UnSharedCarSvcCostRate_Bz
    #UnSharedCarSvcCostRate_Bz[is.infinite(UnSharedCarSvcCostRate_Bz)] <- 0
    UnSharedCarSvcCostRate_Bz[is.na(UnSharedCarSvcCostRate_Bz)] <- 0
    UnSharedCarSvcCostRate_Bz
  })
  
  # Calculate shared vs unshared DVMT split by bzone
  isShdSvcAvail_Bz <-  L$Year$Bzone$ShdSvcAvail == 1
  CarSvcCostRate_Bz <- 1/SharedCarSvcCostRate_Bz + 1/UnSharedCarSvcCostRate_Bz
  SharedCarSvcDvmtProp_Bz <- (1/SharedCarSvcCostRate_Bz) / CarSvcCostRate_Bz
  UnSharedCarSvcDvmtProp_Bz <- (1/UnSharedCarSvcCostRate_Bz) / CarSvcCostRate_Bz
  # Fix all the NAs because of no car service assigned to households in Bzone
  SharedCarSvcDvmtProp_Bz[is.na(SharedCarSvcDvmtProp_Bz)] <- 0
  UnSharedCarSvcDvmtProp_Bz[is.na(UnSharedCarSvcDvmtProp_Bz)] <- 0
  # Transfer to unshared car service if shared car service not available
  SharedCarSvcDvmtProp_Bz[!isShdSvcAvail_Bz] <- 0
  UnSharedCarSvcDvmtProp_Bz[SharedCarSvcDvmtProp_Bz==0] <- 1
  
  #Car service cost
  CarSvcCostRate_Ve <- local({
    VehAccType_Ve <- L$Year$Vehicle$VehicleAccess
    CarSvcCostRate_Ve <- rep(0, length(VehAccType_Ve))
    CarSvcCostRate_Ve[VehAccType_Ve == "LowCarSvc"] <-
      L$Year$Azone$LowCarSvcCost[AzToVehIdx_Ve][VehAccType_Ve == "LowCarSvc"]
    CarSvcCostRate_Ve[VehAccType_Ve == "HighCarSvc"] <-
      L$Year$Azone$HighCarSvcCost[AzToVehIdx_Ve][VehAccType_Ve == "HighCarSvc"]
    # Add average shared / unshared car service cost
    CarSvcCostRate_Ve <- (CarSvcCostRate_Ve +
                            (L$Year$Azone$UnShdCarSvcCost[AzToVehIdx_Ve] * 
                               UnSharedCarSvcDvmtProp_Bz[BzToVehIdx_Ve] + 
                               L$Year$Azone$ShdCarSvcCost[AzToVehIdx_Ve] * 
                               SharedCarSvcDvmtProp_Bz[BzToVehIdx_Ve]))/2
    CarSvcCostRate_Ve[VehAccType_Ve == "Own"] <- 0
    unname(CarSvcCostRate_Ve)
  })

  #Calculate value of time per mile
  #Function to calculate TTCostRate for household vehicles
  calcTTCostRateVe <- function(AdjustDriverlessUtility = FALSE){
    #Running time rate of travel
    Ma <- L$Year$Marea$Marea
    UrbanRunTimeRate_Ve <- (1 / L$Year$Marea$LdvAveSpeed)[MaToVehIdx_Ve]
    if (!any(is.na(L$Year$Marea$NonUrbanAveSpeed))) {
      NonUrbanRunTimeRate_Ve <- (1 / L$Year$Marea$NonUrbanAveSpeed)[MaToVehIdx_Ve]
      RunTimeRate_Ve <-
        UrbanVmtProp_Ve * UrbanRunTimeRate_Ve + (1 - UrbanVmtProp_Ve) * NonUrbanRunTimeRate_Ve
      RunTimeRate_Ve[is.na(RunTimeRate_Ve)] <- NonUrbanRunTimeRate_Ve[is.na(RunTimeRate_Ve)]
    } else {
      RunTimeRate_Ve <- UrbanRunTimeRate_Ve
    }
    #Access time equivalent rate of travel
    TripsPerDvmt_Ve <- with(L$Year$Household, VehicleTrips / Dvmt)[HhToVehIdx_Ve]
    MaxTripsPerDvmt <- quantile(TripsPerDvmt_Ve, probs = 0.99)
    TripsPerDvmt_Ve[TripsPerDvmt_Ve > MaxTripsPerDvmt] <- MaxTripsPerDvmt
    AccTimePerTrip_AzAt <- as.matrix(data.frame(
      Own = unname(L$Year$Azone$OwnedVehAccessTime / 60),
      HighCarSvc = unname(L$Year$Azone$HighCarSvcAccessTime / 60),
      LowCarSvc = unname(L$Year$Azone$LowCarSvcAccessTime / 60)
    ))
    AccToVehIdx_Ve <- match(L$Year$Vehicle$VehicleAccess, colnames(AccTimePerTrip_AzAt))
    AccTimePerTrip_Ve <- AccTimePerTrip_AzAt[cbind(AzToVehIdx_Ve, AccToVehIdx_Ve)]
    AccTimeRate_Ve <- TripsPerDvmt_Ve * AccTimePerTrip_Ve
    if(AdjustDriverlessUtility){
      #Adjust the running time cost rate and access time rate due to the effect of
      #level 5 autonomous driverless vehicles
      RunTimeUtilityAdj <- L$Year$Region$RunTimeUtilityAdj
      PropRemoteAccess <- L$Year$Region$PropRemoteAccess
      AccessTimeUtilityAdj <- L$Year$Region$AccessTimeUtilityAdj
      IsAVLvl5_ <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Vehicle$AVLvl == "L5"
      RunTimeRate_Ve[IsAVLvl5_] <- RunTimeRate_Ve[IsAVLvl5_] * RunTimeUtilityAdj
      AccTimeRate_Ve[IsAVLvl5_] <- AccTimeRate_Ve[IsAVLvl5_] * ((1 - PropRemoteAccess) + (AccessTimeUtilityAdj * PropRemoteAccess))
    }
    #Calculate value of time per mile
    unname((RunTimeRate_Ve + AccTimeRate_Ve) * L$Global$Model$ValueOfTime)
  }
  TTCostRate_Ve <- calcTTCostRateVe(AdjustDriverlessUtility = TRUE)
  AltTTCostRate_Ve <- calcTTCostRateVe(AdjustDriverlessUtility = FALSE)
  
  #Function to calculate composite cost
  calcCompositeCost <- function(CostRate_Ve){
    MRTCostRate_Ve + EnergyCostRate_Ve + RoadUseCostRate_Ve +
      ClimateCostRate_Ve + SocialCostRate_Ve + ParkingCostRate_Ve +
      PaydInsCostRate_Ve + CarSvcCostRate_Ve + CostRate_Ve
  }
  
  #Calculate the proportion of household DVMT of each vehicle
  #----------------------------------------------------------
  DvmtProp_Ve <- local({
    #Calculate composite price for using each vehicle
    #Sum of out-of-pocket and travel time costs per mile
    Price_Ve <-
      MRTCostRate_Ve + EnergyCostRate_Ve + RoadUseCostRate_Ve +
      ClimateCostRate_Ve + SocialCostRate_Ve + ParkingCostRate_Ve +
      PaydInsCostRate_Ve + CarSvcCostRate_Ve + TTCostRate_Ve
    names(Price_Ve) <- L$Year$Vehicle$VehId
    #Function to split travel among household vehicles in proportion to
    #the inverse of price
    splitDvmt <- function(Price_) {
      (1 / Price_) / sum(1 / Price_, na.rm = TRUE)
    }
    #Calculate DVMT proportions by household vehicle group
    VehAccType_Ve <- factor(L$Year$Vehicle$VehicleAccess,
                            levels = c("LowCarSvc", "HighCarSvc", "Own"))
    Price_HhAccess <- tapply(Price_Ve, list(factor(L$Year$Vehicle$HhId,
                                                   levels = L$Year$Household$HhId),
                                            VehAccType_Ve),
                             FUN = sum)
    Price_HhAccess[is.na(Price_HhAccess)] <- 0
    Price_HhAccess <- cbind(Price_HhAccess, 
                            "CarSvc" = rowSums(Price_HhAccess[,c("LowCarSvc", "HighCarSvc")]))
    Price_HhAccess <- Price_HhAccess[,c("Own", "CarSvc")]
    Prop_HhAccess <- t(apply(Price_HhAccess, 1, splitDvmt))
    Prop_HhAccess[Price_HhAccess[,"Own"]==0,"Own"] <- 0
    Prop_HhAccess[Price_HhAccess[,"Own"]==0,"CarSvc"] <- 1
    Prop_HhAccess[Price_HhAccess[,"CarSvc"]==0,"Own"] <- 1
    Prop_HhAccess[Price_HhAccess[,"CarSvc"]==0,"CarSvc"] <- 0
    
    #Calculate DVMT proportions by owned household vehicles
    PriceOwned_Ve <- Price_Ve
    PriceOwned_Ve[L$Year$Vehicle$VehicleAccess != "Own"] <- 0
    names(PriceOwned_Ve) <- L$Year$Vehicle$VehId
    PriceOwned_Hh_Ve <- lapply(split(PriceOwned_Ve, L$Year$Vehicle$HhId), splitDvmt)
    PriceOwned_Hh_Ve <- lapply(PriceOwned_Hh_Ve, function(val_){if(any(is.na(val_))){val_[val_==0]<-(1/sum(val_==0, na.rm = TRUE));val_[is.na(val_)]<-0; val_} else val_})
    names(PriceOwned_Hh_Ve) <- NULL
    PriceOwned_Hh_Ve <- unlist(PriceOwned_Hh_Ve, use.names = TRUE)[L$Year$Vehicle$VehId]
    PriceOwned_Hh_Ve[L$Year$Vehicle$VehicleAccess != "Own"] <- 0
    
    #Calculate DVMT proportions by car service household vehicles
    PriceCarSvc_Ve <- Price_Ve
    PriceCarSvc_Ve[L$Year$Vehicle$VehicleAccess == "Own"] <- 0
    names(PriceCarSvc_Ve) <- L$Year$Vehicle$VehId
    PriceCarSvc_Hh_Ve <- lapply(split(PriceCarSvc_Ve, L$Year$Vehicle$HhId), splitDvmt)
    PriceCarSvc_Hh_Ve <- lapply(PriceCarSvc_Hh_Ve, function(val_){if(any(is.na(val_))){val_[val_==0]<-(1/sum(val_==0, na.rm = TRUE));val_[is.na(val_)]<-0; val_} else val_})
    names(PriceCarSvc_Hh_Ve) <- NULL
    PriceCarSvc_Hh_Ve <- unlist(PriceCarSvc_Hh_Ve, use.names = TRUE)[L$Year$Vehicle$VehId]
    PriceCarSvc_Hh_Ve[L$Year$Vehicle$VehicleAccess == "Own"] <- 0
    
    #Calculate DVMT proportions by household vehicle
    Price_Hh_Ve <- PriceOwned_Hh_Ve[L$Year$Vehicle$VehId] * 
      Prop_HhAccess[,"Own"][L$Year$Vehicle$HhId] +
      PriceCarSvc_Hh_Ve[L$Year$Vehicle$VehId] * 
      Prop_HhAccess[,"CarSvc"][L$Year$Vehicle$HhId]
    Price_Hh_Ve
  })
  
  #Calculate car service DVMT adjustments
  #---------------------------------------
  #Calculate the DVMT adjustment for change in average occupancy
  CarSvcDvmtAdjFactor_Ve <- local({
    IsCarSvc_ <- L$Year$Vehicle$VehicleAccess != "Own"
    SharedCarSvcDvmtProp_Ve <- SharedCarSvcDvmtProp_Bz[BzToVehIdx_Ve]
    UnSharedCarSvcDvmtProp_Ve <- UnSharedCarSvcDvmtProp_Bz[BzToVehIdx_Ve]
    AvgOccpInc_Ve <- (SharedCarSvcDvmtProp_Ve * L$Year$Region$ShdCarSvcAveOccup) +
      (1 * UnSharedCarSvcDvmtProp_Ve)
    DvmtAdjFactor_Ve <- 1/AvgOccpInc_Ve
    DvmtAdjFactor_Ve[!IsCarSvc_] <- 1
    DvmtAdjFactor_Ve
  })
  
  #Calculate driverless vehicle DVMT adjustments
  #---------------------------------------------
  Dvmt_Hh <- L$Year$Household$Dvmt
  Dvmt_Ve <- DvmtProp_Ve * Dvmt_Hh[HhToVehIdx_Ve]
  #Calculate the proportional increase in passenger DVMT due to lower disutility of
  #travel in a driverless vehicle
  PassengerDvmtAdj_Ve <- local({
    IsAVLvl5_ <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Vehicle$AVLvl == "L5"
    DvmtAdj_Ve <- (calcCompositeCost(AltTTCostRate_Ve)/calcCompositeCost(TTCostRate_Ve)) - 1
    DvmtAdj_Ve[!IsAVLvl5_] <- 0
    DvmtAdj_Ve
  })
  AddPassengerDvmt_Ve <- Dvmt_Ve * PassengerDvmtAdj_Ve
  #Calculate adjustments in DVMT due to remote access
  RemoteAccessDvmtAdj_Ve <- local({
    IsAVLvl5_ <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Vehicle$AVLvl == "L5"
    PropRemoteAccess <- L$Year$Region$PropRemoteAccess
    RemoteAccessDvmtAdj <- L$Year$Region$RemoteAccessDvmtAdj
    DvmtAdj_Ve <- array(PropRemoteAccess * RemoteAccessDvmtAdj, length(Dvmt_Ve))
    DvmtAdj_Ve[!IsAVLvl5_] <- 0
    DvmtAdj_Ve
  })
  AddRemoteAccessDvmt_Ve <- Dvmt_Ve * RemoteAccessDvmtAdj_Ve
  
  #Calculate car service deadhead DVMT
  #-----------------------------------
  DeadheadDvmt_Ve <- local({
    VehAccType_Ve <- L$Year$Vehicle$VehicleAccess
    IsDriverless_ <- (VehAccType_Ve != "Own") & L$Year$Vehicle$Driverless > 0
    LowCarSvcDeadheadProp <- L$Year$Azone$LowCarSvcDeadheadProp[AzToVehIdx_Ve]
    HighCarSvcDeadheadProp <- L$Year$Azone$HighCarSvcDeadheadProp[AzToVehIdx_Ve]
    ShdCarSvcDeadheadFactor <- L$Year$Azone$ShdCarSvcDeadheadFactor[AzToVehIdx_Ve]
    UnShdCarSvcDeadheadFactor <- L$Year$Azone$UnShdCarSvcDeadheadFactor[AzToVehIdx_Ve]
    SharedCarSvcDvmtProp_Ve <- SharedCarSvcDvmtProp_Bz[BzToVehIdx_Ve]
    UnSharedCarSvcDvmtProp_Ve <- UnSharedCarSvcDvmtProp_Bz[BzToVehIdx_Ve]
    ShdDvmt_Ve <- Dvmt_Ve * SharedCarSvcDvmtProp_Ve
    UnShdDvmt_Ve <- Dvmt_Ve * UnSharedCarSvcDvmtProp_Ve
    DeadheadDvmt_Ve <- Dvmt_Ve * 0
    DeadheadDvmt_Ve[VehAccType_Ve == "LowCarSvc"] <-
      (((ShdDvmt_Ve * ShdCarSvcDeadheadFactor) + (UnShdDvmt_Ve * UnShdCarSvcDeadheadFactor)) * 
         LowCarSvcDeadheadProp)[VehAccType_Ve == "LowCarSvc"]
    DeadheadDvmt_Ve[VehAccType_Ve == "HighCarSvc"] <-
      (((ShdDvmt_Ve * ShdCarSvcDeadheadFactor) + (UnShdDvmt_Ve * UnShdCarSvcDeadheadFactor)) * 
         HighCarSvcDeadheadProp)[VehAccType_Ve == "HighCarSvc"]
    DeadheadDvmt_Ve[!IsDriverless_] <- 0
    DeadheadDvmt_Ve
  })
  
  #Recalculate DVMT allocation amongst household vehicles and total household DVMT
  #-------------------------------------------------------------------------------
  Dvmt_Ve <- Dvmt_Ve + AddPassengerDvmt_Ve + AddRemoteAccessDvmt_Ve + DeadheadDvmt_Ve
  DvmtProp_Ve <- local({
    names(Dvmt_Ve) <- L$Year$Vehicle$VehId
    Dvmt_Hh_Ve <- lapply(split(Dvmt_Ve, L$Year$Vehicle$HhId), function(x) x / sum(x))
    names(Dvmt_Hh_Ve) <- NULL
    unlist(Dvmt_Hh_Ve, use.names = TRUE)[L$Year$Vehicle$VehId]
  })
  
  #Calculate average household costs, impacts, taxes per mile
  #----------------------------------------------------------
  #Calculate average out-of-pocket costs per mile by household
  AveVehCostPM_Hh <- local({
    VehCostPM_Ve <-
      MRTCostRate_Ve + EnergyCostRate_Ve + RoadUseCostRate_Ve +
      ClimateCostRate_Ve + SocialCostRate_Ve + ParkingCostRate_Ve +
      PaydInsCostRate_Ve + CarSvcCostRate_Ve
    AdjDvmt_Ve <- Dvmt_Ve - DeadheadDvmt_Ve
    TotCost_Hh <- tapply(VehCostPM_Ve * AdjDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
    AdjDvmt_Hh <- tapply(AdjDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
    TotCost_Hh / AdjDvmt_Hh
  })
  #Calculate average social and environmental impacts costs per mile by household
  AveSocEnvCostPM_Hh <- local({
    SocEnvCostPM_Ve <- ClimateImpactsRate_Ve + SocialImpactsRate_Ve
    tapply(SocEnvCostPM_Ve * DvmtProp_Ve * CarSvcDvmtAdjFactor_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  })
  #Calculate average road use taxes per mile
  AveRoadUseTaxPM_Hh <-
    tapply(RoadUseCostRate_Ve * DvmtProp_Ve * CarSvcDvmtAdjFactor_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  #Calculate average fuel consumption per mile
  GPM_Hh <-
    tapply(NetGPM_Ve * DvmtProp_Ve * CarSvcDvmtAdjFactor_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  #Calculate average electricity consumption per mile
  KWHPM_Hh <-
    tapply(NetKWHPM_Ve * DvmtProp_Ve * CarSvcDvmtAdjFactor_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  #Calculate average greenhouse gas emissions per mile
  AveCO2ePM_Hh <-
    tapply(CO2ePM_Ve * DvmtProp_Ve * CarSvcDvmtAdjFactor_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  #Recalculate total household DVMT
  Dvmt_Hh <- local({
    tapply(Dvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  })
  #Calculate proportion of household DVMT that is driverless DVMT adjustment
  DriverlessDvmtAdj_Hh <-
    tapply(AddPassengerDvmt_Ve + AddRemoteAccessDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  AVLvl5DvmtAdjProp_Hh <- DriverlessDvmtAdj_Hh / Dvmt_Hh
  #Calculate proportion of Car Service Dvmt that is deadhead Dvmt
  DeadheadDvmtAdj_Hh <- tapply(DeadheadDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  CarSvcDeadheadDvmtAdjProp_Hh <- DeadheadDvmtAdj_Hh / Dvmt_Hh
  #Calculate proportion of household Dvmt in level 3 autonomous vehicles
  AVLvl3Dvmt_Hh <- local({
    IsAVLvl3_ <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Vehicle$AVLvl == "L3"
    tapply(Dvmt_Ve * IsAVLvl3_, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  })
  AVLvl3DvmtProp_Hh <- AVLvl3Dvmt_Hh / Dvmt_Hh
  HhAVLvl3DvmtProp_Ma <- setNames(numeric(length(Ma)), Ma)
  for (ma in Ma) {
    HhAVLvl3DvmtProp_Ma[ma] <- local({
      IsMa <- L$Year$Household$Marea == ma
      Dvmt_Hh <- L$Year$Household$Dvmt[IsMa]
      AVLvl3Dvmt_Hh <- AVLvl3Dvmt_Hh[IsMa]
      sum(AVLvl3Dvmt_Hh) / sum(Dvmt_Hh)
    })
  }
  #Calculate proportion of household Dvmt in level 5 autonomous vehicles
  AVLvl5Dvmt_Hh <- local({
    IsAVLvl5_ <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Vehicle$AVLvl == "L5"
    tapply(Dvmt_Ve * IsAVLvl5_, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  })
  AVLvl5DvmtProp_Hh <- AVLvl5Dvmt_Hh / Dvmt_Hh
  HhAVLvl5DvmtProp_Ma <- setNames(numeric(length(Ma)), Ma)
  for (ma in Ma) {
    HhAVLvl5DvmtProp_Ma[ma] <- local({
      IsMa <- L$Year$Household$Marea == ma
      Dvmt_Hh <- L$Year$Household$Dvmt[IsMa]
      AVLvl5Dvmt_Hh <- AVLvl5Dvmt_Hh[IsMa]
      sum(AVLvl5Dvmt_Hh) / sum(Dvmt_Hh)
    })
  }

  #Return the results
  #------------------
  Out_ls <- initDataList()
  Out_ls$Year$Household <- list(
    AveVehCostPM = AveVehCostPM_Hh,
    AveSocEnvCostPM = AveSocEnvCostPM_Hh,
    AveRoadUseTaxPM = AveRoadUseTaxPM_Hh,
    AveGPM = GPM_Hh,
    AveKWHPM = KWHPM_Hh,
    AveCO2ePM = AveCO2ePM_Hh,
    Dvmt = Dvmt_Hh,
    AVLvl3DvmtProp = AVLvl3DvmtProp_Hh,
    AVLvl5DvmtProp = AVLvl5DvmtProp_Hh,
    AVLvl5DvmtAdjProp = AVLvl5DvmtAdjProp_Hh,
    CarSvcDeadheadDvmtAdjProp = CarSvcDeadheadDvmtAdjProp_Hh
  )
  Out_ls$Year$Vehicle <- list(
    DvmtProp = DvmtProp_Ve
  )
  Out_ls$Year$Marea <- list(
    HhAVLvl3DvmtProp = HhAVLvl3DvmtProp_Ma,
    HhAVLvl5DvmtProp = HhAVLvl5DvmtProp_Ma
  )
  Out_ls
}


#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("CalculateVehicleOperatingCost")

#Test code to check specifications, loading inputs, and whether datastore
#contains data needed to run module. Return input list (L) to use for developing
#module functions
#-------------------------------------------------------------------------------
# #Load libraries and test functions
# library(visioneval)
# library(filesstrings)
# source("tests/scripts/test_functions.R")
# #Set up test environment
# TestSetup_ls <- list(
#   TestDataRepo = "../Test_Data/VE-RSPM",
#   DatastoreName = "Datastore.tar",
#   LoadDatastore = TRUE,
#   TestDocsDir = "verspm",
#   ClearLogs = TRUE,
#   # SaveDatastore = TRUE
#   SaveDatastore = FALSE
# )
# setUpTests(TestSetup_ls)
#Run test module
# TestDat_ <- testModule(
#   ModuleName = "CalculateVehicleOperatingCost",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = FALSE
# )
# L <- TestDat_$L
# R <- CalculateVehicleOperatingCost(L)
#
# TestDat_ <- testModule(
#   ModuleName = "CalculateVehicleOperatingCost",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = TRUE
# )
