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
#</doc>

#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================

#This module has no parameters. See the SnapshotSpecifications for instructions on how to
#configure it.

#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

# Snapshot builds its specifications dynamically by locating fields in the Datastore that
# the model developer identifies in their visioneval.cnf and returning renamed copies of
# whatever is in those fields at runtime.

SnapshotSpecifications <- list(
  Function="getSnapshotFields",
  Specs=TRUE # Specs is only needed if the Function wants to see AllSpecs_ls
             # Snapshot does (since we are copying a spec from another module)
             # Other modules usually won't, and their Get or Set or Inp will be generated internally)
)

# Module Specification function, returning a list of "Get" and "Set" elements (and possibly "Inp") that will
# be supplied to, and retrieved from, this module.
#' Function to generate module specifications from visioneval.cnf
#' @param AllSpecs_ls a list of specifications for all known packages and modules in the model run
#' @return a list of specifications (Inp, Get and/or Set) descripbing fields to inject into the Datastore
getSnapshotFields <- function(AllSpecs_ls=NA) {
  # In general, a specification function will take no parameters unless Specs is TRUE in the module specifications
  # "list". If Specs IS TRUE, then AllSpecs_ls will be passed into the function so this module can see what other
  # modules have specified. It is good practice to default AllSpecs_ls when defining the specification function so
  # it can be called without AllSpecs_ls. If the function truly requires AllSpecs_ls (like this one), it needs to throw
  # an error if AllSpecs_ls is not available.
  # Note that we can look back up the AllSpecs_ls list for earlier instances of Snapshot and just work through the
  # tags in order
  return( list() )
}

#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================
# This module takes a specified list of Datastore elements (defined in visioneval.cnf) and makes copies of them under
# new names in the Datastore. See the VESnap sample model from the VEModel package for examples and documentation of how
# to configure the fields.

#Main Module function that copies datastore fields to new fields with a different name
#' Main Module function that copies datastore fields to new fields with a different name
#' \code{Snapshot} takes a snapshot of Datastore fields. Use it as runModuleInstruction.
#' See the VESnap sample model in VEModel for detailed instructions on setup and use.
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#'
#' Using LoopIndex and Instance in the runModule instruction (they are optional and may be left out) will append those to
#' the output field names so multiple snapshots of the same value can be taken at different points in the model script.
#' They also identify the particular instance of Shapshot so different fields can be snapshotted at different points in
#' the script. Each instance of Snapshot can be identifed by Instance in visioneval.cnf, and the fields to
#' snapshot will be selected using identifiers the Loop/Instance block. See the VESnap sample model for more information.
#'
#' @param L A list following the getSpecification structure
#' @param LoopIndex A numeric value to use in distinguishing Snapshot output field names within a model run script loop
#' @param Instance A string value that identifies this instance of Snapshot in visioneval.cnf. Different Snapshot instances
#' @return a list of data elements to be added to the Datastore (copies of the L parameter input
Snapshot <- function( L, LoopIndex=0, Instance="" ) {
  # L will contain the field(s) to snapshot
  # getSnapshotFields()
  NULL
}

#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("Snapshot")
