# A function that takes in a dataset("../data/1-22-2020 to 2-27-2020 data/
#                                     02-27-2020.csv")
# and returns a list of info about it:
library(dplyr)
get_summary_info <- function(dataset) {
  dataset <- read.csv("../data/1-22-2020 to 2-27-2020 data/02-27-2020.csv",
                      stringsAsFactors = F)
  dataset <- dataset %>%
    filter(!is.na(Confirmed))
  dataset[is.na(dataset)] <- 0
  colnames(dataset)[1] <- c("Province.State")
  ret <- list()
  ret$length <- length(dataset)
  ret$country_region_affected <- length(unique(dataset$Country.Region))
  ret$province_state_affected <- length(dataset$Province.State)
  ret$total_confirmed <- sum(Confirmed)
  ret$total_death <- sum(Deaths)
  ret$total_recovery <- sum(Recovered)
  ret$most_affected_country_region <- dataset %>%
    filter(Confirmed == max(Confirmed)) %>%
    pull(Country.Region)
  return(ret)
}
