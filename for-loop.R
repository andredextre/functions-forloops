# load packages ----
library(tidyverse)
library(chron)
library(naniar)
library(ggridges)
library(stringr)

# get list of files to iterate over ----
temp_files <- list.files(path = "data/raw_data", pattern = ".csv")

# for loop to read in data ----
for (i in 1:length(temp_files)) {
  
  # get object from file name ----
  file_name <- temp_files[i]
  message("Reading in: ", file_name)
  split_name <- str_split(file_name, "_")
  site_name <- split_name[[1]][1]
  message("Saving as: ", site_name)
  
  # read in csv ----
  assign(x = site_name, value = read_csv(here::here("data", "raw_data", file_name)))
  
}