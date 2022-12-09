#' @include parameters.R
#==================
#Snapshot.R
#==================
#
#<doc>
#
## Snapshot Module
#### December 7, 2022
#
#This module illustrates the basic structure of a VE module and implements a useful test facility that can copy an
#arbitrary field (or more than one) present in the Datastore into a new field. Useful for grabbing a picture of a field
#that is revised at different points in the model stream. Run 'installModel("VESnap")' to install a test module that
#illustrates the application of the Snapshot module, including some spiffy features that allow you to take multiple
#snapshots of the same field and keep them separate in the Datastore.
#
### Model Parameter Estimation
#
#This module has no parameters and nothing is estimated.
#
### How the Module Works
#
#The user specifies fields to copy in their visioneval.cnf script in the Snapshot: block. See the VESnap test model
#that can be installed from this package. When the model runs and the runModule("Snapshot",...) instruction is
#encountered, the specified fields are copied into new fields in the Datastore where they can later be extraced,
#queried or otherwise used.
#
### Configuring Snapshot
#
# The snapshot configuration is placed in visioneval.cnf, where it
# will look like this in its fully developed form:
#
# '''
# Snapshot:
#   - Instance: "First"
#     Group:
#     Table:
#     Name:
#     SnapshotName:
#   - Instance: "Second"
#     Group:
#     Table:
#     Name:
#     SnapshotName:
#     LoopIndex: 1
#       #If LoopIndex is missing, snapshot each time through the loop to the same place. Otherwise
#       #only snapshoot on this loop index.
# '''
#
# A minimal Snapshot will look like the following (Instance is implicitly
# `""`). Note the dash ahead of Group - Snapshot must define a list
# of objects, even if there is only one.
#
# '''
# Snapshot:
#   - Group:
#     Table:
#     Name:
#     SnapshotName:
# '''
#
# Any Group/Table/Name object must already have been specified in an earlier module call in the
# ModelScript (i.e. before the `runModule("Snapshot",...)` step).
#
# See the VESnap test model for a working example.
#
#</doc>

#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================

#This module has no parameters to estimate.

#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

# Snapshot builds its specifications dynamically by locating fields in the Datastore that
# the model developer identifies in their visioneval.cnf and returning renamed copies of
# whatever is in those fields at runtime.
SnapshotSpecifications <- list(
  Function="getSnapshotFields",
  Specs=TRUE # Specs is only needed if the specification Function wants to see AllSpecs_ls
             # Snapshot doe need it (since we are copying a spec from another module)
             # Other modules usually won't, and their Get or Set or Inp will be generated
             # internally); if it's not needed, you can leave it out entirely (default is FALSE)
)

#Save the data specifications list
#---------------------------------
# "SnapshotSpecifications"
#' Specifications list for the Snapshot module
#'
#' Snapshot illustrates dynamic model specification (through a function). See the Snapshot entry in
#' VESnapshot/model_docs, or R help for \code{VESnapshot::Snapshot}
#' @format a list with one or two elements (Function and Specs)
#' @source Snapshot.R script
#' @name SnapshotSpecifications
visioneval::savePackageDataset(SnapshotSpecifications, overwrite = TRUE)


# Module Specification function, returning a list of "Get" and "Set" elements (and possibly "Inp") that will
# be supplied to, and retrieved from, this module. This function is called internally and not
# exported in the VESnapshot Namespace. The module function \code{Snapshot} is exported.
#' Function to generate module specifications for Snapshot from visioneval.cnf
#' @param AllSpecs_ls a list of specifications for all known packages and modules in the model run
#' @param Instance is the name (possibly an empty character vector if there is just one Instance) of
#'   the Snapshot instance, defined via Instance="SnapshotInstance" in the runModule("Snapshot",...)
#'   instruction in the model script.
#' @param Cache if TRUE, use the locally cached parameters rather than regenerating
#' @return a list of specifications (Inp, Get and/or Set) descripbing fields to inject into the Datastore
#' @export
getSnapshotFields <- function(AllSpecs_ls=NA,Instance=character(0), Cache=FALSE) {
  Specs_ls <- list( RunBy = "Region" ) # Alternative is a geography like Azone or Bzone or Marea
  # If you don't explicitly set "RunBy" the framework will inject "Region", so this just reiterate the default

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
  
  # Specific Snapshot implementation. Notice how it handles the directory search for an
  #   independently defined Snapshot configuration.
  snapConfig <- visioneval::getRunParameter("Snapshot") # Will search modelEnvironment()$RunParam_ls
  if ( !is.list(snapConfig) ) {
    # Conduct directory search
    snapDir <- visioneval::getRunParameter("SnapshotDir")
    # See if directory exists and contains a visioneval.cnf or equivalent
    #   ModelDir/SnapshotDir/visioneval.cnf (Snapshot element only will be added to RunParam_ls in model Environment)
    #   ModelDir/ParamDir/SnapshotDir/visioneval.cnf (Snapshot element only will be added to RunParam_ls)
  }
  # If Snapshot is not found, write a warning to the Log and return an empty list
  # Cache the Snapshot configuration within this package's environment so we won't call this function again
  # Look up by Instance in the cache when the main module function is called.

  # TODO: Parse the Snapshot element and look up the GTN in AllSpecs_ls
  # Identify the Instance, check the Group/Table/Name can be found in some "Set" spec in AllSpecs_ls
  # Check that Output name is not already found in some other "Set" specification (Snapshot can't overwrite
  #   an existing Datastore field).
  # Stop on error if GTN not found anywhere in AllSpecs_ls

  # TODO: create a visioneval function to efficiently search AllSpecs_ls and return a list of all matching GTN in order
  #   they were defined (possibly filtering first for module calls prior to encountering this Snahpshot Instance). So
  #   we could do a linear search-and-extract placing a limit on searching only up until we encounter this Module/Instance

  # TODO: Build the Specification and return it.
  # Use the source GTN we just found in the last step, and copy the "Get" spec to a "Set" spec with the new SnapshotName
  # Load the constructed specification into the Snapshot environment under the Instance name, so we won't parse
  #   again during the module Run - we'll use what was built here during model initialization
  # Return the list of Get and Set for this instance.
  # Error if we visit this function again (second Snapshot Instance) in the case that an earlier
  #   Instance did not have an explicit name
  return( Specs_ls )
}

#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================
# This module takes a specified list of Datastore elements (defined in visioneval.cnf) and makes copies of them under
# new names in the Datastore. See the VESnap sample model from the VEModel package for examples and documentation of how
# to configure the fields.

#' Main Module function that copies datastore fields to new fields with a different name
#' \code{Snapshot} takes a snapshot of Datastore fields. Use it as runModuleInstruction. See the
#' VESnap sample model in VEModel for detailed instructions on setup and use. @param L A list
#' containing the components listed in the Get specifications for the module.
#'
#' Using LoopIndex and Instance in the runModule instruction (they are optional and may be left
#' out) will append those to the output field names so multiple snapshots of the same value can be
#' taken at different points in the model script. They also identify the particular instance of
#' Shapshot so different fields can be snapshotted at different points in the script. Each instance
#' of Snapshot can be identifed by Instance in visioneval.cnf, and the fields to snapshot will be
#' selected using identifiers the Loop/Instance block. See the VESnap sample model for more
#' information.
#'
#' To configure a Snapshot, you need to add a "Snapshot" element to visioneval.cnf (somewhere in
#' what is being built for the running model stage). Alternatively, you can put a visioneval.cnf
#' with a "Snapshot" element in SnapshotDir (default is "snapshot", located either in the model's
#' root directory, or in the model's ParamDir (which defaults to "defs" - so "defs/snapshot").
#'
#' The snapshot configuration is placed in visioneval.cnf, where it
#' will look like this in its fully developed form:
#' 
#' \code{
#' Snapshot:
#'   - Instance: "First"
#'     Group:
#'     Table:
#'     Name:
#'     SnapshotName:
#'   - Instance: "Second"
#'     Group:
#'     Table:
#'     Name:
#'     LoopIndex: 1
#'       #If LoopIndex is missing, snapshot each time through the loop to the same place. Otherwise
#'       #only during this loop index.
#'     SnapshotName:
#' }
#' 
#' A minimal Snapshot will look like the following (Instance is implicitly
#' `""`). Note the dash ahead of Group - Snapshot must define a list
#' of objects, even if there is only one.
#' 
#' \code{
#' Snapshot:
#'   - Group:
#'     Table:
#'     Name:
#'     SnapshotName:
#' }
#'
#' Any Group/Table/Name object must already have been specified in an earlier module call in the
#' ModelScript (i.e. before the `runModule("Snapshot",...)` step).
#'
#' @param L A list following the getSpecification structure
#' @param LoopIndex A numeric value to use in distinguishing Snapshot output field names within a model run script loop
#' @param Instance A string value that identifies this instance of Snapshot in visioneval.cnf. Different Snapshot instances
#' @return a list of data elements to be added to the Datastore (copies of the L parameter inputs)
#' @export
Snapshot <- function( L, LoopIndex=0, Instance=character(0) ) {
  # L will contain the data to snapshot
  # LoopIndex can be non-zero if specified in the runModule call, and will be compared to LoopIndex in the
  #  the Snapshot configuration (if present). If LoopIndex here matches the one in the configuration, or if no
  #  LoopIndex is configured for the Instance, the Snapshot will be performed. If loopIndex does not match,
  #  the Snapshot will be skipped.
  # Instance will default in runModule to character(0), so only the first defined Snapshot will be used.
  # Otherwise Instance is a character string that will match the "Instance" element value in the Snapshot configuration
  # At runtime, the Snapshot configuration for the Instance will be loaded, and LoopIndex, if
  # non-zero, will be compared to the configuration and used to determine if an output field will
  # be generated. The default with LoopIndex==0 will be to overwrite the output field each time
  # through the loop.
  writeLog(paste("Snapshot Instance",Instance,"currently does literally nothing"),Level="warn")
  list()
}

#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
#' @importFrom visioneval documentModule
visioneval::documentModule("Snapshot")
