requireNamespace("dplyr")
requireNamespace("tidyr")
requireNamespace("readr")
requireNamespace("jsonlite")

library("dplyr")
library("tidyr")
library("readr")
library("jsonlite")

tool.contents <- c(
  "ve.scenario_management.make_form_csv_from_json",
  "ve.scenario_management.make_json_from_form_csv",
  "ve.scenario_management.make_directory_structure"
)
  

# To use this in a visioneval runtime, just do this:
#   source("tools/scenario_management.R")

# private methods --------------------------------------------------------------
read_scenario_form_from_csv <- function(input_file_name) {
  
  return_df <- read_csv(input_file_name, 
                        col_types = cols(.default = col_character(), execute = col_logical()))
  
  return(return_df)
  
}

make_scenario_json_from_form <- function(input_form_df, input_json_file_name) {
  
  output_df <- input_form_df %>%
    select(-execute) %>%
    rename(NAME = level_name, 
           LABEL = level_label, 
           DESCRIPTION = level_description) %>%
    group_by(category_name, category_label, category_description, category_instructions) %>%
    nest(.key = "LEVELS") %>%
    ungroup() %>%
    rename(NAME = category_name, 
           LABEL = category_label, 
           DESCRIPTION = category_description,
           INSTRUCTIONS = category_instructions)
  
  write_json(output_df, path = input_json_file_name, force = T)
  
}

make_category_json_from_form <- function(input_form_df, input_json_file_name) {
  
  output_df <- input_form_df %>%
    filter(execute) %>%
    select(top_NAME = category_label, 
           DESCRIPTION = category_description,
           middle_NAME = level_name,
           NAME = category_name) %>%
    mutate(LEVEL = middle_NAME) %>%
    group_by(top_NAME, DESCRIPTION, middle_NAME) %>%
    nest(NAME, LEVEL, .key = "INPUTS", -top_NAME, -DESCRIPTION) %>%
    rename(NAME = middle_NAME) %>%
    nest(NAME, INPUTS, .key = "LEVELS", -top_NAME, -DESCRIPTION) %>%
    ungroup() %>%
    rename(NAME = top_NAME)
  
  write_json(output_df, path = input_json_file_name, force = T)
  
}

# end: private methods ---------------------------------------------------------

# public methods ---------------------------------------------------------------

# ve.scenario_management.make_form_csv_from_json
# Create a CSV file from the JSON files used to manage VisionEval Scenarios
#
# Parameters:
#   input_dir:
#     File directory of the Standard VisionEval scenario configuration files, 
#     named `scenario_config.json` and `category_config.json`.
#   output_file_name:
#     Standard VisionEval scenario configuration CSV file, which can have any name and
#     file location that you wish. 
ve.scenario_management.make_form_csv_from_json <- function(input_dir,
                                                           output_file_name) {
  
  input_scenario_json <- file.path(input_dir, "scenario_config.json")
  input_category_json <- file.path(input_dir, "category_config.json")
  
  input_scenario_df <- read_json(input_scenario_json, simplifyVector = TRUE)
  input_category_df <- read_json(input_category_json, simplifyVector = TRUE)
  
  working_df <- input_scenario_df %>%
    rename(category_name = NAME, 
           category_label = LABEL, 
           category_description = DESCRIPTION,
           category_instructions = INSTRUCTIONS) %>%
    unnest(.) %>%
    rename(level_name = NAME,
           level_label = LABEL, 
           level_description = DESCRIPTION)
  
  execute_df <- input_category_df %>%
    rename(category_label = NAME,
           category_description = DESCRIPTION) %>%
    unnest(.) %>%
    rename(level_name = NAME) %>%
    unnest(.) %>%
    rename(category_name = NAME) %>%
    select(-LEVEL) %>%
    mutate(execute = TRUE)
  
  write_df <- left_join(working_df, execute_df, by = c("category_name",
                                                       "category_label",
                                                       "category_description",
                                                       "level_name")) %>%
    mutate(execute = replace_na(execute, FALSE))
  
  write_csv(write_df, path = output_file_name)
  
}

# ve.scenario_management.make_json_from_form_csv
# Create the scenario JSON files needed to run VisionEval Scenarios from the standard
# scenario CSV database.
#
# Parameters:
#   input_form_file_name:
#     Standard VisionEval scenario configuration CSV file, which can have any name and
#     file location that you wish. 
#   output_scenario_dir:
#     Output scenario directory, into which the two standard scenario configuration
#     JSON files, `scenario_config.json` and `category_config.json`, will be written.
ve.scenario_management.make_json_from_form_csv <- function (input_form_file_name, 
                                               output_scenario_dir) {
  
  input_form_df <- read_scenario_form_from_csv(input_form_file_name)
  
  output_scenario_file_name <- file.path(output_scenario_dir, "scenario_config.json")
  output_category_file_name <- file.path(output_scenario_dir, "category_config.json")
  
  make_scenario_json_from_form(input_form_df, output_scenario_file_name)
  make_category_json_from_form(input_form_df, output_category_file_name)
  
}

# ve.scenario_management.make_directory_structure
# Create a VisionEval Scenario structure from the category and level definitions
# in the standard scenario CSV file.
#
# Parameters:
#   target_root_dir: 
#      The file path of the location where you want the folder structure to be 
#      constructed. 
#   input_form_file_name:
#     Standard VisionEval scenario configuration CSV file, which can have any name and
#     file location that you wish. 
ve.scenario_management.make_directory_structure <- function(target_root_dir, input_form_csv){
  
  form_df <- read_scenario_form_from_csv(input_form_csv)
  
  for (row_index in 1:nrow(form_df)) {
    
    relevant_row_df <- slice(form_df, row_index:row_index)
    level_one_dir <- file.path(target_root_dir, relevant_row_df$category_name)
    level_two_dir <- file.path(level_one_dir, relevant_row_df$level_name)
    
    if(!dir.exists(level_one_dir)) dir.create(level_one_dir)
    if(!dir.exists(level_two_dir)) dir.create(level_two_dir)
    
  }
  
}


# end: public methods ----------------------------------------------------------



