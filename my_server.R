library(dplyr)
library(shiny)

my_server <- function(input, output, session) {

  coronavirus_dataset <- read.csv("data/3-07 dataset/report-3-07-20.csv",
                     stringsAsFactors = FALSE
  )

    map <- leaflet(data = coronavirus_dataset) %>%
      addProviderTiles("Stamen.TonerLite") %>% # add Stamen Map Tiles
      addCircleMarkers(# add markers for each shooting
        lat = ~Latitude,
        lng = ~Longitude,
        fillOpacity = .7,
        radius = ~Deaths,
        stroke = FALSE
      )
    output$myMap <- renderLeaflet(map)

    observeEvent(
      input$country_region,
      updateSelectInput(session, "province_state", "Select a province or state",
                        choices = coronavirus_dataset %>%
                          filter(Country.Region == input$country_region) %>%
                          pull(Province.State))
    )

    output$pie <- renderPlotly({
      data1 <- coronavirus_dataset %>%
        filter(Country.Region == input$country_region,
               Province.State == input$province_state) %>%
        select(Confirmed, Deaths, Recovered) %>%
        mutate("Patients" = Confirmed - Deaths - Recovered)
      data2 <- data1 %>%
        summarize("Patients" = !!as.name("Patients") / Confirmed,
                  "Deaths" = Deaths / Confirmed,
                  "Recovered" = Recovered / Confirmed) %>%
        gather(key = category,
               value = percent,
               na.rm = T)
      data3 <- data1 %>%
        gather(key = category,
               value = number)
      data4 <- left_join(data2, data3, by = "category")

      plot_ly(data = data4, type = "pie", labels = ~category,
              values = ~percent,
              hovertemplate = paste("%{label} number: ", data4$number))
    })
}
