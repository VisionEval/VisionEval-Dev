require(VEModel)

# Analyzing multiple scenarios is usually easier to perform if you run queries - extract is designed
# to do just one scenario at a time, so you'll have to loop manually (or in your own script) over
# all the scenarios (queries do that automatically). Plus, extracting a large model's results will
# generate hundreds of megabytes of output data (perhaps even gigabytes...). A query lets you zero
# in on results you want to see, without having to sift through large amounts of data.

mod.scenarios <- openModel("VERSPM-scenarios")

message("Show query directory (has Full-Query.VEqry)...")
print(mod.scenarios$query())

# Show the "Reportable" stages (the ones that will be queried)
print(mod.scenarios)

#######################
# BASIC QUERY OPERATION
#######################

qry <- mod.scenarios$query("Full-Query") # open the query

qry$run() # do the query on mod.scenarios model
mod.scenarios$dir(output=TRUE) # No "outputs" yet (just "results")

# Extracting query outputs
q.results <- qry$extract()

#############
# RUN QUERIES
#############

# Check the following still works...

message("Run the query on the model...")
qry$run(mod.scenarios) # in case you want to use a query with another model

message("Run the full query on the model...")
qry <- mod.scenarios$query("Full-Query")
# Automatically attaches model to query

# Run
qry$run()     # uses attached model - will give error if no model attached

# Query results are added to each stage results
print(mod.scenarios$dir(results=TRUE,all.files=TRUE))

# Running again does as little work as possible
qry$run(mod.scenarios)  # re-attach the model; does nothing if query is up to date
  # Will re-run for if model stages are present, or if the stage
  # results had been re-generated

# Can always force a complete re-do if you change the query
qry$run(Force=TRUE) # Ignore existing query results and run again

# If you forget what model is attached to the query:
print(qry$Model) # Shows mod.scenarios...

# Explicitly set the query model (without running)
qry$model(mod.scenarios)

##########################
# EXTRACTING QUERY RESULTS
##########################

# Extract results into data.frames
df <- qry$extract()
print(df) # rows are meaasures; columns are model stages/scenarios

# Export query results to a CSV file (other formats will eventually be supported)
qry$export(format="csv") # Default CSV file name in output directory
mod.scenarios$dir(outputs=TRUE)

qry$export() # Does the same thing again, possibly overwriting (file is timestamped)
mod.scenarios$dir(outputs=TRUE)

qry$export(format="csv",SaveTo=paste0("TestQuery_%timestamp%",qry$Name)) # use our own file name template
mod.scenarios$dir(outputs=TRUE)
