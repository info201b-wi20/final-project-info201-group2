library(shiny)
library(ggplot2)
library(shinythemes)
library(plotly)
library(leaflet)
library(dplyr)
library(tidyr)

source("scripts/globals.R")

# real data after modified for live update interactive page
raw_data2 <- read.csv("data/confirm_cases2.csv", stringsAsFactors = F)

# for producing the line graph in the live update interacitve page
get_graph <- function(country, datasets, colors) {
  dataset <- datasets %>%
    filter(Country.Region == country) %>%
    arrange(date)
  ggplot(data = dataset, mapping = aes(x = date, y = total_count, group = 1)) +
    geom_line(color = colors) +
    geom_point(color = colors) +
    labs(x = "Date", y = "Confirmed count") +
    ggtitle(paste0("Confirmed count for ", country, " since Jan 22")) +
    theme(plot.title = element_text(hjust = 0.5))
}

map_data <- read.csv("data/report-3-07-20.csv", stringsAsFactors = F)
# display a map of all the confirmed cases in by 3/07

coronavirus_dataset <- read.csv("data/3-07 dataset/report-3-07-20.csv",
  stringsAsFactors = FALSE
)

my_server <- function(input, output, session) {
  output$confirmed_count <- renderPlotly(
    get_graph(input$country, raw_data2, input$color_given)
  )
  output$live_maps <- renderLeaflet({
    datas <- map_data %>%
      filter(if (input$select_country == "default") {
        Country.Region == Country.Region
      } else {
        Country.Region == input$select_country
      })
    data_popup_details <- datas %>%
      mutate(popup_details = paste0(
        "Location: ", Province.State, ", ", Country.Region,
        "</br>Confirmed: ", Confirmed,
        "</br>Deaths: ", Deaths,
        "</br>Recovered: ", Recovered
      ))

    leaflet(data_popup_details) %>%
      addTiles() %>%
      addCircleMarkers(
        lat = ~Latitude,
        lng = ~Longitude,
        popup = ~popup_details,
        color = "red",
        stroke = FALSE
      )
  })
  output$confirmed_text <- renderText(
    paste("Confirmed:", map_data %>%
      filter(if (input$select_country == "default") {
        Country.Region == Country.Region
      } else {
        Country.Region == input$select_country
      }) %>%
      summarize(total = sum(Confirmed)) %>%
      pull(total))
  )
  output$death_text <- renderText(
    paste("Deaths:", map_data %>%
      filter(if (input$select_country == "default") {
        Country.Region == Country.Region
      } else {
        Country.Region == input$select_country
      }) %>%
      summarize(total = sum(Deaths)) %>%
      pull(total))
  )
  output$recovered_text <- renderText(
    paste("Recovered:", map_data %>%
      filter(if (input$select_country == "default") {
        Country.Region == Country.Region
      } else {
        Country.Region == input$select_country
      }) %>%
      summarize(total = sum(Recovered)) %>%
      pull(total))
  )

  observeEvent(
    input$country_region,
    updateSelectInput(session, "province_state", "Select a province or state",
      choices = coronavirus_dataset %>%
        filter(Country.Region == input$country_region) %>%
        pull(Province.State)
    )
  )

  country_without_state <- coronavirus_dataset %>%
    filter(Province.State == "") %>%
    pull(Country.Region) %>%
    unique()

  output$pie <- renderPlotly({
    if (input$country_region %in% country_without_state) {
      data1 <- coronavirus_dataset %>%
        filter(
          Country.Region == input$country_region
        ) %>%
        select(Confirmed, Deaths, Recovered) %>%
        mutate("Patients" = Confirmed - Deaths - Recovered)
    } else {
      data1 <- coronavirus_dataset %>%
        filter(
          Country.Region == input$country_region,
          Province.State == input$province_state
        ) %>%
        select(Confirmed, Deaths, Recovered) %>%
        mutate("Patients" = Confirmed - Deaths - Recovered)
    }
    data2 <- data1 %>%
      summarize(
        "Patients" = !!as.name("Patients") / Confirmed,
        "Deaths" = Deaths / Confirmed,
        "Recovered" = Recovered / Confirmed
      ) %>%
      gather(
        key = category,
        value = percent,
        na.rm = T
      )
    data3 <- data1 %>%
      gather(
        key = category,
        value = number
      )
    data4 <- left_join(data2, data3, by = "category")

    if (input$country_region %in% country_without_state) {
      location <- input$country_region
    } else {
      location <- paste0(input$province_state, ", ", input$country_region)
    }
    plot_ly(
      data = data4, type = "pie", labels = ~category,
      values = ~percent,
      hovertemplate = paste("%{label} number: ", data4$number)
    ) %>%
      layout(title = list(
        text = paste0(
          "Percentage of Death & Recovery in ",
          location
        ),
        y = 0.05
      ))
  })

  output$summ_sb_lu_chosen_country <- renderText({
    message_str <- paste0("Country/Region Selected: ", input$country)
    message_str
  })

  output$summ_sb_cm_chosen_country <- renderText({
    message_str <- paste0("Country/Region Selected: ", input$select_country)
    message_str
  })

  output$summ_sb_perc_chosen_country <- renderText({
    message_str <- paste0("Country/Region Selected: ", input$country_region)
    message_str
  })

  output$state_output <- renderText({
    if (input$country_region %in% country_without_state) {
      message_str <- paste0("State/Province Selected: N/A")
    } else {
      message_str <- paste0("State/Province Selected: ", input$province_state)
    }
    message_str
  })

  output$summ_heading_lu <- renderText({
    message_str <- paste0("Maximum Confirmed Cases in ", input$country)
  })

  output$summ_info_one <- renderText({
    confirmed_max <- raw_data2 %>%
      filter(Country.Region == input$country) %>%
      filter(total_count == max(total_count))

    message_str <- paste0(
      "Maximum number of cases: ",
      confirmed_max$total_count,
      " on ", confirmed_max$date
    )
  })

  output$summ_heading_two <- renderText({
    message_str <- paste0("Map Summary of ", input$select_country)
  })

  output$map_info_one <- renderText({
    confirmed_total <- map_data %>%
      filter(Country.Region == input$select_country) %>%
      group_by(Country.Region) %>%
      summarise(Confirmed = sum(Confirmed))

    message_str <- paste0("Total Confirmed Cases: ", confirmed_total$Confirmed)
  })

  output$map_info_two <- renderText({
    death_count <- map_data %>%
      filter(Country.Region == input$select_country) %>%
      group_by(Country.Region) %>%
      summarise(Deaths = sum(Deaths))

    message_str <- paste0("Total deaths: ", death_count$Deaths)
  })

  output$map_info_three <- renderText({
    recover_count <- map_data %>%
      filter(Country.Region == input$select_country) %>%
      group_by(Country.Region) %>%
      summarise(Recovered = sum(Recovered))

    message_str <- paste0("Total Recovered: ", recover_count$Recovered)
  })

  output$recovery_rate <- renderText({
    rate_table <- map_data %>%
      filter(Country.Region == input$select_country) %>%
      summarise(
        Confirmed = sum(Confirmed),
        Deaths = sum(Deaths),
        Recovered = sum(Recovered)
      )

    recov_rate <- round((rate_table$Recovered / rate_table$Confirmed) * 100, 2)
    message_str <- paste0("Recovery Rate: ", recov_rate)
  })

  output$death_rate <- renderText({
    rate_table <- map_data %>%
      filter(Country.Region == input$select_country) %>%
      summarise(
        Confirmed = sum(Confirmed),
        Deaths = sum(Deaths),
        Recovered = sum(Recovered)
      )
    death_perc <- round((rate_table$Deaths / rate_table$Confirmed) * 100, 2)
    message_str <- paste0("Death Rate: ", death_perc)
  })

  output$summ_heading_three <- renderText({
    if (input$country_region %in% country_without_state) {
      message_str <- paste0("Percentage Summary of ", input$country_region)
    } else {
      paste0("Percentage Summary of ", input$country_region,
             ", ", input$province_state)
    }
  })

  output$rate_death <- renderText({
    if (input$country_region %in% country_without_state) {
      rates <- map_data %>%
        filter(Country.Region == input$country_region) %>%
        summarise(Confirmed = sum(Confirmed),
                  Deaths = sum(Deaths),
                  Recovered = sum(Recovered))

        death_perc <- round((rates$Deaths / rates$Confirmed) * 100, 2)
        message_str <- paste0("Death Rate of ",
                              input$country_region, ": ",
                              death_perc)
    } else {
      rates <- map_data %>%
        filter(Province.State == input$province_state) %>%
        summarise(Confirmed = sum(Confirmed),
                  Deaths = sum(Deaths),
                  Recovered = sum(Recovered))

      death_perc <- round((rates$Deaths / rates$Confirmed) * 100, 2)
      message_str <- paste0("Death Rate of ",
                            input$province_state, ": ",
                            death_perc)
    }
  })

  output$rate_recover <- renderText({
    if (input$country_region %in% country_without_state) {
      rates <- map_data %>%
        filter(Country.Region == input$country_region) %>%
        summarise(Confirmed = sum(Confirmed),
                  Deaths = sum(Deaths),
                  Recovered = sum(Recovered))

      recov_perc <- round((rates$Recovered / rates$Confirmed) * 100, 2)
      message_str <- paste0("Recovery Rate of ",
                            input$country_region, ": ",
                            recov_perc)
    } else {
      rates <- map_data %>%
        filter(Province.State == input$province_state) %>%
        summarise(Confirmed = sum(Confirmed),
                  Deaths = sum(Deaths),
                  Recovered = sum(Recovered))

      recov_perc <- round((rates$Recovered / rates$Confirmed) * 100, 2)
      message_str <- paste0("Recovery Rate of ",
                            input$province_state, ": ",
                            recov_perc)
    }
  })
}
