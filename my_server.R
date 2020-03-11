library(shiny)
library(ggplot2)
library(shinythemes)
library(plotly)
library(leaflet)
library(dplyr)
library(tidyr)

# real data after modified for live update interactive page
raw_data2 <- read.csv("data/confirm_cases2.csv")

# for producing the line graph in the live update interacitve page
get_graph <- function(country, datasets, colors) {
  dataset <- datasets %>% 
    filter(Country.Region == country) %>% 
    arrange(date)
  ggplot(data = dataset, mapping = aes(x = date, y = total_count, group=1)) +
    geom_line(color = colors) +
    geom_point(color = colors) +
    labs(x = "Date", y = "Confirmed count") +
    ggtitle(paste0("Confirmed count for ", country, " since Jan 22")) +
    theme(plot.title = element_text(hjust = 0.5))
}

map_data <- read.csv("data/report-3-07-20.csv")
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
      filter(if(input$select_country == "default"){
        Country.Region == Country.Region
      } else {
        Country.Region == input$select_country
      })
    data_popup_details <- datas %>%
      mutate(popup_details = paste0("Location: ", Province.State, ", ", Country.Region,
                                    "</br>Confirmed: ", Confirmed,
                                    "</br>Deaths: ", Deaths,
                                    "</br>Recovered: ", Recovered))
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
            filter(if(input$select_country == "default"){
              Country.Region == Country.Region
            } else {
              Country.Region == input$select_country
            }) %>% 
            summarize(total = sum(Confirmed)) %>% 
            pull(total)))
  output$death_text <- renderText(
    paste("Deaths:", map_data %>% 
            filter(if(input$select_country == "default"){
              Country.Region == Country.Region
            } else {
              Country.Region == input$select_country
            }) %>% 
            summarize(total = sum(Deaths)) %>% 
            pull(total)))
  output$recovered_text<- renderText(
    paste("Recovered:", map_data %>% 
            filter(if(input$select_country == "default"){
              Country.Region == Country.Region
            } else {
              Country.Region == input$select_country
            }) %>% 
            summarize(total = sum(Recovered)) %>% 
            pull(total)))

  observeEvent(
    input$country_region,
    updateSelectInput(session, "province_state", "Select a province or state",
      choices = coronavirus_dataset %>%
        filter(Country.Region == input$country_region) %>%
        pull(Province.State)
    )
  )

  output$pie <- renderPlotly({
    data1 <- coronavirus_dataset %>%
      filter(
        Country.Region == input$country_region,
        Province.State == input$province_state
      ) %>%
      select(Confirmed, Deaths, Recovered) %>%
      mutate("Patients" = Confirmed - Deaths - Recovered)
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

    if (input$province_state == "") {
      location <- input$country_region
    } else {
      location <- paste0(input$province_state, ", ", input$country_region)
    }
    plot_ly(
      data = data4, type = "pie", labels = ~category,
      values = ~percent,
      hovertemplate = paste("%{label} number: ", data4$number)
    ) %>%
      layout(title = paste0("Percentage of Death & Recovery in ",
                            location))
  })
}
