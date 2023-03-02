#===================
#CVAVOrientation.R
#===================

#<doc>
#
## CVAVOrientation Module
#### January 5, 2022
#
#
### Model Parameter Estimation
#
#.
#
### How the Module Works
#
# * The module calculates the likelihood of a household owning a level 5
#   autonomous vehicle. A random draw then decides whether the household
#   chooses to own a level 5 AV
# * 
#
#
#
#</doc>


#=================================
#Packages used in code development
#=================================



#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================



#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

#Define the data specifications
#------------------------------
CVAVOrientationSpecifications <- list(
  #Level of geography module is applied at
  RunBy = "Region",
  #Specify new tables to be created by Inp if any
  #Specify input data
  Inp = item(
    item(
      NAME = item(
        "CSConstant",
        "CSFracAge20to29Coef",
        "CSFracAge55to64Coef",
        "CSFracAge65pCoef",
        "CSLowCarSvcFlagCoef",
        "CSHHIncBelow50KFlagCoef",
        "CSHHIncAbove100KFlagCoef",
        "CSD1BCoef"
      ),
      FILE = "region_car_svc_propensity_coef.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "numeric",
      NAVALUE = "NA",
      SIZE = 0,
      PROHIBIT = c("NA"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = item(
        "Constant for car service propensity model",
        "Age 20 to 29 household fraction coefficient for car service propensity model",
        "Age 55 to 64 household fraction coefficient for car service propensity model",
        "Age 65+ household fraction coefficient for car service propensity model",
        "Low car service level flag coefficient for car service propensity model",
        "Household income below 50K USD 2010 coefficient for car service propensity model",
        "Household income aboce 100K USD 2010 coefficient for car service propensity model",
        "D1B coefficient for car service propensity model"
      )
    ),
    item(
      NAME = item(
        "AVConstant",
        "AVFracAge20to29Coef",
        "AVFracAge55to64Coef",
        "AVFracAge65pCoef",
        "AVKidsCoef",
        "AVHHIncBelow50KCoef",
        "AVHHIncAboce100KCoef",
        "AVDistToWrkCoef"
      ),
      FILE = "region_av_lev5_propensity_coef.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "numeric",
      NAVALUE = "NA",
      SIZE = 0,
      PROHIBIT = c("NA"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = item(
        "Constant for AV level 5 propensity model",
        "Age 20 to 29 household fraction coefficient for AV level 5 propensity model",
        "Age 55 to 64 household fraction coefficient for AV level 5 propensity model",
        "Age 65+ household fraction coefficient for AV level 5 propensity model",
        "Transformed kids number coefficient for car service propoensity model",
        "Household income below 50K USD 2010 coefficient for AV level 5 propensity model",
        "Household income aboce 100K USD 2010 coefficient for AV level 5 propensity model",
        "Distance to work coefficient for AV level 5 propensity model"
      )
    )
  ),
  #Specify data to be loaded from data store
  Get = items(
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
      NAME = "Bzone",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "CarSvcLevel",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "",
      ISELEMENTOF = c("Low", "High")
    ),
    item(
      NAME =
        items("Age0to14",
              "Age15to19",
              "Age20to29",
              "Age30to54",
              "Age55to64",
              "Age65Plus"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "people",
      UNITS = "PRSN",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0
      ),
    item(
      NAME = "Income",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD.2010",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0
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
      NAME = "HhId",
      TABLE = "Worker",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "DistanceToWork",
      TABLE = "Worker",
      GROUP = "Year",
      TYPE = "distance",
      UNITS = "MI",
      NAVALUE = -1,
      PROHIBIT = c("NA", "<= 0"),
      ISELEMENTOF = "",
      SIZE = 0
      ),
    item(
      NAME = item(
        "CSConstant",
        "CSFracAge20to29Coef",
        "CSFracAge55to64Coef",
        "CSFracAge65pCoef",
        "CSLowCarSvcFlagCoef",
        "CSHHIncBelow50KFlagCoef",
        "CSHHIncAbove100KFlagCoef",
        "CSD1BCoef"
      ),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "numeric",
      NAVALUE = "NA",
      SIZE = 0,
      PROHIBIT = c("NA"),
      ISELEMENTOF = "",
      UNLIKELY = ""
    ),
    
    item(
      NAME = item(
        "AVConstant",
        "AVFracAge20to29Coef",
        "AVFracAge55to64Coef",
        "AVFracAge65pCoef",
        "AVKidsCoef",
        "AVHHIncBelow50KCoef",
        "AVHHIncAboce100KCoef",
        "AVDistToWrkCoef"
      ),
      FILE = "region_av_lev5_propensity_coef.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "numeric",
      NAVALUE = "NA",
      SIZE = 0,
      PROHIBIT = c("NA"),
      ISELEMENTOF = ""
    )
    ),
  #Specify data to saved in the data store
  Set = items(
    item(
      NAME = "AVLvl5Propensity",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "<0", ">1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Probability of household to own level 5 autonomous vehicles."
    ),
    item(
      NAME = "CarSvcPropensity",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "<0", ">1"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = "Probability of household to use car service"
    )
  )
)

#Save the data specifications list
#---------------------------------
#' Specifications list for CVAVOrientation module
#'
#' A list containing specifications for the CVAVOrientation module.
#'
#' @format A list containing 3 components:
#' \describe{
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#' }
#' @source CVAVOrientation.R script.
"CVAVOrientationSpecifications"
visioneval::savePackageDataset(CVAVOrientationSpecifications, overwrite = TRUE)


#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================
#
#
#
#

#Ancillary functions
#--------------------


#Main module function that assigns CV/AV orientation to household vehicles
#-------------------------------------------------------------------------
#' Assign level of autonomous to household vehicles
#'
#' \code{CVAVOrientation} assigns level of automation to household vehicles
#'
#' @param L A list containing data defined by the module specification.
#' @return A list containing data produced by the function consistent with the
#' module specifications.
#' @name CVAVOrientation
#' @import visioneval dplyr tidyr
#' @export
CVAVOrientation <- function(L) {
  
  #Set up
  #------
  #Copy portions of inputs list to outputs so that outputs exist to meet Set
  #specifications regardless of whether base year or other year
  Out_ls <- initDataList()
  #Function to remove attributes
  unattr <- function(X_) {
    attributes(X_) <- NULL
    X_
  }
  
  # Function to find inverse of logit
  invlogit <- function(U_){
    return(exp(U_)/(1+exp(U_)))
  }
  
  # Create input data frame
  Hh_df <- as.data.frame(L$Year$Household)
  Bzone_df <- as.data.frame(L$Year$Bzone)
  Worker_df <- as.data.frame(L$Year$Worker)
  Hh_Worker_df <- Worker_df %>% group_by(HhId) %>% 
    summarise(TotalDistToWork = sum(DistanceToWork, na.rm = TRUE))
  
  
  D_df <- Hh_df %>% left_join(Bzone_df, by = c("Bzone")) %>%
    left_join(Hh_Worker_df, by="HhId")
  D_df <- D_df %>% mutate(
    Constant = 1L,
    HHSize = pmax(1, 
                  Age0to14 + Age15to19 + Age20to29 + 
                    Age30to54 + Age55to64 + Age65Plus),
    FracAge20to29 = Age20to29/HHSize,
    FracAge55to64 = Age55to64/HHSize,
    FracAge65Plus = Age65Plus/HHSize,
    NKids = log1p(Age0to14),
    IncomeBelow50K = as.integer(Income < 50E3),
    IncomeAbove100K = as.integer(Income >= 100E3),
    TotalDistToWork = ifelse(is.na(TotalDistToWork), 0, TotalDistToWork),
    LowCarSvcLevel = as.integer(CarSvcLevel == "Low")
  ) %>% select(
    c("HhId", "Constant", "FracAge20to29", "FracAge55to64",
      "FracAge65Plus", "NKids", "IncomeBelow50K", "IncomeAbove100K",
      "D1B", "TotalDistToWork", "LowCarSvcLevel")
  )
  
  # Apply propensity models
  # AV Propensity model
  av_propensity_coef <- unlist(L$Year$Region[c("AVConstant", 
                                               "AVFracAge20to29Coef",
                                               "AVFracAge55to64Coef", 
                                               "AVFracAge65pCoef",
                                               "AVKidsCoef", 
                                               "AVHHIncBelow50KCoef",
                                               "AVHHIncAboce100KCoef",
                                               "AVDistToWrkCoef")])
  
  Hh_df$AVPropensity <- D_df %>% select("Constant", "FracAge20to29", 
                                       "FracAge55to64", "FracAge65Plus", 
                                       "NKids", "IncomeBelow50K", 
                                       "IncomeAbove100K", "TotalDistToWork") %>% 
    as.matrix(.) %*% av_propensity_coef %>%
    invlogit() %>% as.vector()
  
  # Car service propensity model
  carsvc_propensity_coef <- unlist(L$Year$Region[c("CSConstant", 
                                               "CSFracAge20to29Coef",
                                               "CSFracAge55to64Coef", 
                                               "CSFracAge65pCoef",
                                               "CSLowCarSvcFlagCoef",
                                               "CSHHIncBelow50KFlagCoef",
                                               "CSHHIncAbove100KFlagCoef",
                                               "CSD1BCoef")])
  
  Hh_df$CarSvcPropensity <- D_df %>% select("Constant", "FracAge20to29", 
                                        "FracAge55to64", "FracAge65Plus", 
                                        "LowCarSvcLevel", "IncomeBelow50K", 
                                        "IncomeAbove100K", "D1B") %>% 
    as.matrix(.) %*% carsvc_propensity_coef %>%
    invlogit() %>% as.vector()
  
  Out_ls$Year$Household <- list(
    AVLvl5Propensity = Hh_df$AVPropensity,
    CarSvcPropensity = Hh_df$CarSvcPropensity
  )
  
  #Return the results
  #------------------
  Out_ls
}


#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("CVAVOrientation")

#Test code to check specifications, loading inputs, and whether datastore
#contains data needed to run module. Return input list (L) to use for developing
#module functions
#-------------------------------------------------------------------------------
# #Load libraries and test functions
# library(visioneval)
# library(filesstrings)
# source("tests/scripts/test_functions.R")
# load("data/RoadDvmtModel_ls.rda")
# #Set up test environment
# TestSetup_ls <- list(
#   TestDataRepo = "../Test_Data/VE-CLMPO",
#   DatastoreName = "Datastore.tar",
#   LoadDatastore = TRUE,
#   TestDocsDir = "veclmpo",
#   ClearLogs = TRUE,
#   # SaveDatastore = TRUE
#   SaveDatastore = FALSE
# )
# setUpTests(TestSetup_ls)
# #Run test module
# TestDat_ <- testModule(
#   ModuleName = "CVAVOrientation",
#   LoadDatastore = TRUE,
#   SaveDatastore = FALSE,
#   DoRun = FALSE,
#   RunFor = "BaseYear"
# )
# L <- TestDat_$L
# R <- CVAVOrientation(L)
#
# TestDat_ <- testModule(
#   ModuleName = "CVAVOrientation",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = TRUE,
#   RunFor = "BaseYear"
# )
#
# TestDat_ <- testModule(
#   ModuleName = "CVAVOrientation",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = TRUE,
#   RunFor = "NotBaseYear"
# )

