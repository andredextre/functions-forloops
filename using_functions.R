#Load libraries ----
library(tidyverse)
library(chron)
library(naniar)

#Source function ----
source("utils/clean_ocean_temps.R")

# Import data ----
alegria <- read_csv(here::here("data", "raw_data", "alegria_mooring_ale_20210617.csv"))
mohawk <- read_csv(here::here("data", "raw_data", "mohawk_mooring_mko_20220330.csv"))
carpinteria <- read_csv(here::here("data", "raw_data", "carpinteria_mooring_car_20220330.csv"))

# clean data ---- 
alegria_clean <- clean_ocean_temps(raw_data = alegria, "alegria")
mohaw_clean <- clean_ocean_temps(mohawk, "mohawk", include_temps = c("Temp_bot")) 
carpinteria_clean <- clean_ocean_temps(carpinteria, "Carpinteria", include_temps = c("Temp_top", "Temp_bot"))

