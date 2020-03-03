rm(list = ls())
library(ggplot2)
library(dplyr)
library(ggforce)

dataset <- read.csv("data/3-02 dataset/03-02-2020.csv",
  stringsAsFactors = F
)

dataset <- dataset %>%
  filter(!is.na(Confirmed))

dataset[is.na(dataset)] <- 0

dataset1 <- dataset %>%
  group_by(Country.Region) %>%
  summarize(
    total_confirmed = sum(Confirmed),
    total_death = sum(Deaths)
  ) %>%
  top_n(5, wt = total_confirmed)

dataset1$Country.Region <- gsub("\\s", "\n", dataset1$Country.Region)

max_country <- dataset %>%
  group_by(Country.Region) %>%
  summarize(
    total_confirmed = sum(Confirmed),
    total_death = sum(Deaths)
  ) %>%
  top_n(1, wt = total_confirmed) %>%
  pull(Country.Region)

confirmed_region_plot <- ggplot(dataset1, aes(
  x = Country.Region,
  y = total_confirmed,
  fill = total_death
)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = total_confirmed),
    vjust = -0.2, color = "black",
    position = position_dodge(0.9), size = 3.5
  ) +
  facet_zoom(ylim = c(500, 5000)) +
  ggtitle("Total confirmed cases vs Country/Region") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(
    x = "Country/Region",
    y = "# confirmed cases",
    fill = "# deaths"
  )
