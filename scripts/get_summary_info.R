# A function that takes in a dataset("../data/2-27 dataset/02-27-2020.csv")
# and returns a list of info about it:
library(dplyr)

get_summary_info <- function(dataset) {
  dataset <- dataset %>%
    filter(!is.na(Confirmed))
  dataset[is.na(dataset)] <- 0
  ret <- list()
  ret$length <- length(dataset)
  ret$country_region_affected <- length(unique(dataset$Country.Region))
  ret$province_state_affected <- length(dataset$Province.State)
  ret$total_confirmed <- sum(dataset$Confirmed)
  ret$total_death <- sum(dataset$Deaths)
  ret$total_recovery <- sum(dataset$Recovered)
  ret$most_affected_country_region <- dataset %>%
    filter(Confirmed == max(Confirmed)) %>%
    pull(Country.Region)
  return(ret)
}



