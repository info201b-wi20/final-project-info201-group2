library(ggplot2)
library(dplyr)
library(plotly)
library(leaflet)
library(lintr)
library(rmarkdown)
library(tidyverse)
library(knitr)

rm(list = ls())

#raw_data <- read.csv("C:/Users/Gurjot/Desktop/final-project-info201-group2/data/2-27 dataset/02-27-2020.csv",
#                   stringsAsFactors = F)

raw_data <- read.csv("./data/2-27 dataset/02-27-2020.csv",
                     stringsAsFactors = F)

# Organized table showing most to least death by the Coronavirus
table <- raw_data %>%
  group_by(Country.Region) %>%
  summarise(total_death = sum(Deaths, na.rm = TRUE)) %>%
  arrange(-total_death)

table_done <- kable(table, col.names = c("Region", "Total Deaths"))
