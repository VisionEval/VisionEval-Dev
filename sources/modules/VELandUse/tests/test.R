.testStep <- function (msg) cat("\n",msg,"...\n")

compare_ipf <- function(unfixed,fixed) {
  # broken and fixed are lists of a VEModel and a stage name
  # results will be retrieved and compared
  .testStep("Model index for relevant modules")
  mod <- broken$Model
  modIndex <- mod$list(stage=broken$Stage,inputs=TRUE,outputs=TRUE,details=TRUE)
  specs <- with(modIndex,
    which(PACKAGE=="VELandUse" & MODULE %in% c("PredictHousing", "AssignParkingRestrictions", "LocateEmployment"))
  )
  cat("Would compare broken and fixed results\n")
  return(modIndex)
}

test_model <- function(model="VERSPM",variant="test-ipf",log="warn",reset=FALSE) {
  # load and run a test model from this package
  .testStep(paste("Install model",model,"variant",variant))
  cat(modelPath <- "VERSPM-test-VELandUse","\n")
  mod <- if ( ! dir.exists(file.path("models",modelPath)) ) {
    installModel(model,variant=variant,modelPath=modelPath,log=log)
  } else {
    openModel(modelPath,log=log)
  }

  .testStep("Run the model")
  mod$run(if(reset)"reset"else"continue")

  .testStep("Compare the results")
  modIndex <- compare_ipf(unfixed=list(Model=mod,Stage="ipf-broken"),fixed=list(Model=mod,Stage="ipf-fixed"))
  return( invisible(list(index=modIndex,model=mod)) )
}
