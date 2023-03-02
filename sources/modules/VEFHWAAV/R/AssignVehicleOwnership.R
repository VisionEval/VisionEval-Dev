#========================
#AssignVehicleOwnership.R
#========================
#
#<doc>
#
## AssignVehicleOwnership Module
#### February 2, 2022
#
#This module determines the number of vehicles owned or leased by each household as a function of household characteristics, land use characteristics, and transportation system characteristics.
#
### Model Parameter Estimation
#
#The vehicle ownership model is segmented for metropolitan and non-metropolitan households because additional information about transit supply and the presence of urban mixed-use neighborhoods is available for metropolitan households that is not available for non-metropolitan households. There are two models for each segment. A binary logit model is used to predict which households own no vehicles. An ordered logit model is used to predict how many vehicles a household owns if they own any vehicles. The number of vehicles a household may be assigned is 6.
#
#The metropolitan model for determining whether a household owns no vehicles is documented below. As expected, the probability that a household is carless is greater for low income households (less than $20,000), households living in higher density and/or mixed-use neighborhoods, and households living in metropolitan areas having higher levels of transit service. The probability decreases as the number of drivers in the household increases, household income increases, and if the household lives in a single-family dwelling. The number of drivers has the greatest influence on car ownership. The number of workers increases the probability of no vehicle ownership, but since the model includes drivers, this coefficient probably reflects the effect of non-driving workers on vehicle ownership.
#
#<txt:AutoOwnModels_ls$Stats$MetroZeroSummary>
#
#The non-metropolitan model for zero car ownership is shown below. The model terms are the same as for the metropolitan model with the exception of the urban mixed-use and transit supply variables. The signs of the variables are the same as for the metropolitan model and the values are of similar magnitude.
#
#<txt:AutoOwnModels_ls$Stats$NonMetroZeroSummary>
#
#The ordered logit model for the number of vehicles owned by metropolitan households that own at least one vehicle is shown below. Households are likely to own more vehicles if they live in a single-family dwelling, have higher incomes, have more workers, and have more drivers. Households are likely to own fewer vehicles if all household members are elderly, they live in a higher density and/or urban mixed-use neighborhood, they live in a metropolitan area with a higher level of transit service, and if more persons are in the household. The latter result is at surprising at first glance, but since the model also includes the number of drivers and number of workers, the household size coefficient is probably showing the effect of non-drivers non-workers in the household.
#
#<txt:AutoOwnModels_ls$Stats$MetroCountSummary>
#
#The ordered logit model for non-metropolitan household vehicle ownership is described below. The variables are the same as for the metropolitan model with the exception of the urban mixed-use neighborhood and transit variables. The signs of the coefficients are the same and the magnitudes are similar.
#
#<txt:AutoOwnModels_ls$Stats$NonMetroCountSummary>
#
### How the Module Works
#
#For each household, the metropolitan or non-metropolitan binary logit model is run to predict the probability that the household owns no vehicles. A random number is drawn from a uniform distribution in the interval from 0 to 1 and if the result is less than the probability of zero-vehicle ownership, the household is assigned no vehicles. Households that have no drivers are also assigned 0 vehicles. The metropolitan or non-metropolitan ordered logit model is run to predict the number of vehicles owned by the household if they own any.
#
#</doc>


#=================================
#Packages used in code development
#=================================
#Uncomment following lines during code development. Recomment when done.
# library(visioneval)
# library(ordinal)


#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================
#The vehicle ownership model is segmented for metropolitan and non-metropolitan
#households because additional information about transit supply and the presence
#of urban mixed-use neighborhoods is available for metropolitan households that
#is not available for non-metropolitan households. There are two models for each
#segment. A binary logit model is used to predict which households own no
#vehicles. An ordered logit model is used to predict how many vehicles a
#household owns if they own any vehicles.

#Create model estimation dataset
#-------------------------------
#Load selected data from VE2001NHTS package
Hh_df <- loadPackageDataset("Hh_df","VE2001NHTS")
FieldsToKeep_ <-
  c("NumVeh", "Income", "Hbppopdn", "Hhsize", "Hometype", "UrbanDev", "FwyLnMiPC",
    "Wrkcount", "Drvrcnt", "Age0to14", "Age65Plus", "MsaPopDen", "BusEqRevMiPC")
Hh_df <- Hh_df[, FieldsToKeep_]
#Create additional data fields
Hh_df$IsSF <- as.numeric(Hh_df$Hometype %in% c("Single Family", "Mobile Home"))
Hh_df$HhSize <- Hh_df$Hhsize
Hh_df$DrvAgePop <- Hh_df$HhSize - Hh_df$Age0to14
Hh_df$OnlyElderly <- as.numeric(Hh_df$HhSize == Hh_df$Age65Plus)
Hh_df$LogIncome <- log1p(Hh_df$Income)
Hh_df$LogDensity <- log(Hh_df$Hbppopdn)
Hh_df$ZeroVeh <- as.numeric(Hh_df$NumVeh == 0)
Hh_df$LowInc <- as.numeric(Hh_df$Income <= 20000)
Hh_df$Workers <- Hh_df$Wrkcount
Hh_df$Drivers <- Hh_df$Drvrcnt
Hh_df$IsUrbanMixNbrhd <- Hh_df$UrbanDev
Hh_df$TranRevMiPC <- Hh_df$BusEqRevMiPC
rm(FieldsToKeep_)

#Create a list to store models
#-----------------------------
AutoOwnModels_ls <-
  list(
    Metro = list(),
    NonMetro = list(),
    Stats = list()
  )

#Model metropolitan households
#-----------------------------
#Make metropolitan household estimation dataset
Terms_ <-
  c("IsSF", "IsUrbanMixNbrhd", "Workers", "Drivers", "TranRevMiPC", "LogIncome",
    "HhSize", "LogDensity", "OnlyElderly", "LowInc", "NumVeh", "ZeroVeh",
    "FwyLnMiPC")
EstData_df <- Hh_df[!is.na(Hh_df$TranRevMiPC), Terms_]
EstData_df <- EstData_df[complete.cases(EstData_df),]
rm(Terms_)
#Model zero vehicle households
AutoOwnModels_ls$Metro$Zero <-
  glm(
    ZeroVeh ~ Workers + LowInc + LogIncome + IsSF + Drivers + IsUrbanMixNbrhd +
      LogDensity + TranRevMiPC,
    data = EstData_df,
    family = binomial
  )
AutoOwnModels_ls$Stats$MetroZeroSummary <-
  capture.output(summary(AutoOwnModels_ls$Metro$Zero))
AutoOwnModels_ls$Stats$MetroZeroAnova <-
  capture.output(anova(AutoOwnModels_ls$Metro$Zero, test = "Chisq"))
#Trim down model
AutoOwnModels_ls$Metro$Zero[c("residuals", "fitted.values",
                              "linear.predictors", "weights",
                              "prior.weights", "y", "model",
                              "data")] <- NULL
#Model number of vehicles of non-zero vehicle households
EstData_df <- EstData_df[EstData_df$ZeroVeh == 0,]
EstData_df$VehOrd <- EstData_df$NumVeh
EstData_df$VehOrd[EstData_df$VehOrd > 6] <- 6
EstData_df$VehOrd <- ordered(EstData_df$VehOrd)
AutoOwnModels_ls$Metro$Count <-
  ordinal::clm(
    VehOrd ~ Workers + LogIncome + Drivers + HhSize + OnlyElderly + IsSF +
      IsUrbanMixNbrhd + LogDensity + TranRevMiPC,
    data = EstData_df,
    threshold = "equidistant"
  )
AutoOwnModels_ls$Stats$MetroCountSummary <-
  capture.output(summary(AutoOwnModels_ls$Metro$Count))
#Trim down model
AutoOwnModels_ls$Metro$Count[c("fitted.values", "model", "y")] <- NULL

#Model non-metropolitan households
#---------------------------------
#Make non-metropolitan household estimation dataset
Terms_ <-
  c("IsSF", "Workers", "Drivers", "LogIncome", "HhSize", "LogDensity",
    "OnlyElderly", "LowInc", "NumVeh", "ZeroVeh")
EstData_df <- Hh_df[is.na(Hh_df$TranRevMiPC), Terms_]
EstData_df <- EstData_df[complete.cases(EstData_df),]
#Remove 2 cases with 10 workers in household. Including them in the model
#estimation causes probabilities close to zero which reduces the reliability of
#the estimated model
EstData_df <- EstData_df[EstData_df$Workers != 10,]
rm(Terms_)
#Model zero vehicle households
AutoOwnModels_ls$NonMetro$Zero <-
  glm(
    ZeroVeh ~ Workers + LowInc + LogIncome + IsSF + Drivers + LogDensity,
    data = EstData_df,
    family = binomial
  )
AutoOwnModels_ls$Stats$NonMetroZeroSummary <-
  capture.output(summary(AutoOwnModels_ls$NonMetro$Zero))
AutoOwnModels_ls$Stats$NonMetroZeroAnova <-
  capture.output(anova(AutoOwnModels_ls$NonMetro$Zero, test = "Chisq"))
#Trim down model
AutoOwnModels_ls$NonMetro$Zero[c("residuals", "fitted.values",
                                 "linear.predictors", "weights",
                                 "prior.weights", "y", "model",
                                 "data")] <- NULL
#Model number of vehicles of non-zero vehicle households
EstData_df <- EstData_df[EstData_df$ZeroVeh == 0,]
EstData_df$VehOrd <- EstData_df$NumVeh
EstData_df$VehOrd[EstData_df$VehOrd > 6] <- 6
EstData_df$VehOrd <- ordered(EstData_df$VehOrd)
AutoOwnModels_ls$NonMetro$Count <-
  ordinal::clm(
    VehOrd ~ Workers + LogIncome + Drivers + HhSize + OnlyElderly + IsSF +
      LogDensity,
    data = EstData_df,
    threshold = "equidistant"
  )
AutoOwnModels_ls$Stats$NonMetroCountSummary <-
  capture.output(summary(AutoOwnModels_ls$NonMetro$Count))
#Trim down model
AutoOwnModels_ls$NonMetro$Count[c("fitted.values", "model", "y")] <- NULL
#Clean up
rm(Hh_df, EstData_df)

#Save the auto ownership model
#-----------------------------
#' Auto ownership model
#'
#' A list containing the auto ownership model equation and other information
#' needed to implement the auto ownership model.
#'
#' @format A list having the following components:
#' \describe{
#'   \item{Metro}{a list containing two models for metropolitan areas: a Zero
#'   component that is a binomial logit model for determining which households
#'   own no vehicles and a Count component that is an ordered logit model for
#'   determining how many vehicles a household who has vehicles owns}
#'   \item{NonMetro}{a list containing two models for non-metropolitan areas: a
#'   Zero component that is a binomial logit model for determining which households
#'   own no vehicles and a Count component that is an ordered logit model for
#'   determining how many vehicles a household who has vehicles owns}
#' }
#' @source AssignVehicleOwnership.R script.
"AutoOwnModels_ls"
visioneval::savePackageDataset(AutoOwnModels_ls, overwrite = TRUE)

#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

#Define the data specifications
#------------------------------
AssignVehicleOwnershipSpecifications <- list(
  #Level of geography module is applied at
  RunBy = "Region",
  #Specify new tables to be created by Inp if any
  #Specify new tables to be created by Set if any
  #Specify input data
  Inp = items(
    item(
      NAME = "AveVehPerDriver",
      FILE = "azone_hh_ave_veh_per_driver.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "VEH/DRV",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "> 2",
      TOTAL = "",
      DESCRIPTION =
        "Average number of household vehicles per licensed driver by Azone",
      OPTIONAL = TRUE
    ),
    item(
      NAME =
        items(
          "AVLvl0Share",
          "AVLvl3Share",
          "AVLvl5Share"
      ),
      FILE = "region_av_market_share.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = item(
        "Market share of vehicles with no autonomous driving capability",
        "Market share of vehicles with level 3 autonomous driving capability",
        "Market share of vehicles with level 5 autonomous driving capability"
      )
    )
  ),
  #Specify data to be loaded from data store
  Get = items(
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
      NAME = "TranRevMiPC",
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "MI/PRSN/YR",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Marea",
      TABLE = "Bzone",
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
      NAME = "D1B",
      TABLE = "Bzone",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "PRSN/SQMI",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Bzone",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Azone",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Marea",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Workers",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "people",
      UNITS = "PRSN",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Drivers",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "people",
      UNITS = "PRSN",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Income",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2001",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "HouseType",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "",
      ISELEMENTOF = c("SF", "MF", "GQ")
    ),
    item(
      NAME = "HhSize",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "people",
      UNITS = "PRSN",
      PROHIBIT = c("NA", "<= 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Age65Plus",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "people",
      UNITS = "PRSN",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "IsUrbanMixNbrhd",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      PROHIBIT = "NA",
      ISELEMENTOF = c(0, 1)
    ),
    item(
      NAME = "LocType",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "NA",
      ISELEMENTOF = c("Urban", "Town", "Rural")
    ),
    item(
      NAME = "AVLvl5Propensity",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "<0", ">1"),
      ISELEMENTOF = "",
      SIZE = 0
    ),
    item(
      NAME = items(
        "AVLvl0Share",
        "AVLvl3Share",
        "AVLvl5Share"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "CarSvcPropensity",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "<0", ">1"),
      ISELEMENTOF = "",
      SIZE = 0
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
      NAME = "AveVehPerDriver",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "VEH/DRV",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      OPTIONAL = TRUE
      )
  ),
  #Specify data to saved in the data store
  Set = items(
    item(
      NAME = items("Vehicles",
                   "NumAVLvl5Vehicles",
                   "NumAVLvl3Vehicles"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "vehicles",
      UNITS = "VEH",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Number of automobiles and light trucks owned or leased by the household including high level car service vehicles available to driving-age persons",
        "Number of automation level 5 automobiles and light trucks owned or leased by the household including high level car service vehicles available to driving-age persons",
        "Number of automation level 3 automobiles and light trucks owned or leased by the household including high level car service vehicles available to driving-age persons"
      )
    ),
    item(
      NAME = items("AVLvl5Share",
                   "AVLvl3Share"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Market share of vehicles with level 3 autonomous driving capability",
        "Market share of vehicles with level 5 autonomous driving capability"
      )
    ),
    item(
      NAME = "AVLvl5Candidate",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      NAVALUE = -1,
      PROHIBIT = c("NA"),
      ISELEMENTOF = c(0, 1),
      SIZE = 0,
      DESCRIPTION = "A value of 1 sugests that the household is an ideal candidate to own level 5 autonomous vehicle"
    ),
    item(
      NAME = "AVLvl3Candidate",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      NAVALUE = -1,
      PROHIBIT = c("NA"),
      ISELEMENTOF = c(0, 1),
      SIZE = 0,
      DESCRIPTION = "A value of 1 sugests that the household is an ideal candidate to own level 5 autonomous vehicle"
    ),
    item(
      NAME = "CarSvcCandidate",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "integer",
      UNITS = "binary",
      NAVALUE = -1,
      PROHIBIT = c("NA"),
      ISELEMENTOF = c(0, 1),
      SIZE = 0,
      DESCRIPTION = "A value of 1 sugests that the household is an ideal candidate to use car services"
    )
  )
)

#Save the data specifications list
#---------------------------------
#' Specifications list for AssignVehicleOwnership module
#'
#' A list containing specifications for the AssignVehicleOwnership module.
#'
#' @format A list containing 3 components:
#' \describe{
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#' }
#' @source AssignVehicleOwnership.R script.
"AssignVehicleOwnershipSpecifications"
visioneval::savePackageDataset(AssignVehicleOwnershipSpecifications, overwrite = TRUE)


#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================
#This function assigns the number of vehicles a household owns.

#Main module function that calculates vehicle ownership
#------------------------------------------------------
#' Calculate the number of vehicles owned by the household.
#'
#' \code{AssignVehicleOwnership} calculate the number of vehicles owned by each
#' household.
#'
#' This function calculates the number of vehicles owned by each household
#' given the characteristic of the household and the area where it resides.
#'
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#' @return A list containing the components specified in the Set
#' specifications for the module.
#' @name AssignVehicleOwnership
#' @import visioneval ordinal
#' @export
AssignVehicleOwnership <- function(L) {
  #Set up
  #------
  #Fix seed as synthesis involves sampling
  set.seed(L$G$Seed)
  #Define vector of Mareas
  Ma <- L$Year$Marea$Marea
  Bz <- L$Year$Bzone$Bzone
  Az <- L$Year$Azone$Azone
  #Calculate number of households
  NumHh <- length(L$Year$Household[[1]])

  #Set up data frame of household data needed for model
  #----------------------------------------------------
  Hh_df <- data.frame(L$Year$Household)
  Hh_df$IsSF <- as.numeric(Hh_df$HouseType == "SF")
  Hh_df$OnlyElderly <- as.numeric(Hh_df$HhSize == Hh_df$Age65Plus)
  Hh_df$LowInc <- as.numeric(Hh_df$Income <= 20000)
  Hh_df$LogIncome <- log1p(Hh_df$Income)
  Density_ <- L$Year$Bzone$D1B[match(L$Year$Household$Bzone, L$Year$Bzone$Bzone)]
  Hh_df$LogDensity <- log(Density_)
  TranRevMiPC_Bz <- L$Year$Marea$TranRevMiPC[match(L$Year$Bzone$Marea, L$Year$Marea$Marea)]
  Hh_df$TranRevMiPC <- TranRevMiPC_Bz[match(L$Year$Household$Bzone, L$Year$Bzone$Bzone)]
  Hh_df$CarSvcCandidate <- as.integer(runif(nrow(Hh_df)) < Hh_df$CarSvcPropensity)
  
  TargetShareLvl5 <- as.vector(L$Year$Region$AVLvl5Share)
  TargetShareLvl3 <- as.vector(L$Year$Region$AVLvl3Share)
  Hh_df$AVLvl5Candidate <- as.integer((runif(nrow(Hh_df)) < Hh_df$AVLvl5Propensity))
  Hh_df$AVLvl3Candidate <- 0
  
  # Update AV candidacy based on target market share
  # ------------------------------------------------
  Hh_df$AVLvl5Candidate <- as.integer(TargetShareLvl5 > 0) * Hh_df$AVLvl5Candidate
  

  #Make a vehicle probability matrix
  #---------------------------------
  AutoOwnModels_ls <- loadPackageDataset("AutoOwnModels_ls","VEHouseholdVehicles")

  #Identify Urban households
  IsUrban <- Hh_df$LocType == "Urban"
  #No vehicle probability
  NoVehicleProb_ <- numeric(NumHh)
  NoVehicleCarSvcCoef <- 1
  # Inverse logit function
  invlogit <- function(U_){
    return(exp(U_)/(1+exp(U_)))
  }
  if (any(IsUrban)) {
    NoVehicleUtility <-
      predict(AutoOwnModels_ls$Metro$Zero,
              newdata = Hh_df[IsUrban,],
              type = "link")
    NoVehicleUtility <- NoVehicleUtility + 
      NoVehicleCarSvcCoef*Hh_df[IsUrban,"CarSvcCandidate"]
    NoVehicleProb_[IsUrban] <- invlogit(NoVehicleUtility)
  }
  if (any(!IsUrban)) {
    NoVehicleUtility <-
      predict(AutoOwnModels_ls$NonMetro$Zero,
              newdata = Hh_df[!IsUrban,],
              type = "link")
    NoVehicleUtility <- NoVehicleUtility + 
      NoVehicleCarSvcCoef*Hh_df[!IsUrban,"CarSvcCandidate"]
    NoVehicleProb_[!IsUrban] <- invlogit(NoVehicleUtility)
  }
  #Vehicle count probability
  VehicleProb_mx <- array(NA,dim = c(NumHh, 6))
  NumVehAVLvl5Coef <- 1
  NumVehCarSvcCoef <- 1
  if (any(IsUrban)) {
    VehiclePredict_mx <- 
      predict(AutoOwnModels_ls$Metro$Count,
              newdata = Hh_df[IsUrban,],
              type = "linear.predictor")$eta1
    VehiclePredict_mx <- VehiclePredict_mx + 
      NumVehAVLvl5Coef * Hh_df[IsUrban,"AVLvl5Candidate"] +
      NumVehCarSvcCoef * Hh_df[IsUrban,"CarSvcCandidate"]
    VehicleProb_mx[IsUrban,1] <- plogis(VehiclePredict_mx[,1],0,1,1)
    for(i in 2:6){
      VehicleProb_mx[IsUrban,i] <- 
        plogis(VehiclePredict_mx[,i],0,1,1) - 
        plogis(VehiclePredict_mx[,i-1],0,1,1)
    }
  }
  if (any(!IsUrban)) {
    VehiclePredict_mx <-
      predict(AutoOwnModels_ls$NonMetro$Count,
              newdata = Hh_df[!IsUrban,],
              type = "linear.predictor")$eta1
    VehiclePredict_mx <- VehiclePredict_mx + 
      NumVehAVLvl5Coef * Hh_df[!IsUrban,"AVLvl5Candidate"] +
      NumVehCarSvcCoef * Hh_df[!IsUrban,"CarSvcCandidate"]
    VehicleProb_mx[!IsUrban,1] <- plogis(VehiclePredict_mx[,1],0,1,1)
    for(i in 2:6){
      VehicleProb_mx[!IsUrban,i] <- 
        plogis(VehiclePredict_mx[,i],0,1,1) - 
        plogis(VehiclePredict_mx[,i-1],0,1,1)
    }
  }
  

  #Combine no-vehicle and vehicle count probabilities
  VehicleProb_HhNv <- cbind(
    NoVehicleProb_,
    sweep(VehicleProb_mx, 1, (1 - NoVehicleProb_), "*")
  )
  rm(VehicleProb_mx, NoVehicleProb_)

  #Predict number of vehicles using probabilities
  #----------------------------------------------
  #Predict number of vehicles for each household
  Vehicles_ <- apply(VehicleProb_HhNv, 1, function(x) {
    sample(0:6, 1, prob = x)
  })

  #Define function to adjust vehicle predictions to match a target number
  #----------------------------------------------------------------------
  adjVehicles <- function(NumChgVeh, Vehicles_, Hh_df, VehicleProb_mx,
                          MaxVehicles_ = NULL) {
    if(is.null(MaxVehicles_)) MaxVehicles_ <- Inf
    if (NumChgVeh > 0) {
      ChgVehCat <- 0:5
    }
    if (NumChgVeh < 0) {
      ChgVehCat <- 1:6
    }
    #Allocate the changes according to numbers of vehicles in each change category
    NumHhByCategory_ <- sapply(ChgVehCat, function(x) sum(Vehicles_ == x))
    PropHhByCategory_ <- NumHhByCategory_ / sum(NumHhByCategory_)
    ChgVehByCategory_ <- round(NumChgVeh * PropHhByCategory_)
    #Initialize a vector of changes
    VehiclesChg_ <- integer(length(Vehicles_))
    #Iterate through each category and identify changes
    for (Cat in ChgVehCat) {
      HhIdxToChg_ <- which((Vehicles_ == Cat) & (Vehicles_ < MaxVehicles_))
      if (NumChgVeh > 0) {
        NumToChg <- ChgVehByCategory_[Cat + 1]
        ChgProb_ <- VehicleProb_HhNv[HhIdxToChg_, Cat + 2]
      }
      if (NumChgVeh < 0) {
        NumToChg <- ChgVehByCategory_[Cat]
        ChgProb_ <- VehicleProb_HhNv[HhIdxToChg_, Cat]
      }
      IdxToChg_ <- tail(HhIdxToChg_[order(ChgProb_)], abs(NumToChg))
      VehiclesChg_[IdxToChg_] <- sign(NumToChg)
    }
    #Calculate the adjusted number of vehicles
    Vehicles_ <- Vehicles_ + VehiclesChg_
  }

  #Adjust number of vehicles if target vehicles/drivers provided
  #-------------------------------------------------------------
  if (!all(is.null(L$Year$Azone$AveVehPerDriver))) {
    #Iterate by Azone to adjust vehicle predictions to match Azone target
    for (az in Az) {
      IsAzone <- Hh_df$Azone == az
      TargetRatio <- with(L$Year$Azone, AveVehPerDriver[Azone == az])
      NumDvr <- with(Hh_df, sum(Drivers[Azone == az]))
      TargetNumVeh <- round(TargetRatio * NumDvr)
      NumChgVeh <- TargetNumVeh - sum(Vehicles_[IsAzone])
      #Calculate changes if the number of vehicles to change is not 0
      if (NumChgVeh != 0) {
        Vehicles_[IsAzone] <- adjVehicles(
          NumChgVeh = NumChgVeh,
          Vehicles_ = Vehicles_[IsAzone],
          Hh_df = Hh_df[IsAzone,],
          VehicleProb_mx = VehicleProb_mx[IsAzone,])
      }
    }
  }
  
  #Identify number of households for AV candidacy based on target market shares
  #----------------------------------------------------------------------------
  # AV Level 5 Market Share
  AVLvl5Vehicles_ <- integer(length(Vehicles_))
  if(TargetShareLvl5 > 0){
    # Check the candidacy first
    # Count existing number of Lvl5 candidates
    NumLvl5CandidateHh <- sum(Hh_df$AVLvl5Candidate)
    NumReqdLvl5Hh <- round(nrow(Hh_df) * TargetShareLvl5)
    NumChgLvl5Hh <- NumReqdLvl5Hh - NumLvl5CandidateHh
    if(NumChgLvl5Hh > 0){
      # Add additional households
      # Set AV Level 3 candidacy to 0
      CandidateHhIndex_ <- which(Hh_df$AVLvl5Candidate == 0)
      AddLvl5Hh_ <- sample(CandidateHhIndex_,
                           NumChgLvl5Hh,
                           prob = Hh_df[CandidateHhIndex_, "AVLvl5Propensity"])
      Hh_df$AVLvl5Candidate[AddLvl5Hh_] <- 1
    } else if (NumChgLvl5Hh < 0) {
      # Remove some households
      CandidateHhIndex_ <- which(Hh_df$AVLvl5Candidate == 1)
      RemoveLvl5Hh_ <- sample(CandidateHhIndex_,
                              abs(NumChgLvl5Hh),
                              prob = (1-Hh_df[CandidateHhIndex_, "AVLvl5Propensity"]))
      Hh_df$AVLvl5Candidate[RemoveLvl5Hh_] <- 0
      Hh_df$AVLvl3Candidate[RemoveLvl5Hh_] <- 1
    }
    
    # Match the vehicles
    IsAVLvl5Candidate_ <- Hh_df$AVLvl5Candidate==1 & Vehicles_>0
    AVLvl5Vehicles_ <- integer(length(Vehicles_))
    AVLvl5Prob_HhNv <- cbind(sapply(seq_len(ncol(VehicleProb_HhNv)),
                                    function(x) {
                                      propensity <- Hh_df$AVLvl5Propensity/x**4
                                      propensity[x>Vehicles_] <- 0
                                      propensity
                                      }))
    AVLvl5Prob_HhNv[IsAVLvl5Candidate_,] <- sweep(AVLvl5Prob_HhNv[IsAVLvl5Candidate_,],
                                                  1,
                                                  rowSums(AVLvl5Prob_HhNv[IsAVLvl5Candidate_,]),"/")
    AVLvl5Vehicles_[IsAVLvl5Candidate_] <- apply(
      AVLvl5Prob_HhNv[IsAVLvl5Candidate_,], 1, function(x) {
        sample(1:7, 1, prob = x)
        })
    TargetNumVehLvl5 <- round(sum(Vehicles_) * TargetShareLvl5)
    NumChgVehLvl5 <- TargetNumVehLvl5 - sum(AVLvl5Vehicles_)
    PrevNumChgVehLvl5 <- NumChgVehLvl5 + 1
    iter <- 0
    #Calculate changes if the number of automation level 5 vehicles to 
    # change is not 0
    while ((PrevNumChgVehLvl5 - NumChgVehLvl5)> 0 & iter < 20) {
      if(NumChgVehLvl5 != 0){
        AVLvl5Vehicles_[IsAVLvl5Candidate_] <- adjVehicles(
          NumChgVeh = NumChgVehLvl5,
          Vehicles_ = AVLvl5Vehicles_[IsAVLvl5Candidate_],
          Hh_df = Hh_df[IsAVLvl5Candidate_,],
          VehicleProb_mx = AVLvl5Prob_HhNv[IsAVLvl5Candidate_,],
          MaxVehicles_ = Vehicles_[IsAVLvl5Candidate_])
      }
      PrevNumChgVehLvl5 <- NumChgVehLvl5
      NumChgVehLvl5 <- TargetNumVehLvl5 - sum(AVLvl5Vehicles_)
      iter <- iter + 1
    }
  }
  # AV Level 3 Market Share
  AVLvl3Vehicles_ <- integer(length(Vehicles_))
  if(TargetShareLvl3 > 0){
    # Count existing number of Lvl5 candidates
    Hh_df$AVLvl3Candidate <- Hh_df$AVLvl5Candidate
    NumLvl3CandidateHh <- sum(Hh_df$AVLvl3Candidate)
    NumReqdLvl3Hh <- round(nrow(Hh_df) * (TargetShareLvl3+TargetShareLvl5))
    NumChgLvl3Hh <- NumReqdLvl3Hh - NumLvl3CandidateHh
    if(NumChgLvl3Hh > 0){
      # Add additional households
      # Set AV Level 3 candidacy to 0
      CandidateHhIndex_ <- which(Hh_df$AVLvl3Candidate == 0)
      AddLvl3Hh_ <- sample(CandidateHhIndex_,
                           NumChgLvl3Hh,
                           prob = Hh_df[CandidateHhIndex_, "AVLvl5Propensity"])
      Hh_df$AVLvl3Candidate[AddLvl3Hh_] <- 1
    } else if (NumChgLvl3Hh < 0) {
      # Remove some households
      CandidateHhIndex_ <- which(Hh_df$AVLvl3Candidate == 1)
      RemoveLvl3Hh_ <- sample(CandidateHhIndex_,
                              abs(NumChgLvl3Hh),
                              prob = (1-Hh_df[CandidateHhIndex_, "AVLvl5Propensity"]))
      Hh_df$AVLvl3Candidate[RemoveLvl5Hh_] <- 0
    }
    
    # Match the vehicles
    IsAVLvl3Candidate_ <- Hh_df$AVLvl3Candidate == 1 & 
      ((RemVehicles_ <- Vehicles_ - AVLvl5Vehicles_) > 0)
    AVLvl3Vehicles_ <- integer(length(Vehicles_))
    AVLvl3Prob_HhNv <- cbind(sapply(seq_len(ncol(VehicleProb_HhNv)),
                                    function(x) {
                                      propensity <- Hh_df$AVLvl5Propensity/x**4
                                      propensity[x>RemVehicles_] <- 0
                                      propensity
                                    }))
    AVLvl3Prob_HhNv[IsAVLvl3Candidate_,] <- sweep(AVLvl3Prob_HhNv[IsAVLvl3Candidate_,],
                                                  1,
                                                  rowSums(AVLvl3Prob_HhNv[IsAVLvl3Candidate_,]),"/")
    AVLvl3Vehicles_[IsAVLvl3Candidate_] <- apply(
      AVLvl3Prob_HhNv[IsAVLvl3Candidate_,], 1, function(x) {
        sample(1:7, 1, prob = x)
      })
    TargetNumVehLvl3 <- round(sum(Vehicles_) * TargetShareLvl3)
    NumChgVehLvl3 <- TargetNumVehLvl3 - sum(AVLvl3Vehicles_)
    PrevNumChgVehLvl3 <- NumChgVehLvl3 + 1
    iter <- 0
    #Calculate changes if the number of automation level 5 vehicles to 
    # change is not 0
    while ((PrevNumChgVehLvl3 - NumChgVehLvl3)> 0 & iter < 20) {
      if(NumChgVehLvl3 != 0){
        AVLvl3Vehicles_[IsAVLvl3Candidate_] <- adjVehicles(
          NumChgVeh = NumChgVehLvl3,
          Vehicles_ = AVLvl3Vehicles_[IsAVLvl3Candidate_],
          Hh_df = Hh_df[IsAVLvl3Candidate_,],
          VehicleProb_mx = AVLvl3Prob_HhNv[IsAVLvl3Candidate_,],
          MaxVehicles_ = RemVehicles_[IsAVLvl3Candidate_])
      }
      PrevNumChgVehLvl3 <- NumChgVehLvl3
      NumChgVehLvl3 <- TargetNumVehLvl3 - sum(AVLvl3Vehicles_)
      iter <- iter + 1
    }
  } else {
    Hh_df$AVLvl3Candidate <- 0
    AVLvl5Vehicles_ <- numeric(nrow(Hh_df))
    AVLvl3Vehicles_ <- numeric(nrow(Hh_df))
  }
  
  # Calculate market share by Marea
  NumVehicles_ma <- tapply(Vehicles_, L$Year$Household$Marea, sum)
  AVLvl5Vehicles_ma <- tapply(AVLvl5Vehicles_, L$Year$Household$Marea, sum)
  AVLvl3Vehicles_ma <- tapply(AVLvl3Vehicles_, L$Year$Household$Marea, sum)
  
  AVLvl5Share_ma <- AVLvl5Vehicles_ma/NumVehicles_ma
  AVLvl3Share_ma <- AVLvl3Vehicles_ma/NumVehicles_ma
  
  AVLvl5Share_ma <- AVLvl5Share_ma[L$Year$Marea$Marea]
  AVLvl3Share_ma <- AVLvl3Share_ma[L$Year$Marea$Marea]

  #Return the results
  #------------------
  #Initialize output list
  Out_ls <- initDataList()
  Out_ls$Year$Household <-
    list(Vehicles = Vehicles_,
         NumAVLvl5Vehicles = AVLvl5Vehicles_,
         NumAVLvl3Vehicles = AVLvl3Vehicles_,
         AVLvl5Candidate = Hh_df$AVLvl5Candidate,
         AVLvl3Candidate = Hh_df$AVLvl3Candidate,
         CarSvcCandidate = Hh_df$CarSvcCandidate)
  Out_ls$Year$Marea <- list(
    AVLvl5Share = AVLvl5Share_ma,
    AVLvl3Share = AVLvl3Share_ma
  )
  #Return the outputs list
  Out_ls
}

#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("AssignVehicleOwnership")

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
#   TestDataRepo = "../Test_Data/VE-State",
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
#   ModuleName = "AssignVehicleOwnership",
#   LoadDatastore = TRUE,
#   SaveDatastore = FALSE,
#   DoRun = FALSE
# )
# L <- TestDat_$L
# R <- AssignVehicleOwnership(L)
#
# TestDat_ <- testModule(
#   ModuleName = "AssignVehicleOwnership",
#   LoadDatastore = TRUE,
#   SaveDatastore =TRUE,
#   DoRun = TRUE
# )
