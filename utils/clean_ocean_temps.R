clean_ocean_temps <- function(raw_data, site_name, include_temps = c("Temp_top", "Temp_mid", "Temp_bot")) {
  
  #If data contains these cols, clean the script ----
  if(all(c("year", "month", "day", "decimal_time", "Temp_bot", "Temp_mid", "Temp_top") 
         %in% colnames(raw_data))) {
    
    message("Cleanin data....")
  
    #format site name ----
    site_name_formatted <- paste(str_to_title(site_name), "Reef")
    
    #Cols to select ----
    always_selected_cols <- c("year", "month", "day", "decimal_time")
    all_cols <- append(always_selected_cols, include_temps)
    
    #Clean data ----
    temps_clean <- raw_data %>%
      #Keep some columns & years 
      select(all_of(all_cols)) %>%
      filter(year %in% c(2005:2020)) %>%
      #mutate site column ----
    mutate(site = rep(site_name_formatted)) %>% 
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
      select(any_of(c("site", 
                      "date_time", 
                      "year", 
                      "month", 
                      "day", "
                    month_name", 
                    "Temp_bot", 
                    "Temp_mid", 
                    "Temp_top")))
  } else {
    stop("The data from provided does not include the necessary columns. Please check your columns")
  }
  
 

  #Return clean data ----
  return(temps_clean)
  
}
