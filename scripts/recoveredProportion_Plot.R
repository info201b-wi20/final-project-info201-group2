library(ggplot2)
library(dplyr)
library(plotly)
library(leaflet)
library(lintr)
library(rmarkdown)
library(tidyverse)
rm(list = ls())

# The chart looks at the percentage of people recovering from covid-19 in 2010
# Mainland China because China has the most confirmed cases,
# so their progress in some way represents the overall progress in curing the virus.

raw_data <- read.csv("../data/2-27 dataset/02-27-2020.csv", stringsAsFactors = FALSE)

RecoveredProportion <- raw_data %>%
  filter(Country.Region == "Mainland China") %>%
  group_by(Country.Region) %>%
  summarise(recoverProportion = sum(Recovered, na.rm = TRUE) / sum(Confirmed, na.rm = TRUE),
            deathPropotion = sum(Deaths, na.rm = TRUE) / sum(Confirmed, na.rm = TRUE),
            neither = 1 - recoverProportion - deathPropotion)
data <- data.frame(
  group = c("Recover", "Deaths", "Neither"),
  value = c(RecoveredProportion$recoverProportion, RecoveredProportion$deathPropotion,
            RecoveredProportion$neither))

# Organzied pie chart showing the proportion of the different stage the infected people 
# are in at China.
pie_chart <- ggplot(data, aes(x="", y=value, fill=group)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  theme_void()