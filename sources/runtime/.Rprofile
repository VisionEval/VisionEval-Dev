# Run VisionEval

# Set VE_HOME in .Renviron to the directory containing the VisionEval installation.
# Can be either enduser (from installer) or developer (from Github)

local( {
  this.R <- paste(R.version[c("major","minor")],collapse=".")

  VE.home <- Sys.getenv("VE_HOME",unset=getwd()) # Where to look for runnable VisionEval
  VE.developer <- file.exists(dev.dir<-file.path(VE.home,"build/VisionEval-dev.R"))
  if ( ! VE.developer && ! file.exists(file.path(VE.home,"VisionEval.R")) ) {
    stop("Cannot locate VisionEval startup file in ",VE.home)
  }

  start.from <- setwd(VE.home) # get ready to run the startup file
  if ( VE.developer ) {
    VE.build.dir <- Sys.getenv("VE_BUILD",VE.home)
    cat("Build directory:",VE.build.dir,"\n")
    dev.lib <- file.path(VE.build.dir,"dev/lib",this.R)
    cat("Dev lib:",dev.lib,"\n")
    loaded <- FALSE
    if ( dir.exists(dev.lib) ) {
      .libPaths(dev.lib)
      VE.branch <- Sys.getenv("VE_BRANCH",NA)
      if ( is.na(VE.branch) ) {
        VE.branch <- if ( git2r::in_repository(VE.home) ) {
          localbr <- git2r::branches(VE.home,flags="local")
          hd <- which(sapply(localbr,FUN=git2r::is_head,simplify=TRUE))
          localbr[[hd]]$name
        } else "visioneval"
      }
      VE.lib.dir <- file.path(VE.build.dir,"built",VE.branch,this.R)
      if ( ! dir.exists(VE.lib.dir) ) { # VE.home is repository but VE.branch is not built
        # try with default "visioneval" branch ( from stock ve.build() )
        VE.lib.dir <- file.path(VE.build.dir,"built","visioneval",this.R)
      }
      ve.lib  <- file.path(VE.lib.dir,"ve-lib")
      cat("VE lib:",ve.lib,"\n")
      if ( dir.exists(ve.lib) ) {
        .libPaths(c(ve.lib,.libPaths()))
        source("build/VisionEval-dev.R")  # Will return to VE_RUNTIME set above
        loaded <- TRUE
      }
    }      
    if ( ! loaded ) {
      message("Seeking built VisionEval in ",VE.build.dir)
      message("However, VisionEval from ",VE.home," is not available.")
      message("Please run ve.build()")
      setwd(VE.home)
    } else {
      ve.runtime <- Sys.getenv("VE_RUNTIME",unset=start.from) # can also set VE_RUNTIME in .Renviron
      ve.run(ve.runtime)  # Ready to run development version
    }
  } else {
    # VisionEval will run in VE_RUNTIME - generally leaving the default is preferred
    ve.runtime <- Sys.getenv("VE_RUNTIME",unset=start.from) # can also set VE_RUNTIME in .Renviron
    Sys.setenv(VE_RUNTIME=ve.runtime) # propagate into standard startup
    source("VisionEval.R") # Run end-user version
  }
  invisible(NULL)
})

