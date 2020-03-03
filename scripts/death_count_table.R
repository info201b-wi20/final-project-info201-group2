library(ggplot2)
library(dplyr)
library(plotly)
library(leaflet)
library(lintr)
library(rmarkdown)
library(tidyverse)
library(knitr)

rm(list = ls())

<<<<<<< HEAD
raw_data <- read.csv("data/3-02 dataset/03-02-2020.csv",
=======
raw_data <- read.csv("./data/3-02 dataset/03-02-2020.csv",
>>>>>>> 176f706f4cd8021c9b5e2cbc016172880f49211b
  stringsAsFactors = F
)

# Organized table showing most to least death by the Coronavirus
table <- raw_data %>%
  group_by(Country.Region) %>%
  summarise(total_death = sum(Deaths, na.rm = TRUE)) %>%
  arrange(-total_death)

table_done <- kable(table, col.names = c("Region", "Total Deaths"))

top_4_country <- table %>%
  top_n(4, total_death) %>%
  pull(Country.Region)