#================================
#CalculateComEnergyAndEmissions.R
#================================

#<doc>
#
## CalculateComEnergyAndEmissions Module
#### January 12, 2019
#
#This module calculates the energy consumption and carbon emissions of heavy trucks and light-duty commercial service vehicles. It does not calculate the values for car service vehicles which are calculated as part of the household emissions. It also does not calculate public transit emissions which are calculated in the CalculatePtranEnergyAndEmissions module.
#
### Model Parameter Estimation
#
#This module has no estimated parameters.
#
### How the Module Works
#
#This module calculates the energy consumption and carbon emissions production from commercial travel in the following steps:
#
#* Calculate commercial service DVMT propportions by vehicle type and powertrain
#
#* Calculate heavy truck DVMT proportion by powertrain
#
#* Calculate net ecodriving and speed smoothing effects by powertrain
#
#* Identify congestion fuel economy effects by marea and powertrain type
#
#* Calculate adjusted MPG and MPKWH by vehicle type and powertrain
#
#* Calculate carbon intensity by marea and region
#
#* Calculate commercial service vehicle energy consumption and CO2e production
#
#* Calculate heavy truck energy consumption and CO2e production
#
#</doc>


#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================
#No module parameters are estimated in this module.


#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

#Define the data specifications
#------------------------------
CalculateComEnergyAndEmissionsSpecifications <- list(
  #Level of geography module is applied at
  RunBy = "Region",
  #Specify new tables to be created by Inp if any
  #Specify new tables to be created by Set if any
  #Specify input data
  Inp = items(
    item(
      NAME = "ComSvcLtTrkProp",
      FILE = "region_comsvc_lttrk_prop.csv",
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
      DESCRIPTION =
        "Regional proportion of commercial service vehicles that are light trucks"
    ),
    item(
      NAME = "AveComSvcVehicleAge",
      FILE = "region_comsvc_veh_mean_age.csv",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "time",
      UNITS = "YR",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION =
        "Average age of commercial service vehicles"
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
      NAME = "Azone",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Marea",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ElectricityCI",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/MJ",
      PROHIBIT = "< 0",
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "HhAutoFuelCI",
          "HhLtTrkFuelCI",
          "HvyTrkFuelCI"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/MJ",
      PROHIBIT = "< 0",
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "LdvEcoDrive",
        "HvyTrkEcoDrive"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "LdvSpdSmoothFactor",
        "HvyTrkSpdSmoothFactor",
        "LdvEcoDriveFactor",
        "HvyTrkEcoDriveFactor",
        "LdIceFactor",
        "LdHevFactor",
        "LdEvFactor",
        "HdIceFactor"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = "<= 0",
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "HvyTrkUrbanDvmt",
        "HvyTrkNonUrbanDvmt"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "MI/DAY",
      PROHIBIT = "<= 0",
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items("ComSvcUrbanDvmt",
              "ComSvcTownDvmt",
              "ComSvcRuralDvmt",
              "HvyTrkUrbanDvmt"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "MI/DAY",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "ComSvcAutoPropIcev",
          "ComSvcAutoPropHev",
          "ComSvcAutoPropBev",
          "ComSvcLtTrkPropIcev",
          "ComSvcLtTrkPropHev",
          "ComSvcLtTrkPropBev"
        ),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME =
        items(
          "HvyTrkPropIcev",
          "HvyTrkPropHev",
          "HvyTrkPropBev"
        ),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "ComSvcLtTrkProp",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "AveComSvcVehicleAge",
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "time",
      UNITS = "YR",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    )
  ),
  Set = items(
    item(
      NAME = items(
        "ComSvcUrbanGGE",
        "ComSvcNonUrbanGGE",
        "HvyTrkUrbanGGE"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GGE/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average daily amount of hydrocarbon fuels consumed by commercial service vehicles associated with urban household activity in gas gallon equivalents",
        "Average daily amount of hydrocarbon fuels consumed by commercial service vehicles associated with rural and town household activity in gas gallon equivalents",
        "Average daily amount of hydrocarbon fuels consumed by heavy trucks on urbanized area roadways in the Marea in gas gallon equivalents")
    ),
    item(
      NAME = items(
        "ComSvcUrbanKWH",
        "ComSvcNonUrbanKWH",
        "HvyTrkUrbanKWH"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "KWH/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average daily amount of electricity consumed by commercial service vehicles associated with urban household activity in kilowatt-hours",
        "Average daily amount of electricity consumed by commercial service vehicles associated with rural and town household activity in kilowatt-hours",
        "Average daily amount of electricity consumed by heavy trucks on urbanized area roadways in the Marea in kilowatt-hours")
    ),
    item(
      NAME = items(
        "ComSvcUrbanCO2e",
        "ComSvcNonUrbanCO2e",
        "HvyTrkUrbanCO2e"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average daily amount of carbon-dioxide equivalents produced by commercial service vehicles associated with urban household activity in grams",
        "Average daily amount of carbon-dioxide equivalents produced by commercial service vehicles associated with rural and town household activity in grams",
        "Average daily amount of carbon-dioxide equivalents produced by heavy trucks on urbanized area roadways in the Marea in grams")
    ),
    item(
      NAME = items(
        "ComSvcAveUrbanAutoCO2eRate",
        "ComSvcAveUrbanLtTrkCO2eRate",
        "HvyTrkAveUrbanCO2eRate"),
      TABLE = "Marea",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/MI",
      NAVALUE = -1,
      PROHIBIT = "< 0",
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average amount of carbon-dioxide equivalents produced by commercial service automobiles per mile of travel on urbanized area roadways in grams per mile",
        "Average amount of carbon-dioxide equivalents produced by commercial service light trucks per mile of travel on urbanized area roadways in grams per mile",
        "Average amount of carbon-dioxide equivalents produced by heavy trucks per mile of travel on urbanized area roadways in grams per mile")
    ),
    item(
      NAME = items(
        "HvyTrkNonUrbanGGE",
        "HvyTrkUrbanGGE"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GGE/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average daily amount of hydrocarbon fuels consumed by heavy trucks on rural and town roadways in the Region in gas gallon equivalents",
        "Average daily amount of hydrocarbon fuels consumed by heavy trucks on urbanized area roadways in the Region in gas gallon equivalents")
    ),
    item(
      NAME = items(
        "HvyTrkNonUrbanKWH",
        "HvyTrkUrbanKWH"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "KWH/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average daily amount of electricity consumed by heavy trucks on rural and town roadways in the Region in kilowatt-hours",
        "Average daily amount of electricity consumed by heavy trucks on urbanized area roadways in the Region in kilowatt-hours")
    ),
    item(
      NAME = items(
        "HvyTrkNonUrbanCO2e",
        "HvyTrkUrbanCO2e"),
      TABLE = "Region",
      GROUP = "Year",
      TYPE = "compound",
      UNITS = "GM/DAY",
      NAVALUE = -1,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      SIZE = 0,
      DESCRIPTION = items(
        "Average daily amount of carbon-dioxide equivalents produced by heavy trucks on rural and town roadways in the Region in grams",
        "Average daily amount of carbon-dioxide equivalents produced by heavy trucks on urbanized area roadways in the Region in grams")
    )
  )
)

#Save the data specifications list
#---------------------------------
#' Specifications list for CalculateComEnergyAndEmissions module
#'
#' A list containing specifications for the CalculateComEnergyAndEmissions
#' module.
#'
#' @format A list containing 3 components:
#' \describe{
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#' }
#' @source CalculateComEnergyAndEmissions.R script.
"CalculateComEnergyAndEmissionsSpecifications"
visioneval::savePackageDataset(CalculateComEnergyAndEmissionsSpecifications, overwrite = TRUE)


#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================

#Main module function that calculates commercial vehicle energy and emissions
#----------------------------------------------------------------------------
#' Calculate energy and emissions of commercial vehicle travel.
#'
#' \code{CalculateComEnergyAndEmissions} calculates the hydrocarbon and
#' electrical energy consumption of the travel of commercial service vehicles
#' and heavy trucks.
#'
#' This function calculates the hydrocarbon and electrical energy consumption of
#' the travel of commercial service vehicles and heavy trucks and the carbon
#' emissions produced.
#'
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#' @return A list containing the components specified in the Set
#' specifications for the module.
#' @name CalculateComEnergyAndEmissions
#' @import visioneval
#' @export
#'
CalculateComEnergyAndEmissions <- function(L) {

  #Set up
  #------
  Ma <- L$Year$Marea$Marea
  Pt <- c("ICEV", "HEV", "BEV")
  Year <- L$G$Year
  EnergyEmissionsDefaults_ls <- loadPackageDataset("PowertrainFuelDefaults_ls")

  #Calculate ComSvc DVMT proportions by vehicle type and powertrain
  #----------------------------------------------------------------
  ComSvcProp_PtVt <- local({
    #ComSvc vehicle types
    ComSvcProp_Vt <- c(
      Auto = 1 - L$Year$Region$ComSvcLtTrkProp,
      LtTrk = L$Year$Region$ComSvcLtTrkProp)
    #ComSvc powertrain types
    ComSvcAutoProp_Pt <- c(
      ICEV = L$Year$Region$ComSvcAutoPropIcev,
      HEV = L$Year$Region$ComSvcAutoPropHev,
      BEV = L$Year$Region$ComSvcAutoPropBev
    )
    ComSvcLtTrkProp_Pt <- c(
      ICEV = L$Year$Region$ComSvcLtTrkPropIcev,
      HEV = L$Year$Region$ComSvcLtTrkPropHev,
      BEV = L$Year$Region$ComSvcLtTrkPropBev
    )
    #ComSvc vehicle proportions by vehicle types and powertrain types
    ComSvcProp_VtPt <- cbind(
      Auto = ComSvcAutoProp_Pt,
      LtTrk = ComSvcLtTrkProp_Pt
    )
    sweep(ComSvcProp_VtPt, 2, ComSvcProp_Vt, "*")
  })

  #Calculate HvyTrk DVMT proportions by powertrain
  #-----------------------------------------------
  HvyTrkProp_Pt <- c(
    ICEV = L$Year$Region$HvyTrkPropIcev,
    HEV = L$Year$Region$HvyTrkPropHev,
    BEV = L$Year$Region$HvyTrkPropBev
  )

  #Identify net eco-driving and speed smoothing factors by Marea
  #-------------------------------------------------------------
  #Function to calculate net factor
  calcNetEcoSSFactor <- function(Type, EcoOnly = FALSE){
    PropEco_Ma <-  L$Year$Marea[[paste0(Type, "EcoDrive")]]
    EcoFactor_Ma <- L$Year$Marea[[paste0(Type, "EcoDriveFactor")]]
    SmFactor_Ma <- L$Year$Marea[[paste0(Type, "SpdSmoothFactor")]]
    if (EcoOnly) {
      Net_Ma <- EcoFactor_Ma * PropEco_Ma + (1 - PropEco_Ma)
    } else {
      Net_Ma <- pmax(
        SmFactor_Ma,
        EcoFactor_Ma * PropEco_Ma + SmFactor_Ma * (1 - PropEco_Ma)
      )
    }
    names(Net_Ma) <- Ma
    Net_Ma
  }
  #Calculate ComSvc factors by Marea
  ComSvcUrbanEcoSmooth_Ma <- calcNetEcoSSFactor("Ldv")
  ComSvcRuralEcoSmooth_Ma <- calcNetEcoSSFactor("Ldv", EcoOnly = TRUE)
  #Calculate HvyTrk factors by Marea
  HvyTrkUrbanEcoSmooth_Ma <- calcNetEcoSSFactor("HvyTrk")
  HvyTrkRuralEcoSmooth_Ma <- calcNetEcoSSFactor("HvyTrk", EcoOnly = TRUE)

  #Identify congestion factors by Marea and powertrain
  #---------------------------------------------------
  #ComSvc factors
  ComSvcCong_MaPt <- cbind(
    ICEV = L$Year$Marea$LdIceFactor,
    HEV = L$Year$Marea$LdHevFactor,
    BEV = L$Year$Marea$LdEvFactor
  )
  rownames(ComSvcCong_MaPt) <- Ma
  #HvyTrk factors
  HvyTrkCong_MaPt <-
    array(1, dim = c(length(Ma), length(Pt)), dimnames = list(Ma, Pt))
  HvyTrkCong_MaPt[,"ICEV"] <- L$Year$Marea$HdIceFactor

  #Calculate MPG and MPkWh
  #-----------------------
  MpgMpkwh_VtPt <- local({
    LdvPtChar_df <-
      EnergyEmissionsDefaults_ls$LdvPowertrainCharacteristics_df
    EndIdx <-
      with(LdvPtChar_df, which(as.character(ModelYear) == as.character(Year)))
    StartIdx <-
      as.integer(round(EndIdx - (2 * L$Year$Region$AveComSvcVehicleAge)))
    if (StartIdx < 1) {
      NumRowsToDup <- 1 - StartIdx
      StartIdx <- 1
      EndIdx <- 1 + NumRowsToDup
      for (i in 1:NumRowsToDup) {
        LdvPtChar_df <- rbind(LdvPtChar_df[1,], LdvPtChar_df)
      }
    }
    LdvPtChar_ <- colMeans(LdvPtChar_df[StartIdx:EndIdx,], na.rm = TRUE)[-1]
    AutoMpgMpkwh_Pt <- c(
      ICEV = unname(LdvPtChar_["AutoIcevMpg"]),
      HEV = unname(LdvPtChar_["AutoHevMpg"]),
      BEV = unname(LdvPtChar_["AutoBevMpkwh"])
    )
    LtTrkMpgMpkwh_Pt <- c(
      ICEV = unname(LdvPtChar_["LtTrkIcevMpg"]),
      HEV = unname(LdvPtChar_["LtTrkHevMpg"]),
      BEV = unname(LdvPtChar_["LtTrkBevMpkwh"])
    )
    #Calculate HvyTrk values
    HTChar_df <-
      EnergyEmissionsDefaults_ls$HvyTrkPowertrainCharacteristics_df
    approxWithNaCheck <- function(Years_, Values_, Year) {
      YearDiff_ <- abs(Years_ - Year)
      if (any(YearDiff_ == 0)) {
        Values_[which(YearDiff_ == 0)]
      } else {
        Min2Vals_ <-sort(YearDiff_)[1:2]
        YearBnds_ <- which(YearDiff_ %in% Min2Vals_)
        if (any(is.na(Values_[YearBnds_]))) {
          BndValues_ <- Values_[YearBnds_]
          if (all(is.na(BndValues_))) {
            NA
          } else {
            BndValues_[!is.na(BndValues_)]
          }
          BndValues_[!is.na(BndValues_)]
        } else {
          approx(Years_, Values_, Year)$y
        }
      }
    }
    HvyTrkMpgMpkwh_Pt <- c(
      ICEV = approxWithNaCheck(HTChar_df$Year, HTChar_df$HvyTrkIcevMpg, as.numeric(Year)),
      HEV  = approxWithNaCheck(HTChar_df$Year, HTChar_df$HvyTrkHevMpg, as.numeric(Year)),
      BEV  = approxWithNaCheck(HTChar_df$Year, HTChar_df$HvyTrkBevMpkwh, as.numeric(Year))
    )
    #Return the results
    do.call(rbind, list(
      Auto = AutoMpgMpkwh_Pt,
      LtTrk = LtTrkMpgMpkwh_Pt,
      HvyTrk = HvyTrkMpgMpkwh_Pt
    ))
  })

  #Calculate carbon intensity by Marea and Region
  #----------------------------------------------
  ElectricityCI_Ma <-
    tapply(L$Year$Azone$ElectricityCI, L$Year$Azone$Marea, mean)[Ma]
  ElectricityCI <- mean(L$Year$Azone$ElectricityCI)
  HhAutoFuelCI <- L$Year$Region$HhAutoFuelCI
  HhLtTrkFuelCI <- L$Year$Region$HhLtTrkFuelCI
  HvyTrkFuelCI <- L$Year$Region$HvyTrkFuelCI

  #Calculate ComSvc energy consumption and CO2e production
  #-------------------------------------------------------
  #Define function to calculate ComSvc energy consumption by Marea
  calcComSvcEnergyEmissions <- function(Type) {
    Vt <- c("Auto", "LtTrk")
    #Calculate DVMT by powertrain, vehicle type, and Marea
    if (Type == "Rural") {
      Dvmt_Ma <- with(L$Year$Marea, ComSvcRuralDvmt + ComSvcTownDvmt)
    } else {
      Dvmt_Ma <- L$Year$Marea$ComSvcUrbanDvmt
    }
    names(Dvmt_Ma) <- Ma
    Dvmt_PtVtMa <- outer(ComSvcProp_PtVt, Dvmt_Ma, "*")
    Dvmt_MaVt <- t(apply(Dvmt_PtVtMa, c(2,3), sum))
    #Calculate MPG & MPkWh by powertrain, vehicle type, and Marea
    if (Type == "Urban") {
      MpgMpkwhAdj_MaPt <- ComSvcCong_MaPt
      MpgMpkwhAdj_MaPt[,"ICEV"] <- ComSvcUrbanEcoSmooth_Ma
    } else {
      MpgMpkwhAdj_MaPt <- ComSvcCong_MaPt * 0 + 1
      MpgMpkwhAdj_MaPt[,"ICEV"] <- ComSvcRuralEcoSmooth_Ma
    }
    MpgMpkwh_PtVt <- t(MpgMpkwh_VtPt[Vt,])
    MpgMpkwh_PtVtMa <-
      array(0, dim = c(length(Pt), length(Vt), length(Ma)), dimnames = list(Pt, Vt, Ma))
    for (ma in Ma) {
      MpgMpkwh_PtVtMa[,,ma] <-
        sweep(MpgMpkwh_PtVt, 1, MpgMpkwhAdj_MaPt[ma,], "*")
    }
    #Calculate energy consumed by powertrain, vehicle type, and Marea
    Energy_PtVtMa <- Dvmt_PtVtMa / MpgMpkwh_PtVtMa
    #Convert to 0 any NaN numbers. NaN are present when there are no vehicles
    #of a powertrain type. Where there are no vehicles of a type, no energy
    #would be consumed for that type.
    Energy_PtVtMa[is.nan(Energy_PtVtMa)] <- 0
    #Aggregate by energy type (fuel vs. electricity)
    Et <- c("GGE", "KWH")
    Energy_EtVtMa <-
      array(0, dim = c(2, 2, length(Ma)), dimnames = list(Et, Vt, Ma))
    for (ma in Ma) {
      Energy_EtVtMa[,,ma] <-
        rbind(colSums(Energy_PtVtMa[1:2,,ma]), Energy_PtVtMa[3,,ma])
    }
    #Convert energy to megajoules
    EnergyMJ_EtVtMa <- Energy_EtVtMa * 0
    for (ma in Ma) {
      EnergyMJ_EtVtMa[,,ma] <- rbind(
        convertUnits(Energy_EtVtMa[1,,ma], "energy", "GGE", "MJ")$Values,
        convertUnits(Energy_EtVtMa[2,,ma], "energy", "KWH", "MJ")$Values
      )
    }
    #Calculate CO2e emissions
    CO2e_EtVtMa <- EnergyMJ_EtVtMa * 0
    for (ma in Ma) {
      CI_EtVt <-
        rbind(c(HhAutoFuelCI, HhLtTrkFuelCI), rep(ElectricityCI_Ma[ma], 2))
      CO2e_EtVtMa[,,ma] <- EnergyMJ_EtVtMa[,,ma] * CI_EtVt
    }
    CO2e_MaVt <- t(apply(CO2e_EtVtMa, c(2,3), sum))
    #Return the result
    list(Energy_EtVtMa = Energy_EtVtMa,
         CO2e_MaVt = CO2e_MaVt,
         Dvmt_MaVt = Dvmt_MaVt)
  }
  #Calculate ComSvc energy consumption by Marea and energy type
  ComSvcUrbanEE_ls <- calcComSvcEnergyEmissions("Urban")
  ComSvcRuralEE_ls <- calcComSvcEnergyEmissions("Rural")

  #Calculate urban heavy truck energy consumption and CO2e production
  #------------------------------------------------------------------
  HvyTrkUrbanEE_ls <- local({
    #Calculate DVMT by Marea and powertrain
    HvyTrkDvmt_Ma <- L$Year$Marea$HvyTrkUrbanDvmt
    names(HvyTrkDvmt_Ma) <- Ma
    HvyTrkDvmt_MaPt <- outer(HvyTrkDvmt_Ma, HvyTrkProp_Pt, "*")
    #Calculate average MPG and MPKWH by Marea and powertrain
    HvyTrkMpgMpkwh_MaPt <-
      sweep(HvyTrkCong_MaPt, 2, MpgMpkwh_VtPt["HvyTrk",], "*")
    HvyTrkMpgMpkwh_MaPt[,"ICEV"] <-
      HvyTrkMpgMpkwh_MaPt[,"ICEV"] * HvyTrkUrbanEcoSmooth_Ma
    #Calculate energy in GGE and KWH by Marea and powertrain
    HvyTrkEnergy_MaPt <- HvyTrkDvmt_MaPt / HvyTrkMpgMpkwh_MaPt
    HvyTrkEnergy_MaPt[is.na(HvyTrkEnergy_MaPt)] <- 0
    #Calculate energy in GGE and KWH by Marea and energy type
    Et <- c("GGE", "KWH")
    HvyTrkEnergy_MaEt <-
      array(0, dim = c(length(Ma), length(Et)), dimnames = list(Ma, Et))
    for (ma in Ma) {
      HvyTrkEnergy_MaEt[ma,] <-
        c(sum(HvyTrkEnergy_MaPt[ma, c("ICEV", "HEV")]),
          HvyTrkEnergy_MaPt[ma,c("BEV")])
    }
    #Convert energy consumption to MJ
    HvyTrkEnergyMJ_MaEt <- HvyTrkEnergy_MaEt * 0
    for (ma in Ma) {
      HvyTrkEnergyMJ_MaEt[ma,] <- c(
        convertUnits(HvyTrkEnergy_MaEt[ma,"GGE"], "energy", "GGE", "MJ")$Values,
        convertUnits(HvyTrkEnergy_MaEt[ma,"KWH"], "energy", "KWH", "MJ")$Values
      )
    }
    #Calculate CO2e by Marea and energy type
    HvyTrkCO2e_MaEt <- HvyTrkEnergyMJ_MaEt * 0
    for (ma in Ma) {
      HvyTrkCI_Et <- c(HvyTrkFuelCI, ElectricityCI_Ma[ma])
      HvyTrkCO2e_MaEt[ma,] <- HvyTrkEnergyMJ_MaEt[ma,] * HvyTrkCI_Et
    }
    #Total CO2e by Marea
    HvyTrkCO2e_Ma <- apply(HvyTrkCO2e_MaEt, 1, sum)
    #Return list of energy, emissions, and DVMT
    list(
      Energy_MaEt = HvyTrkEnergy_MaEt,
      CO2e_Ma = HvyTrkCO2e_Ma,
      Dvmt_Ma = HvyTrkDvmt_Ma
    )
  })

  #Calculate rural heavy truck energy and emissions
  #------------------------------------------------
  HvyTrkRuralEE_ls <- local({
    #Rural regional DVMT
    HvyTrkDvmt <- L$Year$Region$HvyTrkNonUrbanDvmt
    #If no rural DVMT, return list containing 0 values
    if (is.na(HvyTrkDvmt)) {
      return(list(Energy_Et = c(GGE = 0, KWH = 0), CO2e = 0, Dvmt = 0))
      #Otherwise calculate energy and emissions values
    } else {
      HvyTrkDvmt_Pt <- HvyTrkDvmt * HvyTrkProp_Pt
      #Calculate average MPG and MPKWH by Marea and powertrain
      HvyTrkMpgMpkwh_Pt <- MpgMpkwh_VtPt["HvyTrk",]
      AveHvyTrkEcoDriveFactor <-
        sum(L$Year$Marea$HvyTrkEcoDriveFactor * L$Year$Marea$HvyTrkUrbanDvmt) /
        sum(L$Year$Marea$HvyTrkUrbanDvmt)
      HvyTrkMpgMpkwh_Pt["ICEV"] <-
        HvyTrkMpgMpkwh_Pt["ICEV"] * AveHvyTrkEcoDriveFactor
      #Calculate energy in GGE and KWH by Marea and powertrain
      HvyTrkEnergy_Pt <- HvyTrkDvmt_Pt / HvyTrkMpgMpkwh_Pt
      HvyTrkEnergy_Pt[is.na(HvyTrkEnergy_Pt)] <- 0
      #Calculate energy in GGE and KWH by Marea and energy type
      Et <- c("GGE", "KWH")
      HvyTrkEnergy_Et <-
        c(sum(HvyTrkEnergy_Pt[c("ICEV", "HEV")]), HvyTrkEnergy_Pt["BEV"])
      names(HvyTrkEnergy_Et) <- Et
      #Convert energy consumption to MJ
      HvyTrkEnergyMJ_Et <- c(
        convertUnits(HvyTrkEnergy_Et["GGE"], "energy", "GGE", "MJ")$Values,
        convertUnits(HvyTrkEnergy_Et["KWH"], "energy", "KWH", "MJ")$Values
      )
      #Calculate CO2e
      HvyTrkCI_Et <- c(HvyTrkFuelCI, ElectricityCI)
      HvyTrkCO2e <- sum(HvyTrkEnergyMJ_Et * HvyTrkCI_Et)
    }
    #Return list of energy, emissions, and DVMT
    return(list(
      Energy_Et = HvyTrkEnergy_Et,
      CO2e = HvyTrkCO2e,
      Dvmt = HvyTrkDvmt
    ))
  })

  #Calculate commercial services and heavy truck vehicle urban emissions rates
  #---------------------------------------------------------------------------
  UrbanCo2eRatesByMarea_ls <- data.frame(
    ComSvcAuto = with(ComSvcUrbanEE_ls, CO2e_MaVt[,"Auto"] / Dvmt_MaVt[,"Auto"]),
    ComSvcLtTrk = with(ComSvcUrbanEE_ls, CO2e_MaVt[,"LtTrk"] / Dvmt_MaVt[,"LtTrk"]),
    HvyTrk = with(HvyTrkUrbanEE_ls, CO2e_Ma / Dvmt_Ma)
  )
  UrbanCo2eRatesByMarea_ls <- lapply(UrbanCo2eRatesByMarea_ls, function(x) {
    x[is.nan(x)] <- NA
    x
  })

  #Return the results
  #------------------
  Out_ls <- initDataList()
  Out_ls$Year <- list()
  Out_ls$Year$Marea <- list(
    ComSvcUrbanGGE = apply(ComSvcUrbanEE_ls$Energy_EtVtMa["GGE",,,drop = FALSE], 3, sum),
    ComSvcNonUrbanGGE = apply(ComSvcRuralEE_ls$Energy_EtVtMa["GGE",,,drop = FALSE], 3, sum),
    HvyTrkUrbanGGE = HvyTrkUrbanEE_ls$Energy_MaEt[,"GGE"],
    ComSvcUrbanKWH = apply(ComSvcUrbanEE_ls$Energy_EtVtMa["KWH",,,drop = FALSE], 3, sum),
    ComSvcNonUrbanKWH = apply(ComSvcRuralEE_ls$Energy_EtVtMa["KWH",,,drop = FALSE], 3, sum),
    HvyTrkUrbanKWH = HvyTrkUrbanEE_ls$Energy_MaEt[,"KWH"],
    ComSvcUrbanCO2e = apply(ComSvcUrbanEE_ls$CO2e_MaVt, 1, sum),
    ComSvcNonUrbanCO2e = apply(ComSvcRuralEE_ls$CO2e_MaVt, 1, sum),
    HvyTrkUrbanCO2e = HvyTrkUrbanEE_ls$CO2e_Ma,
    ComSvcAveUrbanAutoCO2eRate = UrbanCo2eRatesByMarea_ls$ComSvcAuto,
    ComSvcAveUrbanLtTrkCO2eRate = UrbanCo2eRatesByMarea_ls$ComSvcLtTrk,
    HvyTrkAveUrbanCO2eRate = UrbanCo2eRatesByMarea_ls$HvyTrk
  )
  Out_ls$Year$Region <- list(
    HvyTrkNonUrbanGGE = unname(HvyTrkRuralEE_ls$Energy_Et["GGE"]),
    HvyTrkUrbanGGE = sum(HvyTrkUrbanEE_ls$Energy_MaEt[,"GGE"]),
    HvyTrkNonUrbanKWH = unname(HvyTrkRuralEE_ls$Energy_Et["KWH"]),
    HvyTrkUrbanKWH = sum(HvyTrkUrbanEE_ls$Energy_MaEt[,"KWH"]),
    HvyTrkNonUrbanCO2e = HvyTrkRuralEE_ls$CO2e,
    HvyTrkUrbanCO2e = sum(HvyTrkUrbanEE_ls$CO2e_Ma)
  )
  Out_ls
}


#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("CalculateComEnergyAndEmissions")

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
# # setUpTests(TestSetup_ls)
# #Run test module
# TestDat_ <- testModule(
#   ModuleName = "CalculateComEnergyAndEmissions",
#   LoadDatastore = TRUE,
#   SaveDatastore = FALSE,
#   DoRun = FALSE,
#   RequiredPackages = "VEPowertrainsAndFuels"
# )
# L <- TestDat_$L
# R <- CalculateComEnergyAndEmissions(L)
#
# TestDat_ <- testModule(
#   ModuleName = "CalculateComEnergyAndEmissions",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = TRUE,
#   RequiredPackages = "VEPowertrainsAndFuels"
# )

