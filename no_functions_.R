# Load packages ----
library(tidyverse)
library(chron)
library(naniar)
library(ggridges)
library(stringr)

# Import data ----
alegria <- read_csv(here::here("data", "raw_data", "alegria_mooring_ale_20210617.csv"))
mohawk <- read_csv(here::here("data", "raw_data", "mohawk_mooring_mko_20220330.csv"))
carpinteria <- read_csv(here::here("data", "raw_data", "carpinteria_mooring_car_20220330.csv"))

#Clean data ----
alegria_clean <- alegria %>%
  #Keep some columns & years 
  select(year, month, day, decimal_time, Temp_bot, Temp_mid, Temp_top) %>%
  filter(year %in% c(2005:2020)) %>%
  #mutate site column ----
mutate(site = rep("Alegria Reef")) %>% 
  #Create date time column ---- 
unite(col = date, year, month, day, sep = "-", remove = FALSE) %>%
  #Format time ----
  mutate(time = times(decimal_time)) %>%
  #Combine date time ----
unite(col = date_time, date, time, sep = " ", remove = TRUE) %>%

#Coerce date types ----
mutate(date_time = as.POSIXct(date_time, "%Y-%m-%d %H:%M:%S", tz = "GMT"),
       year = as.factor(year),
       month = as.factor(month),
       day = as.numeric(day)) %>%
  #Replace 9999s with NAs
  replace_with_na(replace = list(Temp_bot = 9999, 
                                 Temp_mid = 9999,
                                 Temp_top = 9999)) %>% 
  #add month name ----
  mutate(month_name = as.factor(month.name[month])) %>%
  #Reorder columns
  select(site, date_time, year, month, day, month_name, Temp_bot, Temp_mid, Temp_top)


#Plot data ----
alegria_plot <- alegria_clean %>%
  group_by(month_name) %>% 
  ggplot(aes(x = Temp_bot,
             y = month_name,
             fill = after_stat(x))) +
  geom_density_ridges_gradient(rel_min_height = 0.01,
                               scale = 3) +
  scale_x_continuous(breaks = c(9, 12, 15, 18, 21)) +
  scale_y_discrete(limits = rev(month.name)) +
  scale_fill_gradientn(colors = c("#2C5374",
                                  "#778798",
                                  "#ADD8E6",
                                  "#EF8080",
                                  "#8B3A3A"), 
                                  name = "Temp. (°C)") +
  labs(x = "Bottom Temperature (°C)",
       title = "Bottom Temperatures at Alegria Reef, Santa Barbara, CA",
       subtitle = "Temperatures (°C) aggregated by month from 2005-2020") +
  theme_ridges(font_size = 13, grid = TRUE) +
  theme(axis.title.y = element_blank())

alegria_plot
