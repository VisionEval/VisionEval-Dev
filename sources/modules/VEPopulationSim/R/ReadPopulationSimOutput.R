ReadPopulationSimOutputSpecifications <- list(
  Function="getPopulationSimOutputSpecs", # name of the function (no need to export) that returns the specification
  Specs=FALSE # Specs is only needed to support the Fields directive in Dynamic
             # In general, it will only need to be TRUE when the module is going to "Get" fields from
             # the Datastore. If this module is only doing "Set" specifications (plus, if you like
             # "Inp" specifications that load .csv files into the Datastore), then Specs here can be
             # left out, or explicity set to its default value of FALSE.
)

#Save the data specifications list
#---------------------------------

#' Specifications list for ReadPopulationSimOutput module
#'
#' A list containing specifications for the ReadPopulationSimOutput module.
#'
#' @format A list containing 5 components:
#' \describe{
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{NewSetTable}{new table to be created for datasets specified in the
#'  'Set' specifications}
#'  \item{Inp}{scenario input data to be loaded into the datastore for this
#'  module}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#' }
#' @source ReadPopulationSimOutput.R script.
"ReadPopulationSimOutputSpecifications"
visioneval::savePackageDataset(ReadPopulationSimOutputSpecifications, overwrite = TRUE)


# An environment constructed within the package that will hold the Dynamic message and configuration
# loaded during the specification creation. Shows how to save "session" details during a model run.
dynamic.env <- new.env()


create_specifications <- function(inp_dict_dt=NULL,
                                  set_dict_dt=NULL,
                                  ACSYear=2017,
                                  ModelYear=2010){
  
  # if(is.null(inp_dict_dt)) stop("Missing popsim data dictionary")
  if(is.null(set_dict_dt)) stop("Missing vesimhh data dictionary")
  
  # inp_dict_dt[,NAME:=paste0("\"", NAME,"\"")]
  # inp_dict_dt[,FILE:=paste0("\"", FILE,"\"")]
  # inp_dict_dt[,TABLE:=paste0("\"", TABLE,"\"")]
  # inp_dict_dt[,TYPE:=paste0("\"", TYPE,"\"")]
  # inp_dict_dt[,GROUP:=paste0("\"", GROUP,"\"")]
  # inp_dict_dt[,UNITS:=paste0("\"", UNITS,"\"")]
  # inp_dict_dt[,DESCRIPTION:=paste0("\"", DESCRIPTION,"\"")]
  # inp_dict_dt[ISELEMENTOF=="",ISELEMENTOF:='"""']
  
  
  # get_dict_dt <- copy(inp_dict_dt)
  # get_dict_dt[TYPE=="\"currency\"", UNITS:=paste0(strtrim(UNITS,nchar(UNITS)-1),".", ACSYear,"\"")]

  set_dict_dt[,NAME:=paste0("\"", NAME,"\"")]
  set_dict_dt[,TABLE:=paste0("\"", TABLE,"\"")]
  set_dict_dt[,TYPE:=paste0("\"", TYPE,"\"")]
  set_dict_dt[,GROUP:=paste0("\"", GROUP,"\"")]
  set_dict_dt[,UNITS:=paste0("\"", UNITS,"\"")]
  set_dict_dt[,DESCRIPTION:=paste0("\"", DESCRIPTION,"\"")]
  set_dict_dt[ISELEMENTOF=="",ISELEMENTOF:='"""']
  
  
  
  
  create_items <- function(arr_, add_tabs=0, inp_type="Inp"){
    INP_REQD_NAMES <- c("FILE", "DESCRIPTION", "UNLIKELY", "TOTAL")
    SET_REQD_NAME <- c("DESCRIPTION")
    if(inp_type == "Get"){
      arr_ <- arr_[setdiff(names(arr_), INP_REQD_NAMES)]
    } else if(inp_type == "Set"){
      arr_ <- arr_[setdiff(names(arr_), setdiff(INP_REQD_NAMES, SET_REQD_NAME))]
    }
    arr_[grepl("\"\"", arr_)] <- gsub("\"\"", "\"",arr_[grepl("\"\"", arr_)])
    arr_[grepl("= \"\"", arr_)] <- gsub("\"\"", "",arr_[grepl("= \"\"", arr_)])
    arr_[is.na(arr_)] <- '""'
    arr_names <- names(arr_)
    max_arr_index <- length(arr_names)
    out_ <- paste0(paste0(rep("\t", add_tabs), collapse = ""), "items(\n")
    for(index in seq_along(arr_names)){
      arr_name <- arr_names[index]
      out_ <- paste0(out_, paste0(rep("\t", add_tabs+2), collapse = ""), arr_name," = ", arr_[arr_name])
      if(index < max_arr_index){
        out_ <- paste0(out_, ",\n")
      } else {
        out_ <- paste0(out_, "\n)")
      }
    }
    out_
  }
  
  
  specification_text <- "
ReadPopulationSimOutputSpecifications <- list(
  #Level of geography module is applied at
  RunBy = \"Region\",
  #Specify new tables to be created by Inp if any
  NewInpTable = items(
    item(
      TABLE = \"Household\",
      GROUP = \"Global\"
    ),
    item(
      TABLE = \"Person\",
      GROUP = \"Global\"
    )
  ),
  #Specify new tables to be created by Set if any
  NewSetTable = items(
    item(
      TABLE = \"Household\",
      GROUP = \"Year\"
    ),
    item(
      TABLE = \"Person\",
      GROUP = \"Year\"
    )
  ),
  #Specify input data
  Get = items(
  item(
      NAME = \"Azone\",
      TABLE = \"Azone\",
      GROUP = \"Year\",
      TYPE = \"character\",
      UNITS = \"ID\",
      PROHIBIT = \"\",
      ISELEMENTOF = \"\"
    )
  ),
"
  
  # 
  specification_text <- paste0(specification_text,
                               # "Inp = items(\n\t",
                               # paste0(apply(inp_dict_dt,1,create_items), collapse = ",\n\t"),
                               # "\n),\n",
                               # "Get = items(\n\t",
                               # paste0(apply(get_dict_dt,1,create_items,inp_type="Get"), collapse = ",\n\t"),
                               # "\n),\n",
                               "Set = items(\n\t",
                               paste0(apply(set_dict_dt,1,create_items,inp_type="Set"), collapse = ",\n\t"),
                               "\n)\n)\n")
  eval(specification_text)
  
}



# Module Specification function, returning a list of "Get" and "Set" elements (and possibly "Inp") that will
# be supplied to, and retrieved from, this module. This function is called internally and not
# exported in the VESnapshot Namespace. The module function \code{Dynamic} is exported. The AllSpecs_ls is
# required as a parameter if "Specs" is true in the DynamicSpecifications above (and in any case where you
# expect to "Get" existing fields from the Datastore).
# Even though this function is exported from this example, it does not need to be exported in the general case.
#' Function to generate module specifications for Dynamic from visioneval.cnf
#' @param AllSpecs_ls a list of specifications for all known packages and modules defined up to this point
#'    in the model run. Furnished by the framework if "Specs" is true (see DynamicSpecifications above)
#' @param Cache a logical provided by the framework. FALSE when first building the specification; TRUE when
#'    the specification is accessed during a model run.
#' @return a "Get" specification if there is valid "Field:" block in the Dynamic configuration, otherwise
#'    just return an empty list.
#' @import data.table
#' @export
getPopulationSimOutputSpecs <- function(AllSpecs_ls=NA,Cache=FALSE) {
  # browser()
  # Used cached specification when calling from runModule
  if ( Cache && "Specs_ls" %in% names(dynamic.env) ) return( dynamic.env$Specs_ls )

  # General instructions for building a dynamic Specification function:
  
  # In general, a specification function will take no parameters unless Specs is TRUE in the module specifications
  # "list". If Specs IS TRUE, then AllSpecs_ls will be passed into the function so this module can see what other
  # modules have specified. It is good practice to default AllSpecs_ls when defining the specification function so
  # it can be called without AllSpecs_ls. If the function truly requires AllSpecs_ls (like this one), it needs to throw
  # an error if AllSpecs_ls is not available.
  # The Instance parameter can safely be ignored in most cases. It is there to support the Snapshot function
  #   (allowing multiple calls to Snapshot in a single model run, with possibly different fields being snapshotted
  #   each time. If you leave out "Specs" in the specification function description (see above in this file), you
  #   won't get AllSpecs_ls passed at all. Likewise, if there is no explicit "Instance" in the runModule call (see
  #   the VESnap sample model script) then Instance also won't be passed, so you could just define a function
  #   without parameters.
  # The Cache parameter is set by the framework: when the Specification is requested during model initialization
  #   Cache is FALSE and the dynamic.env will be rebuilt; when the Specification is requested again as runModule
  #   happens, Cache is TRUE. The specification function can ignore Cache (and just regenerate each time).

  # Look for the "Dynamic" specification
  config <- visioneval::getRunParameter("Dynamic") # looking in the RunParam_ls for the current model stage
  # dynamicParam_ls <- if ( ! is.list(config) ) {
    # Could add any other directories you like
    DynamicDir <- visioneval::getRunParameter("DynamicDir")
    ModelDir   <- visioneval::getRunParameter("ModelDir")
    ParamPath  <- visioneval::getRunParameter("ParamPath") # already expanded from ParamDir to absolute path
    InputPath  <- visioneval::getRunParameter("InputPath") # already expanded to all the places to look for inputs
    configDir  <- findFileOnPath( DynamicDir, c(ModelDir,ParamPath,InputPath) )
    # if ( !is.na(configDir) ) {
    dynamicParam_ls <- readConfigurationFile(ParamDir=configDir) # look for visioneval.cnf or equivalent
    config <- getRunParameter("Dynamic",Param_ls=dynamicParam_ls)
    paste("Loaded:",configDir)
    # } else {
    #   paste("Could not open Dynamic configuration file in",configDir)
    # }
  # } else {
    # if ( "Message" %in% names(config) ) config$Message else "No message supplied"
  # }

  # If still no configuration specified, do a default configuration
  # if ( ! is.list(config) ) {
  #   Message = c("Unconfigured Dynamic module",Message)
  #   dynamic.env$Message <- Message
  #   return( list() ) # No specifications for this module; let framework inject RunBy="Region"
  # }

  # Process configuration
    InpSpecPath <- findFileOnPath(config$PopSimDictionary, 
                                  file.path(InputPath, DynamicDir))
    InpSpec_dt <- fread(InpSpecPath)
    SetSpecPath <- findFileOnPath(config$VESimHouseholdDictionary, 
                                  file.path(InputPath, DynamicDir))
    SetSpec_dt <- fread(SetSpecPath)
    SetSpec_dt <- rbindlist(list(InpSpec_dt, SetSpec_dt),
                            use.names=TRUE,
                            fill=FALSE)
    SetSpec_dt[TYPE=="currency", UNITS:=paste0(UNITS,".",config$ACSYear)]
    
    # Check if the necessary fields are in the configuration file
    requiredSynFields_ <- c("NP", "NW", "HHINCADJ", "AGEP", "WORKER")
    expectedHhCols <- config$PopSimFiles$households$columns
    expectedPerCols <- config$PopSimFiles$persons$columns
    newHhColNames <- setdiff(expectedHhCols, requiredSynFields_)
    newPerColNames <- setdiff(expectedPerCols, requiredSynFields_)
    missingHhNames <- setdiff(newHhColNames, SetSpec_dt[TABLE=="Household", NAME])
    missingPerNames <- setdiff(newPerColNames, SetSpec_dt[TABLE=="Person", NAME])
    Message <- c()
    if(length(missingHhNames) > 0){
      for(col_name in missingHhNames){
        Message <- c(paste("Household field", col_name, "not found in the data dictionary"),
                     Message)
      }
    }
    if(length(missingPerNames) > 0){
      for(col_name in missingPerNames){
        Message <- c(paste("Person field", col_name, "not found in the data dictionary"),
                     Message)
      }
    }
    
    dynamic.env$Message <- Message
    dynamic.env$SetSpec_dt <- SetSpec_dt
    
    
    # Get model base year
    ModelBaseYear <- visioneval::getRunParameter("BaseYear")
    Specs_ls <- create_specifications(InpSpec_dt, SetSpec_dt)
    Specs_ls <- eval(parse(text = Specs_ls))
  

  dynamic.env$Specs_ls <- Specs_ls
  dynamic.env$dynamicParam_ls <- dynamicParam_ls

  return( Specs_ls )
}

#Main module function that reads PopulationSim output
#------------------------------------------------------
#' Main module function to reads PopulationSim output
#'
#' \code{ReadPopulationSimOutput} reads and stores the synthetic households and
#' persons produced by running PopulationSim in the VisionEval framework.
#'
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#' @return A list containing the components specified in the Set
#' specifications for the module along with:
#' LENGTH: A named integer vector having a single named element, "Household",
#' which identifies the length (number of rows) of the Household table to be
#' created in the datastore.
#' SIZE: A named integer vector having two elements. The first element, "Azone",
#' identifies the size of the longest Azone name. The second element, "HhId",
#' identifies the size of the longest HhId.
#' @import visioneval data.table
#' @name ReadPopulationSimOutput
#' @export
ReadPopulationSimOutput <- function(L){
  # browser()

  logLevel <- if ( "LogLevel" %in% names(dynamic.env) ) dynamic.env$LogLevel else "warn"
  Message <- if ( "Message" %in% names(dynamic.env) ) dynamic.env$Message else c()
  
  # Get the dynamic parameter list
  dynamicParam_ls <- mget("dynamicParam_ls", envir=dynamic.env, ifnotfound=NA)[[1]]
  
  if(is.na(dynamicParam_ls)) stop("Dynamic parameter is not a directory")
  config <- getRunParameter("Dynamic",Param_ls=dynamicParam_ls)
  
  # Check if PopSimOutputDir is a full path
  if(!dir.exists(config$PopSimOutputDir[[L$G$Year]])){
    InputPath  <- visioneval::getRunParameter("InputPath")
    DynamicDir  <- visioneval::getRunParameter("DynamicDir")
    config$PopSimOutputDir[[L$G$Year]] <- findFileOnPath(config$PopSimOutputDir[[L$G$Year]], file.path(InputPath, DynamicDir))
  }
  
  synHh_dt <- fread(file.path(config$PopSimOutputDir[[L$G$Year]],
                              config$PopSimFiles[["households"]][["filename"]]),
                 na.strings = "b")
  synPer_dt <- fread(file.path(config$PopSimOutputDir[[L$G$Year]],
                               config$PopSimFiles[["persons"]][["filename"]]),
                 na.strings = "b")
  
  setnames(synHh_dt, config[["BzoneField"]], "Bzone", skip_absent=TRUE)
  setnames(synPer_dt, config[["BzoneField"]], "Bzone", skip_absent=TRUE)
  
  # Required fields
  requiredFields_ <- c("NP", "NW", "HHINCADJ", "AGEP", "WORKER")
  for(col_name in requiredFields_){
    if(!(col_name %in% names(synHh_dt) | col_name %in% names(synPer_dt))){
      Message <- c(paste("Required field", col_name, "not found in the synthetic output"),
                   Message)
    }
  }
  
  # Verify if all the columns specified in the dynamic settings are in the
  # synthetic output files
  expectedHhCols <- config$PopSimFiles$households$columns
  remHhColNames <- setdiff(expectedHhCols, colnames(synHh_dt))
  expectedPerCols <- config$PopSimFiles$persons$columns
  remPerColNames <- setdiff(expectedPerCols, colnames(synPer_dt))
  
  if(length(remHhColNames) > 0){
    for(hhColName in remHhColNames){
      Message <- c(paste("Field", 
                         hhColName, 
                         "not found in the synthetic household output"),
                   Message)
    }
  }
  if(length(remPerColNames) > 0){
    for(perColName in remPerColNames){
      Message <- c(paste("Field", 
                         perColName, 
                         "not found in the synthetic persons output"),
                   Message)
    }
  }
  
  visioneval::writeLog(paste("ReadPopulationSimOutput: ",
                             c(Message)),Level=logLevel)
  
  #fix seed as synthesis involves sampling
  set.seed(L$G$Seed)
  #Define dimension name vectors
  Az <- as.vector(L$Year$Azone$Azone)
  Ag_ <- c("Age0to14", "Age15to19", "Age20to29", "Age30to54", "Age55to64", "Age65Plus")
  Ages_ <- c(-0.1, 15, 20, 30, 55, 65, Inf)
  
  # Create Ouptut list
  Out_ls <- initDataList()
  # 
  # synHh_dt <- as.data.table(L$Global$Household)
  # synPer_dt <- as.data.table(L$Global$Person)
  veGeo_dt <- as.data.table(L$G$Geo_df)
  
  hh_dt <- data.table(
    household_id = synHh_dt[, household_id],
    HhSize = synHh_dt[, NP],
    Workers = synHh_dt[,NW],
    Bzone = synHh_dt[, Bzone],
    Azone = veGeo_dt[,Azone][match(synHh_dt[,Bzone], veGeo_dt$Bzone)],
    Marea = veGeo_dt[,Marea][match(synHh_dt[,Bzone], veGeo_dt$Bzone)],
    Income = pmax(synHh_dt[,HHINCADJ],1E-4)
  )
  
  hh_dt[, HhId:=paste0(Azone, "-", household_id)]
  
  per_dt <- data.table(
    PerId = synPer_dt[,paste0(household_id, "-", per_num)],
    household_id = synPer_dt[, household_id],
    Age = synPer_dt[, AGEP],
    # Race = synPer_dt[, RAC1P],
    # Income = synPer_dt[, PINCADJ],
    Worker = synPer_dt[, WORKER],
    Bzone = synPer_dt[, Bzone],
    Azone = veGeo_dt[,Azone][match(synPer_dt[,Bzone], veGeo_dt[,Bzone])],
    Marea = veGeo_dt[,Marea][match(synPer_dt[,Bzone], veGeo_dt[,Bzone])]
  )
  
  per_dt[, HhId:=paste0(Azone, "-", household_id)]
  per_dt[, PerId:=paste0(Azone, "-", PerId)]
  
  # Find Age Group
  per_dt[,AgeGrp:=cut(Age, Ages_, labels=Ag_, include.lowest=FALSE)]
  
  age_dt <- dcast.data.table(per_dt, HhId~AgeGrp,fun.aggregate = length)
  hh_dt <- age_dt[hh_dt,on=.(HhId)]
  
  # Household Type
  hhtype_dt <- age_dt[,.(HhId, HhType=apply(.SD,1,paste0,collapse="-")),
                      .SDcols=!"HhId"]
  hh_dt <- hhtype_dt[hh_dt,on=.(HhId)]
  
  # Find Worker in age group
  wrk_dt <- dcast.data.table(per_dt, HhId~AgeGrp, value.var = "Worker",
                             fun.aggregate = sum)
  setnames(wrk_dt, gsub("Age", "Wkr", names(wrk_dt)))
  wrk_dt[,Wkr0to14:=NULL]
  hh_dt <- wrk_dt[hh_dt,on=.(HhId)]
  
  # Append additional columns to household and person data
  newHhColNames <- setdiff(expectedHhCols, requiredFields_)
  newPerColNames <- setdiff(expectedPerCols, requiredFields_)
  
  # Check if they exist in set specifications
  SetSpec_dt <- copy(dynamic.env$SetSpec_dt)
  SetSpec_dt[,NAME:=gsub("\"","",NAME)]
  newHhColNames <- intersect(newHhColNames, SetSpec_dt[grepl("Household", TABLE), NAME])
  newPerColNames <- intersect(newPerColNames, SetSpec_dt[grepl("Person", TABLE), NAME])
  
  if(length(newHhColNames) > 0){
    hh_dt <- cbind(hh_dt, synHh_dt[,.SD,.SDcols=newHhColNames])
  }
  if(length(newPerColNames) > 0){
    per_dt <- cbind(per_dt, synPer_dt[,.SD,.SDcols=newPerColNames])
  }
  
  # Azone summaries
  azone_dt <- hh_dt[,.(
    NumHh=.N,
    NumGq=0,
    NumWkr=sum(Workers)
  ),keyby=.(Azone)]
  
  # Create output list
  # Azone list
  Out_ls$Year$Azone <- list(
    NumHh = azone_dt[.(Az), NumHh],
    NumGq = azone_dt[.(Az), NumGq],
    NumWkr = azone_dt[.(Az), NumWkr]
  )
  # Household list
  Out_ls$Year$Household <- as.list(hh_dt)
  
  # Person list
  per_dt[,AgeGrp:=NULL]
  Out_ls$Year$Person <- as.list(per_dt)
  
  #Calculate LENGTH attribute for Household table
  attributes(Out_ls$Year$Household)$LENGTH <-
    length(Out_ls$Year$Household$HhId)
  #Calculate SIZE attributes for 'Household$Azone' and 'Household$HhId'
  attributes(Out_ls$Year$Household$Azone)$SIZE <-
    max(nchar(Out_ls$Year$Household$Azone))
  attributes(Out_ls$Year$Household$Bzone)$SIZE <-
    max(nchar(Out_ls$Year$Household$Bzone))
  attributes(Out_ls$Year$Household$Marea)$SIZE <-
    max(nchar(Out_ls$Year$Household$Marea))
  attributes(Out_ls$Year$Household$HhId)$SIZE <-
    max(nchar(Out_ls$Year$Household$HhId))
  attributes(Out_ls$Year$Household$HhType)$SIZE <-
    max(nchar(Out_ls$Year$Household$HhType))
  
  #Calculate LENGTH attribute for Person table
  attributes(Out_ls$Year$Person)$LENGTH <-
    length(Out_ls$Year$Person$PerId)
  #Calculate SIZE attributes for 'Person$Azone' and 'Person$HhId'
  attributes(Out_ls$Year$Person$Azone)$SIZE <-
    max(nchar(Out_ls$Year$Person$Azone))
  attributes(Out_ls$Year$Person$Bzone)$SIZE <-
    max(nchar(Out_ls$Year$Person$Bzone))
  attributes(Out_ls$Year$Person$Marea)$SIZE <-
    max(nchar(Out_ls$Year$Person$Marea))
  attributes(Out_ls$Year$Person$HhId)$SIZE <-
    max(nchar(Out_ls$Year$Person$HhId))
  attributes(Out_ls$Year$Person$PerId)$SIZE <-
    max(nchar(Out_ls$Year$Person$PerId))
  #Return the list
  Out_ls
}
