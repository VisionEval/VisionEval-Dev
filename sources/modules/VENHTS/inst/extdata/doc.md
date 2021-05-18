NHTS update

There is a new package called VENHTS in the VisionEval source folder. It has been added to the build process and will be installed by using ve.build() instead of VE2001NHTS.
The package is like VE2001NHTS package previously used in VisionEval but it is using a new script “Make2009NHTSDataset.R” to process NHTS2009. The package saves four data sets: Hh_df, Veh_df, Per_df, HhTours_df
VENHTS currently only has “Make2009NHTSDataset.R” script to process 2009 NHTS data. We can bring the script from VE2001NHTS to this package so in future it will be used as the standalone package to load any NHTS version data. However, data from different NHTS versions should be saved with year specific names, because when we load VENHTS:Hh_df only the one version of data will be loaded. Scripts can be modified to use different data names for different years, e.g. Hh_df_2009 or Hh_df_2001. 
Note that any change in the VHNTS package data names should be reflected in the upstream modules which uses NHTS data in the estimation steps.
Currently all the downstream modules which use NHTS for the estimation has been modified to use VNHTS instead of VE2001NHTS. The following modules uses VENHTS data:
VELanduse::CalculateUrbanMixMeasure
VEHouseholdVehicles::AssignDrivers
VELandUse::AssignDemandManagement
VEHouseholdVehicles::AssignVehicleAge
VEHouseholdTravel::CalculateVehicleTrips
VEHouseholdTravel::CalculateAltModeTrips
VESimLandUse::AssignDemandManagement
VETravelDemandMM::HouseholdDvmtQuantileEstimation
VEHouseholdTravel::DivertSovTravel
VEHouseholdVehicles::AssignVehicleType
