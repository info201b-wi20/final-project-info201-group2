country_region_list <- coronavirus_dataset %>%
  arrange(Country.Region) %>%
  pull(Country.Region)

my_ui <- fluidPage(
  navbarPage(
    "Coronavirus Data",
    tabPanel(
      "Project Overview",
      h1("Coronavirus"),
      tags$img(src = "https://storage.aanp.org/www/images/news-feed/
               _large/Coronavirus.png"),
      p("Coronavirus (more formally referred to as novel Coronavirus;
        or COVID-19) is a large family of viruses that has newly
        been identified in humans. Coronavirus has proven to be
        a serious threat to the wellbeing of many people across
        the world. According to CNN as of March 9th, 2020 there
        have been over 3,800 victims
        globally. We are interested in researching this field
        because it is a genuinely concerning illness and there
        have been several confirmed cases even in North America.
        As of March 9th, 2020 there have been over 20 deaths due to
        coronavirus in Washington; this further
        raises concerns as this issue is now impacting our community
        directly."),

      h2("What questions are we aiming to answer?"),
      p(
        "How is the lethality of the virus change over time"
      ),
      p(
        "According to several news sources there have been reported cases
        of coronavirus that have been cured.
        Has this made a tangible impact on decreasing the lethality
        of this disease over time, or is it the rate at which it
        is spreading more influential?"
      ),
      p(
        "When does the infectiousness of the virus reach the
        maximum? Has the rate at which it spreading it
        already reached its peak (based on the given data)
        or is it continuing to become more extreme."
      ),
      h2("From where did we collect our data?"),

      p(
        "The data is collected from researchers at Johns Hopkins University
        Center for Systems Science and Engineering. The data collected
        is compiled from the WHO as well as several other official
        government sources."
      ),

      h2("Other projects involving coronavirus that we have come across"),
      p(
        "We came across a collection of databases on Reddit in which found
        several data driven projects."
      ),
      p(
        "One of the most detailed data driven projects that we came across
        was from Johns Hopkins University; they created an interactive map
        that entails many characteristics regarding this virus in a meaningful
        and interactive way."
      ),
      p(
        "Another data driven project regarding coronavirus comes from CDC.gov.
        They have created a map showing every location with confirmed cases
        of this virus as well as specific information regarding cases
        confirmed in the US (including information regarding whether
        the disease spread through travel or from person to person)."
      ),
      p(
        "The third data driven project that we found related to this
        domain comes from ECDC.Europa.Eu. They have compiled a list
        of data regarding the distribution of cases geographically
        including information regarding whether the virus was locally
        spread or from other nations (what they refer to as imported
        cases). They have an interactive map detailing the specific
        circumstances under which the virus has spread on a case
        to case basis."
      ),
      ),

    tabPanel(
      "Coronavirus Map",
      sidebarLayout(
        sidebarPanel(
          "Insert Sidebar Widget Here"
        ),
        mainPanel(
          leafletOutput("myMap"),
        )
      ),
    ),

    tabPanel(
      "Interactive Page #2",
      sidebarLayout(
        sidebarPanel(
        ),
        mainPanel(
        )
      ),
    ),

    tabPanel(
      "Percentage of Death & Recovery",
      titlePanel("Percentage of Death & Recovery in each Province/State"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "country_region",
            label = "Select a country or region",
            choices = country_region_list,
            selected = country_region_list[1]
          ),
          selectInput(
            inputId = "province_state",
            label = "Select a province or state",
            choices = NULL
          )
        ),
        mainPanel(
          plotlyOutput("pie")
        )
      ),
    ),

    tabPanel(
      "Summary Information",
      sidebarLayout(
        sidebarPanel(
        ),
        mainPanel(
        )
      ),
    )
  )
)
