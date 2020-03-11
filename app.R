# This clears the workspace
rm(list = ls())
# This loads the dplyr library
library("dplyr")
# This loads the leaflet library
library("leaflet")
# This loads the shiny library
library("shiny")
# This loads the ggplot2 library
library("ggplot2")
# This loads the ggplot2 library
library("plotly")
# This loads the tidyverse library
library("tidyverse")
# This loads the shinythemes library
library("shinythemes")
# This loads the tidyr library
library("tidyr")
# This establishes the connection to the my_server.R file
source("my_server.R")
# This establishes the connection to the my_ui.R file
source("my_ui.R")

# This stops the console from outputting all the returns from the server
options(shiny.trace = F)
# This compiles and runs the app
shinyApp(ui = my_ui, server = my_server)
