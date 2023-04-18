library(sf)
library(here)
library(data.table)
library(tidycensus)
library(dplyr)

# Easier than changing the working directory
PATH = file.path(here(),'sources/modules/VEPopulationSim')
YEAR=2017
STATE=41 # Oregon


# Census API Key: https://walker-data.com/tidycensus/reference/census_api_key.html

if( !('CENSUS_API_KEY' %in% names(Sys.getenv())) ) readRenviron(file.path(PATH, '.key'))
#census_api_key(key, overwrite = FALSE, install = FALSE)


# Gather our parameters
source(file.path(PATH, 'inst/extdata/dataprep_settings.R'))

# BLOCKGROUP
# B11016  HOUSEHOLD TYPE BY HOUSEHOLD SIZE
# B01003  TOTAL POPULATION
# B25007  TENURE BY AGE OF HOUSEHOLDER
# B19001  HOUSEHOLD INCOME IN THE PAST 12 MONTHS (IN 2020 INFLATION-ADJUSTED DOLLARS)
# B02001  RACE


# TRACT LEVEL
# B08202  HOUSEHOLD SIZE BY NUMBER OF WORKERS IN HOUSEHOLD
# B25024  UNITS IN STRUCTURE


# Fetch the table column variables
acs_vars <- data.table(load_variables(YEAR, 'acs5'))


#### GEO CROSSWALK & ADDITIONAL ZONE NAMES ####
# Function to calculate centroids (If we don't have bzone_lat_lon.csv)
get_centroids <- function(geo) {
  centroids <- st_centroid(geo$geometry)
  coords <- data.table(st_coordinates(centroids))
  coords <- setNames(coords, c('Longitude', 'Latitude'))[, .(Latitude, Longitude)]
  
  latlon <- data.table(Geo=geo$GEOID, Year='2010', coords)
  latlon <- latlon[Geo %in% unique(xwalk$TAZID),]
  latlon[ , Geo := paste0('AMATS', Geo)]
  latlon[match(bzones, Geo),]
  return(latlon)
}


# Get GEOID list
bzones <- fread(file.path(PATH, 'inst/dataprep_sources/',params$zone_list), colClasses="character", drop='Year')
bzones <- unique(bzones)

# Read geography file
tf <- tempfile()
unzip(file.path(PATH, 'inst/extdata/dataprep_sources', params$geography), exdir=tf)
geo <- st_read(file.path(tf, paste0(sub('\\..*$', '', params$geography), '.shp')))
unlink(tf)

# Remove '10' from GEOID10
colnames(geo) <- gsub('10', '', colnames(geo))

# Get blocks that bzones are within
bpoints <- st_as_sf(bzones, coords = c("Longitude", "Latitude"), crs = 4326)

within_id <- st_within(st_transform(bpoints, crs=st_crs(geo$geometry)), geo$geometry)
bg_list <- data.table(geo)[as.numeric(within_id), GEOID]
tract_list <- unique(substr(bg_list, 0, 11))

# Tract to PUMAS
t2p10 <- fread(file.path(PATH, 'inst/extdata/dataprep_sources', params$pumaxwalk), colClasses = 'character')
t2p10[ , GEOID_TRACT_10 := paste0(STATEFP, COUNTYFP, TRACTCE)]

# # Convert from 2020 to 2010, this is a one off process because PUMS 2020 relations are not yet available.
# # bgto20 <- fread(file.path(PATH, 'inst/extdata/dataprep_sources/', 'tab20_blkgrp20_blkgrp10_st41.txt'), colClasses = 'character')
# tractto20 <- fread(file.path(PATH, 'inst/extdata/dataprep_sources/', 'tab20_tract20_tract10_st41.txt'), colClasses = 'character')
# 
# # Find which 2020 blocks are in the 2010 pumas
# t2p20 <- merge(tractto20, t2p10, by='GEOID_TRACT_10')
# t2p20 <- t2p20[GEOID_TRACT_20 %in% tract_list, .(GEOID_TRACT_20, GEOID_TRACT_10, PUMA5CE, AREALAND_PART)]
# 
# # Remove multiple overlaps. messy but whatever...
# t2p20 <- t2p20[t2p20[, .I[which.max(AREALAND_PART)], by=GEOID_TRACT_20]$V1, .(GEOID_TRACT_20, PUMA5CE)]
# 
# # Re-format
# t2p <- t2p20[ , .(STATEFP = substr(GEOID_TRACT_20, 0, 2),
#                     COUNTYFP = substr(GEOID_TRACT_20, 3, 5),
#                     TRACTCE = substr(GEOID_TRACT_20, 6, 11),
#                     PUMA = PUMA5CE,
#                     REGION = 1)]

# Re-format
t2p <- t2p10[GEOID_TRACT_10 %in% tract_list, .(GEOID_TRACT_10, GEOID_TRACT_10, PUMA5CE)]
t2p <- t2p10[ , .(STATEFP = substr(GEOID_TRACT_10, 0, 2),
                  COUNTYFP = substr(GEOID_TRACT_10, 3, 5),
                  TRACTCE = substr(GEOID_TRACT_10, 6, 11),
                  PUMA = PUMA5CE,
                  REGION = 1)]
t2p$REGION <- 1

# Get basic elements
geo_cross_walk <- data.table(geo)[as.numeric(within_id), .(STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, GEOID)]
geo_cross_walk <- unique(merge(geo_cross_walk, t2p))
geo_cross_walk[ , TRACTGEOID := paste0(STATEFP, COUNTYFP, TRACTCE)]

length(unique(geo_cross_walk$TRACTGEOID))
length(unique(geo_cross_walk$GEOID))

# Final block list (not ideal)
bg_list <- unique(geo_cross_walk$GEOID)
tract_list <- unique(geo_cross_walk$TRACTGEOID)



#### BLOCK GROUPS ####

# Get the column labels
bg_vars <- list(
  hhsiz = acs_vars[grepl('B11016_',name), ],
  race  = acs_vars[grepl('B02001_',name), ],
  # hhage = acs_vars[grepl('B25007_',name), ],
  page = acs_vars[grepl('B01001_',name), ],
  hhinc = acs_vars[grepl('B19001_',name), ],
  pinc = acs_vars[grepl('B19301_001',name), ],
  pop = acs_vars[grepl('B01003_',name), ]
  )


# Drop the ones we don't need
drop_vars <- c('B11016_002', 'B11016_009',
               'B25007_002', 'B25007_012',
               'B01001_001', 'B01001_002', 'B01001_026',
               'B02001_001', 'B02001_009', 'B02001_010',
               'B19001_001')

bg_vars <- lapply(bg_vars, function(x) x[!(name %in% drop_vars),])


# Column bins for aggregation
bg_bins <- list(
  totals = list(# These don't get summed up
    POPBASE = 'B01003_001',
    HHBASE = 'B11016_001',
    PINC = 'B19301_001'
  ),
  hhsiz_bins = list(
    HHSIZ1 = "B11016_010",
    HHSIZ2 = c("B11016_003", "B11016_011"),
    HHSIZ3 = c("B11016_004", "B11016_012"),
    HHSIZ4 = c("B11016_005", "B11016_006", "B11016_007", "B11016_008",
               "B11016_013", "B11016_014", "B11016_015", "B11016_016")
  ),
  age_bins = list(
    PAGE0TO14 = c(paste0("B01001_",sprintf("%03d",3:5)), paste0("B01001_",sprintf("%03d",27:29))),
    PAGE15TO19 = c("B01001_006", "B01001_007", "B01001_030", "B01001_031"),
    PAGE20TO29 = c(paste0("B01001_",sprintf("%03d",8:11)), paste0("B01001_",sprintf("%03d",32:35))),
    PAGE30TO54 = c(paste0("B01001_",sprintf("%03d",12:16)), paste0("B01001_",sprintf("%03d",36:40))),
    PAGE55TO64 = c(paste0("B01001_",sprintf("%03d",17:19)), paste0("B01001_",sprintf("%03d",41:43))),
    PAGE65PLUS = c(paste0("B01001_",sprintf("%03d",20:25)), paste0("B01001_",sprintf("%03d",44:49)))
  ),
  # hhage_bins = list(
  #   HHAGE1 = c("B25007_003", "B25007_013"),
  #   HHAGE2 = c("B25007_004", "B25007_005", "B25007_006", "B25007_014", "B25007_015", "B25007_016"),
  #   HHAGE3 = c("B25007_007", "B25007_008", "B25007_017", "B25007_018"),
  #   HHAGE4 = c("B25007_009", "B25007_010", "B25007_011",
  #              "B25007_019", "B25007_020", "B25007_021")
  # ),
  hhrace_bins = list(
    PRACWHT = "B02001_002",
    PRACBLK = "B02001_003",
    PRACNAT = "B02001_004",
    PRACASN = "B02001_005",
    PRACPAC = "B02001_006",
    PRACOTH = "B02001_007",
    PRACMUL = "B02001_008"
  ),
  hhinc_bins = list(
    HHINC1 = c("B19001_002", "B19001_003", "B19001_004"),
    HHINC2 = c("B19001_005", "B19001_006", "B19001_007", "B19001_008", "B19001_009"),
    HHINC3 = c("B19001_010", "B19001_011", "B19001_012"),
    HHINC4 = c("B19001_013", "B19001_014", "B19001_015", "B19001_016", "B19001_017")
  )
)

# Fetch data
bg_vars_vec <- unlist(sapply(bg_vars, function(x) x$name), use.names = F)

bg_raw <- data.table(
  get_acs(geography = 'block group',
          year=YEAR,
          state=STATE,
          variables = bg_vars_vec, 
          cache_table = T)
)


# Select the GEOIDs
bg_raw <- bg_raw[GEOID %in% bg_list]

# Aggregate & cleanup
# sum
bg_agg <- rbindlist(lapply(bg_bins, function(b) {
  rbindlist(lapply(names(b), function(x) {
    bg_raw[variable %in% b[[x]], .('value'=sum(estimate), 'label' = x), by = GEOID]
    }))
  }))

bg_data <- dcast(bg_agg, 
                 GEOID~label,
                 value.var = 'value'
                 )[,c('GEOID', unlist(sapply(bg_bins, names), use.names=F)), with=F]


#### TRACTS ####
# Get the column labels
tract_vars <- list(
  hhwrk = acs_vars[grepl('B08202',name), ],
  hhtyp = acs_vars[grepl('B25024',name), ],
  pop = acs_vars[grepl('B01003_',name), ]
)

# Drop the ones we don't need
drop_vars <- c('B08202_006', 'B08202_009', 'B08202_012', 'B25024_001')
tract_vars <- lapply(tract_vars, function(x) x[!(name %in% drop_vars),])

# Bins
tract_bins <- list(
  totals = list(
    POPBASE = 'B01003_001',
    HHBASE = 'B08202_001'
  ),
  hhwrk_bins = list(
    HHWRK0 = tract_vars$hhwrk[grepl('No workers', label), name],
    HHWRK1 = tract_vars$hhwrk[grepl('1 worker', label), name],
    HHWRK2 = tract_vars$hhwrk[grepl('2 workers', label), name],
    HHWRK3 = tract_vars$hhwrk[grepl('3 or more workers', label), name]
  ),
  hhtyp = list(
    SF = c('B25024_002', 'B25024_003'),
    DUP = c('B25024_004'),
    MF = paste0('B25024_00', 5:9),
    MH = c('B25024_010', 'B25024_011')
  )
)


# Fetch data
tract_vars_vec <- unlist(sapply(tract_vars, function(x) x$name), use.names = F)

tract_raw <- data.table(
  get_acs(geography = 'tract',
          year=YEAR,
          state=STATE,
          variables = tract_vars_vec,
          cache_table = T)
)

# Select the GEOIDs
tract_raw <- tract_raw[GEOID %in% tract_list]

# Aggregate & cleanup
tract_agg <- rbindlist(lapply(tract_bins, function(b) {
  rbindlist(lapply(names(b), function(x) {
    tract_raw[variable %in% b[[x]], .('value'=sum(estimate), 'label' = x), by = GEOID]
  }))
}))

tract_data <- dcast(tract_agg, 
                 GEOID~label,
                 value.var = 'value'
                 )[,c('GEOID', unlist(sapply(tract_bins, names), use.names=F)), with=F]

# Name differentiation
setnames(tract_data,'GEOID','TRACTGEOID')


#### PUMS SEED ####
# Latest pums year
PUMS_YEAR <- pums_variables %>% 
  mutate(year=as.integer(year)) %>%
  filter(year <= YEAR) %>% 
  select(year) %>% max()

# use this to look for the vars we need
pums_vars <- pums_variables %>% 
  filter(year == PUMS_YEAR, survey == "acs5") %>% 
  distinct(var_code, var_label, data_type, level)

# list the vars we need
pums_vars_vec <- c("SERIALNO", "PUMA", "ST", "WGTP", "PWGTP", "SPORDER",
                   "AGEP", "NP", "HINCP", "PINCP", "ADJINC", "TYPE",
                   "ESR", "RAC1P", "BLD") 

#### Fetch the data
pums_data_raw <- data.table(get_pums(
  variables = pums_vars_vec,
  state = STATE,
  survey = "acs5",
  year = PUMS_YEAR
))

#### Recodes
# Not group quarters
pums_data <- pums_data_raw[TYPE == 1, ]

# Age of reference person "head of household"
pums_data <- merge(pums_data, 
                   pums_data[SPORDER==1, .(AGEHOH=AGEP), by = SERIALNO],
                   all = T)

# Adjusted income
pums_data[ , HHINCADJ := HINCP * as.numeric(ADJINC)]
pums_data[ , PINCADJ := PINCP * as.numeric(ADJINC)]
# pums_data[HHINCADJ < 0, HHINCADJ := 0]

# Race
#pums_data[ , HHRAC := ifelse(uniqueN(RAC1P)>1,9,RAC1P), by = SERIALNO]

# Number of workers
work_codes <- c(1,2,4,5)
pums_data <- merge(pums_data, 
                   pums_data[ESR %in% work_codes, .(NW=.N), by=SERIALNO],
                   all=T)
pums_data[is.na(NW), NW := 0]

# If person is a worker
pums_data[,WORKER:=as.integer(ESR %in% work_codes)]

# Housing type
pums_data[BLD %in% sprintf("%02d",c(1,10)), HTYPE := "MH"]
pums_data[BLD %in% sprintf("%02d",2:3), HTYPE := "SF"]
pums_data[BLD %in% sprintf("%02d",4), HTYPE := "DUP"]
pums_data[BLD %in% sprintf("%02d",5:9), HTYPE := "MF"]

# dummy region
pums_data$REGION <- 1
pums_data[ , hhnum := .GRP, by = SERIALNO]

# HH/PER vars
base_vars <- c('SERIALNO', 'hhnum', 'PUMA', 'REGION')
hh_vars <- c(base_vars, 'NP', 'NW', 'HHINCADJ', 'WGTP', 'HTYPE')
per_vars <- c(base_vars, 'SPORDER', 'PWGTP', 'RAC1P', 'AGEP', 'PINCADJ', 'WORKER')


#### FINAL PUMS SEED DATA ###
# Extract & format seed data
seed_pums_hh <- unique(pums_data[,hh_vars, with=F])
seed_pums_per <- pums_data[,per_vars, with=F]


#### FINAL CONTROL TOTALS ####

# BG totals
control_totals_bg <- merge(bg_data, 
                           geo_cross_walk[ , .(GEOID, STATEFP, COUNTYFP, TRACTCE, TRACTGEOID, PUMA, REGION)],
                           by='GEOID')

# tract totals
control_totals_tract <- merge(tract_data, 
                           unique(geo_cross_walk[ , .(STATEFP, COUNTYFP, TRACTCE, TRACTGEOID, PUMA, REGION)]),
                           by='TRACTGEOID')

#### SCALED TOTALS ####

# Trust blocks b/c tract might overlap outside of region
scaled_control_totals_meta <- colSums(tract_data[,!c("TRACTGEOID","POPBASE")])
scaled_control_totals_meta <- scaled_control_totals_meta * bg_data[,sum(POPBASE)] / tract_data[,sum(POPBASE)]
scaled_control_totals_meta <- round(scaled_control_totals_meta)

# Add in the block totals
scaled_control_totals_meta <- as.data.table(t(
  c("REGION"=1, scaled_control_totals_meta, colSums(bg_data[,!"GEOID"]))
  ))


### CONFIRM GEOGRAPHY NAMES ####
# setnames(geo_cross_walk, c('TRACTGEOID', 'GEOID'), c('TRACT', 'BG'))
# setnames(control_totals_bg, c('TRACTGEOID', 'GEOID'), c('TRACT', 'BG'))
# setnames(control_totals_tract, 'TRACTGEOID', 'TRACT')


#### SAVE OUTPUT ####
fwrite(geo_cross_walk, file.path(PATH, params$popsim_dir, 'data/geo_cross_walk.csv'))
fwrite(control_totals_bg, file.path(PATH, params$popsim_dir, 'data/control_totals_bg.csv'))
fwrite(control_totals_tract, file.path(PATH, params$popsim_dir, 'data/control_totals_tract.csv'))
fwrite(seed_pums_hh, file.path(PATH, params$popsim_dir, 'data/seed_households.csv'))
fwrite(seed_pums_per, file.path(PATH, params$popsim_dir, 'data/seed_persons.csv'))
fwrite(scaled_control_totals_meta, file.path(PATH, params$popsim_dir, 'data/scaled_control_totals_meta.csv'))






