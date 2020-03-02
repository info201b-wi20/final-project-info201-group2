
# This clears the work environment
rm(list = ls())

# This loads the dplyr library
library(dplyr)

# This loads the data, strings are not interpreted as factors
corona_virus_data <- read.csv("../data/2-27 dataset/02-27-2020.csv",
                              stringsAsFactors = FALSE)

# This is the number Provinces/City & Countries from which data regarding
# coronavirus has been collected
num_cases <- nrow(corona_virus_data)

# This is the number of total cases confirmed as of 02/27/2020
total_confirmed_cases <- sum(corona_virus_data$Confirmed, na.rm = TRUE)

# This is the number of people who have died from coronavirus as of 02/27/2020
total_death_toll <- sum(corona_virus_data$Deaths, na.rm = TRUE)

# This is the number of people who have recovered from coronavirus as of
# 02/27/2020
total_recovered_toll <- sum(corona_virus_data$Recovered, na.rm = TRUE)
