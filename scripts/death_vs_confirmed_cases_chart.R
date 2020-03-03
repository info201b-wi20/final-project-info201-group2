
# This clears the work environment
rm(list = ls())

# This loads the dplyr library
library(dplyr)

# This loads the ggplot2 library
library("ggplot2")

# This loads the data as a dataframe, strings are not interpreted as factors
corona_virus_data <- read.csv("./data/2-27 dataset/02-27-2020.csv",
                              stringsAsFactors = FALSE)

# This is a copy of the dataframe, excluding the first row
coronva_virus_data_mod <- corona_virus_data[2:105,]

# This creates a plot of the number of deaths vs the number of confirmed cases, including Hubei, the epicenter of the disease
chart_including_hubei <- ggplot(corona_virus_data, aes(Deaths, Confirmed)) + 
  geom_point()

# This creates a plot of the number of deaths vs the number of confirmed cases, excluding Hubei, the epicenter of the disease
# The purpose of exlcuding Hubei is because the toll is so much more extreme than any other Province/City & Country that it 
# makes the data very difficult to read
chart_excluding_hubei <- ggplot(coronva_virus_data_mod, aes(Deaths, Confirmed)) + 
  geom_point()