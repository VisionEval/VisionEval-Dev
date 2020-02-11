#===============
#AssignDriverlessVehicles.R
#===============
#
#<doc>
#
## AssignDriverlessVehicles Module
#### October 30, 2019
#
#This module determines whether a household vehicle is driverless or not. It also determines the driverless DVMT proportion of car service vehicles (commercial service vehicles, heavey trucks, and public transit vehicles).
#
### How the Module Works
#
#The module randomly assigns  value of 1 for driverless vehicle owned by the household and 0 for other household vehicles.
#
#</doc>


#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================

#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

#Define the data specifications
#------------------------------
AssignDriverlessVehiclesSpecifications <- list(
  #Level of geography module is applied at
  RunBy = "Region",
  #Specify new tables to be created by Inp if any
  NewInpTable = items(
    item(
      TABLE = "RegionDriverlessProps",
      GROUP = "Global"
    )
  ),
  #Specify new tables to be created by Set if any
  #Specify input data
  Inp = items(
    item(
      NAME =
        items(
          "VehYear"),
      FILE = "region_driverless_vehicle_prop.csv",
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "time",
      UNITS = "YR",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION =
        items(
          "The year represents the vehicle model year for household vehicles (automobile and light truck) and operation year for car service vehicles, commercial service vehicles, and heavy trucks."
        )
    ),
    item(
      NAME =
        items(
          "AutoSalesDriverlessProp",
          "LtTrkSalesDriverlessProp"),
      FILE = "region_driverless_vehicle_prop.csv",
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = c("> 1.5"),
      TOTAL = "",
      DESCRIPTION =
        items(
          "The proportion of automobiles sold in the corresponding year that are driverless. Values for intervening years are interpolated",
          "The proportion of light trucks sold in the corresponding year that are driverless. Values for intervening years are interpolated"
        )
    ),
    item(
      NAME =
        items(
          "LowCarSvcDriverlessProp",
          "HighCarSvcDriverlessProp"),
      FILE = "region_driverless_vehicle_prop.csv",
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = c("> 1.5"),
      TOTAL = "",
      DESCRIPTION =
        items(
          "The proportion of the car service fleet DVMT in low car service areas in the corresponding year that are driverless. Values for intervening years are interpolated",
          "The proportion of the car service fleet DVMT in high car service areas in the corresponding year that are driverless. Values for intervening years are interpolated"
        )
    ),
    item(
      NAME =
        items(
          "ComSvcDriverlessProp",
          "HvyTrkDriverlessProp",
          "PtVanDriverlessProp",
          "BusDriverlessProp"),
      FILE = "region_driverless_vehicle_prop.csv",
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = c("> 1.5"),
      TOTAL = "",
      DESCRIPTION =
        items(
          "The proportion of the commercial service vehicle fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.",
          "The proportion of the heavy truck fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated",
          "The proportion of public transit van DVMT in the corresponding year that are driverless. Values for intervening years are interpolated",
          "The proportion of bus fleet DVMT in the corresponding year that are driverless. Values for intevening years are interpolated"
        )
    )
  ),
  #Specify data to be loaded from data store
  Get = items(
    item(
      NAME =
        items(
          "VehYear"),
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "time",
      UNITS = "YR",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "AutoSalesDriverlessProp",
          "LtTrkSalesDriverlessProp"),
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "LowCarSvcDriverlessProp",
          "HighCarSvcDriverlessProp"),
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "ComSvcDriverlessProp",
          "HvyTrkDriverlessProp",
          "PtVanDriverlessProp",
          "BusDriverlessProp"),
      TABLE = "RegionDriverlessProps",
      GROUP = "Global",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "HhId",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "NA",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "VehId",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "NA",
      ISELEMENTOF = ""
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
      NAME = "Type",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "NA",
      ISELEMENTOF = c("Auto", "LtTrk")
    ),
    item(
      NAME = "HhId",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "NA",
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "NumLtTrk",
        "NumAuto",
        "NumHighCarSvc"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "vehicles",
      UNITS = "VEH",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    )
  ),
  #Specify data to saved in the data store
  Set = items(
    item(
      NAME = "DriverlessDvmtProp",
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
      DESCRIPTION ="The proportion of household DVMT that is in driverless vehicles."
    ),
    item(
      NAME = "Driverless",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportions",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = c("> 1.5"),
      SIZE = 0,
      DESCRIPTION = "Driverless vehicle identifier. A value of 1 indicates that the owned vehicle is driverless."
    )
  )
)

#Save the data specifications list
#---------------------------------
#' Specifications list for AssignDriverlessVehicles module
#'
#' A list containing specifications for the AssignDriverlessVehicles module.
#'
#' @format A list containing 4 components:
#' \describe{
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{Inp}{scenario input data to be loaded into the datastore for this
#'  module}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#' }
#' @source AssignDriverlessVehicles.R script.
"AssignDriverlessVehiclesSpecifications"
usethis::use_data(AssignDriverlessVehiclesSpecifications, overwrite = TRUE)


#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================
# The module randomly assigns household vehicles as driverless based on the driverless
# probability given by age and vehicle type. The module will also calculate preliminary
# estimates of proportion of household DVMT that is in driverless vehicles.

#Main module function that assigns driverless vehicles
#------------------------------------------------------------------------
#' Main module function to assign driverless vehicles.
#'
#' \code{AssignDriverlessVehicles} assigns driverless vehicle to each household.
#'
#' This function randomly assigns household vehicles as driverless based on the driverless
#' probability given by age and vehicle type. The household vehicels owned are assigned
#' a value of 1 if driverless and 0 otherwise based on age and vehicle type. The household vehicles
#' with vehicle access of service type are assigned a driverless probability based on vehicle age
#' and type. The function also calcualates a preliminary estimate of proportion of household DVMT
#' that is in driverless vehicles. This estimate is obtained by dividing the sum of vehicles that are
#' driverless by sum of vehicles that are other than low level car service vehicle access type by
#' each household.
#'
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#' @return A list containing the components specified in the Set
#' specifications for the module.
#' @name AssignDriverlessVehicles
#' @import visioneval stats
#' @export
AssignDriverlessVehicles <- function(L) {

  #Set up
  #------
  #Fix seed as synthesis involves sampling
  set.seed(L$G$Seed)
  #Initialize outputs list
  NumHh <- length(L$Year$Household$HhId)
  NumVeh <- length(L$Year$Vehicle$VehId)
  CurrentYear <- L$G$Year
  Out_ls <- initDataList()

  #Assign driverless to household vehicles
  #---------------------------------------
  Driverless_ <- integer(NumVeh)
  RegionDriverlessPropByYear_df <- data.frame(L$Global$RegionDriverlessProps)
  RegionDriverlessPropByYear_df$VehYear <- as.integer(gsub("\\.\\d*", "",
                                                           RegionDriverlessPropByYear_df$VehYear))


  # Assign the driverless vehicles by proportion by age
  # Combine into vector and assign driverless to household vehicles
  VehDriverlessProp_ <- numeric(NumVeh)
  VehAge_ <- as.integer(L$Year$Vehicle$Age)
  VehYear_ <- pmax(as.integer(CurrentYear) - VehAge_, 1975)
  VehType_ <- L$Year$Vehicle$Type
  CarSvcLvl_ <- as.character(L$Year$Vehicle$VehicleAccess)
  OwnedAuto_ <- VehType_ == "Auto" & CarSvcLvl_ == "Own"
  VehDriverlessProp_[OwnedAuto_] <- approx(as.numeric(RegionDriverlessPropByYear_df$VehYear),
                                           as.numeric(
                                             RegionDriverlessPropByYear_df$AutoSalesDriverlessProp),
                                           VehYear_[OwnedAuto_],
                                           yleft = 0)$y

  OwnedLtTrk_ <- VehType_ == "LtTrk" & CarSvcLvl_ == "Own"
  VehDriverlessProp_[OwnedLtTrk_] <- approx(as.numeric(RegionDriverlessPropByYear_df$VehYear),
                                           as.numeric(
                                             RegionDriverlessPropByYear_df$LtTrkSalesDriverlessProp),
                                           VehYear_[OwnedLtTrk_],
                                           yleft = 0)$y
  OwnedVeh_ <- OwnedAuto_ | OwnedLtTrk_
  Driverless_[OwnedVeh_] <- sapply(VehDriverlessProp_[OwnedVeh_],
                                   function(prop){
                                     sample(c(0L,1L),
                                            size=1L,
                                            replace=FALSE,
                                            prob=c(1-prop, prop))
                                   },
                                   USE.NAMES = FALSE)
  rm(OwnedAuto_, OwnedLtTrk_, OwnedVeh_, VehDriverlessProp_)

  # Assign the driverless proportion to car services
  Driverless_ <- as.numeric(Driverless_)
  LowCarSvc_ <- CarSvcLvl_ == "LowCarSvc"
  Driverless_[LowCarSvc_] <- approx(as.numeric(RegionDriverlessPropByYear_df$VehYear),
                                    as.numeric(
                                      RegionDriverlessPropByYear_df$LowCarSvcDriverlessProp),
                                    VehYear_[LowCarSvc_],
                                    yleft = 0)$y
  HighCarSvc_ <- CarSvcLvl_ == "HighCarSvc"
  Driverless_[HighCarSvc_]  <- approx(as.numeric(RegionDriverlessPropByYear_df$VehYear),
                                      as.numeric(
                                        RegionDriverlessPropByYear_df$HighCarSvcDriverlessProp),
                                      VehYear_[HighCarSvc_],
                                      yleft = 0)$y

  rm(LowCarSvc_, HighCarSvc_)

  # Calculate driverless dvmt proportion for household
  DriverlessDvmtProp_ <- numeric(NumHh)
  names(DriverlessDvmtProp_) <- L$Year$Household$HhId

  NumDriverlessVehByHh_ <- tapply(Driverless_[CarSvcLvl_ != "LowCarSvc"],
                                  L$Year$Vehicle$HhId[CarSvcLvl_ != "LowCarSvc"],
                                  FUN = sum)
  NumEligibleVehByHh_ <- tapply(CarSvcLvl_ != "LowCarSvc",
                                L$Year$Vehicle$HhId,
                                FUN = sum)
  DriverlessDvmtProp_[names(NumDriverlessVehByHh_)] <- NumDriverlessVehByHh_ /
    pmax(NumEligibleVehByHh_[names(NumDriverlessVehByHh_)],1)

  Out_ls$Year <- list(
    Vehicle = list(
      Driverless = Driverless_
    ),
    Household = list(
      DriverlessDvmtProp = DriverlessDvmtProp_
    )
  )

  #Return the outputs list
  Out_ls
}


#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("AssignDriverlessVehicles")

#Test code to check specifications, loading inputs, and whether datastore
#contains data needed to run module. Return input list (L) to use for developing
#module functions
#-------------------------------------------------------------------------------
# #Load packages and test functions
# library(filesstrings)
# library(visioneval)
# library(ordinal)
# source("tests/scripts/test_functions.R")
# #Set up test environment
# TestSetup_ls <- list(
#   TestDataRepo = "../Test_Data/VE-RSPM",
#   DatastoreName = "Datastore.tar",
#   LoadDatastore = TRUE,
#   TestDocsDir = "vestate",
#   ClearLogs = TRUE,
#   # SaveDatastore = TRUE
#   SaveDatastore = FALSE
# )
# setUpTests(TestSetup_ls)
# #Run test module
# TestDat_ <- testModule(
#   ModuleName = "AssignDriverlessVehicles",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = FALSE
# )
# L <- TestDat_$L
# R <- AssignDriverlessVehicles(L)
#
# #Run test module
# TestDat_ <- testModule(
#   ModuleName = "AssignDriverlessVehicles",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = TRUE
# )
