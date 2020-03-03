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
# so their progress in some way represents the overall progress in curing the
# virus.

<<<<<<< HEAD
raw_data <- read.csv("data/3-02 dataset/03-02-2020.csv",
  stringsAsFactors = FALSE
)

recovered_proportion <- raw_data %>%
  filter(Country.Region == "Mainland China") %>%
  group_by(Country.Region) %>%
  summarise(
    recoverProportion = sum(Recovered, na.rm = TRUE) /
      sum(Confirmed, na.rm = TRUE),
    deathPropotion = sum(Deaths, na.rm = TRUE) /
      sum(Confirmed, na.rm = TRUE),
=======
raw_data <- read.csv("./data/3-02 dataset/03-02-2020.csv",
  stringsAsFactors =
    FALSE
)

recovered_Proportion <- raw_data %>%
  filter(Country.Region == "Mainland China") %>%
  group_by(Country.Region) %>%
  summarise(
    recoverProportion = sum(Recovered, na.rm = TRUE) / sum(Confirmed,
      na.rm = TRUE
    ),
    deathPropotion = sum(Deaths, na.rm = TRUE) / sum(Confirmed,
      na.rm =
        TRUE
    ),
>>>>>>> 176f706f4cd8021c9b5e2cbc016172880f49211b
    neither = 1 - recoverProportion - deathPropotion
  )
data <- data.frame(
  group = c("Recover", "Deaths", "Neither"),
  value = c(
<<<<<<< HEAD
    recovered_proportion$recoverProportion,
    recovered_proportion$deathPropotion,
    recovered_proportion$neither
  )
)

# Organzied pie chart showing the proportion of the different stage
# the infected people are in at China.
=======
    recovered_Proportion$recoverProportion,
    recovered_Proportion$deathPropotion,
    recovered_Proportion$neither
  )
)

# Organzied pie chart showing the proportion of the different stage the
# infected people
# are in at China.
>>>>>>> 176f706f4cd8021c9b5e2cbc016172880f49211b
pie_chart <- ggplot(data, aes(x = "", y = value, fill = group)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void()
