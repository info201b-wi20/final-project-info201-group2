my_server <- function(input, output) {
  
  coronavirus_dataset = read.csv("data/3-02 dataset/03-02-2020.csv",
                     stringsAsFactors = FALSE
  )

    map <- leaflet(data = coronavirus_dataset) %>%
      addProviderTiles("Stamen.TonerLite") %>% # add Stamen Map Tiles
      addCircleMarkers( # add markers for each shooting
        lat = ~Latitude,
        lng = ~Longitude,
        fillOpacity = .7,
        radius = ~Deaths,
        stroke = FALSE
      )
    output$myMap = renderLeaflet(map)
}
