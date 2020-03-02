library(ggplot2)
library(dplyr)
library(plotly)
library(leaflet)
library(lintr)
library(rmarkdown)
library(tidyverse)

rm(list = ls())

raw_data <- read.csv("../data/2-27 dataset/02-27-2020.csv",
                    stringsAsFactors = F)

# Organized table showing most to least death by the Coronavirus
table <- raw_data %>%
  group_by(Country.Region) %>%
  summarise(total_death = sum(Deaths, na.rm = TRUE)) %>%
  arrange(-total_death)
