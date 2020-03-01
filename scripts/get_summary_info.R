# A function that takes in a dataset("../data/COVID-19-aggregate.csv")
# and returns a list of info about it:
library(dplyr)
get_summary_info <- function(dataset) {
  dataset <- dataset %>%
    filter(!is.na(Confirmed))
  dataset[is.na(dataset)] <- 0
  colnames(dataset)[1] <- c("Province.State")
  ret <- list()
  ret$length <- length(dataset)
  ret$country_region_affected <- length(unique(dataset$Country.Region))
  ret$province_state_affected <- dataset %>%
    mutate(location = paste0(Province.State, ", ", Country.Region)) %>%
    summarize(number = length(unique(location))) %>%
    pull(number)
  ret$total_confirmed <- dataset %>%
    filter(Date == "2020/2/27") %>%
    summarize(total = sum(Confirmed, na.rm = T)) %>%
    pull(total)
  ret$total_death <- dataset %>%
    filter(Date == "2020/2/27") %>%
    summarize(total = sum(Deaths, na.rm = T)) %>%
    pull(total)
  ret$total_recovery <- dataset %>%
    filter(Date == "2020/2/27") %>%
    summarize(total = sum(Recovered, na.rm = T)) %>%
    pull(total)
  ret$most_affected_country_region <- dataset %>%
    filter(Date == "2020/2/27" & Confirmed == max(Confirmed, na.rm = T)) %>%
    pull(Country.Region)
  return(ret)
}
