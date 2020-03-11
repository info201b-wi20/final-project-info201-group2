map_data <- read.csv("data/report-3-07-20.csv")
total_count <- map_data %>%
  summarize(
    total_confirmed = sum(Confirmed),
    total_deaths = sum(Deaths),
    total_recovered = sum(Recovered)
  )

country_region_list <- coronavirus_dataset %>%
  arrange(Country.Region) %>%
  pull(Country.Region)

my_ui <- fluidPage(
  includeCSS("style.css"),
  navbarPage(
    "Coronavirus Data",
    tabPanel(
      "Project Overview",
      h1("Coronavirus Research Project"),
      HTML
      ('<center>
        <img src="https://storage.aanp.org/www/images/news-feed/_large/Coronavirus.png">
        </center>'),
      p(),
      ("Coronavirus (more formally referred to as novel Coronavirus;
        or COVID-19) is a large family of viruses that has newly
        been identified in humans. Coronavirus has proven to be
        a serious threat to the wellbeing of many people across
        the world. According to "), a("CNN",
        href =
      "https://www.cnn.com/2020/03/10/world/newsletter-coronavirus-03-10-20-intl/index.html"
      ),
      ("as of March 9th, 2020 there
        have been over 3,800 victims
        globally. We are interested in researching this field
        because it is a genuinely concerning illness and there
        have been several hundred confirmed cases even in North America.
        As of March 9th, 2020 there have been over 20 deaths due to
        coronavirus in Washington; this further
        raises concerns as this issue is now impacting our community
        directly."),

      h3("What questions are we aiming to answer?"),
      p(
        "How is the lethality of the virus change over time?"
      ),
      p(
        "How is this virus spreading geographically? In what regions
        is it the most severe, and if we have the data, which specific
        states and provinces?"
      ),
      p(
        "How many patients who are sick with this virus dying vs recovering
        in different areas across the world?"
      ),
      h3("From where did we collect our data?"),

      p(
        "The data is collected from researchers at Johns Hopkins University
        Center for Systems Science and Engineering. The data collected
        is compiled from the WHO as well as several other official
        government sources."
      ),

      h3("Other projects involving coronavirus that we have come across"),
      p(),
      (
        "One of the most detailed data driven projects that we came across
        was from"), a("Johns Hopkins University;",
        href = "https://systems.jhu.edu/research/public-health/ncov/"
      ),
      ("they created an interactive map
        that entails many characteristics regarding this virus in a meaningful
        and interactive way."
      ),
      p(),
      (
        "Another data driven project regarding coronavirus comes from"),
      a("CDC.gov.;",
        href =
    "https://www.cdc.gov/coronavirus/2019-ncov/locations-confirmed-cases.html"
      ),
      ("They have created a map showing every location with confirmed cases
        of this virus as well as specific information regarding cases
        confirmed in the US (including information regarding whether
        the disease spread through travel or from person to person)."
      ),
      p(),
      (
        "The third data driven project that we found related to this
        domain comes from"), a("ECDC.Europa.Eu;",
        href =
  "https://www.ecdc.europa.eu/en/geographical-distribution-2019-ncov-cases"
      ),
      ("They have compiled a list
        of data regarding the distribution of cases geographically
        including information regarding whether the virus was locally
        spread or from other nations (what they refer to as imported
        cases). They have an interactive map detailing the specific
        circumstances under which the virus has spread on a case
        to case basis."
      ),
    ),

    tabPanel(
      "Live Update",
      titlePanel("Live Update"),
      verticalLayout(
        sidebarPanel(
          div(
            h4("Confirmed Cases")
          ),
          selectInput(
            inputId = "country",
            label = "Select a country",
            choices = list(
              "US" = "US", "China" = "Mainland China",
              "United Kingdoms" = "UK", "Japan" = "Japan",
              "Korea" = "South Korea", "Italy" = "Italy",
              "Iran" = "Iran", "France" = "France",
              "Spain" = "Spain", "Germany" = "Germany"
            )
          ),
          selectInput("color_given",
            "Choose a color:",
            choices = list(
              "Red" = "red", "Blue" = "blue",
              "Purple" = "purple",
              "Black" = "black"
            )
          )
        ),
        mainPanel(
          width = 12,
          plotlyOutput("confirmed_count")
        )
      )
    ),

    tabPanel(
      "Coronavirus Map",
      titlePanel("Coronavirus Map"),
      sidebarLayout(
        sidebarPanel(
          div(
            h4("Global Confirmed Cases")
          ),
          selectInput(
            inputId = "select_country",
            label = "Select a country",
            choices = list(
              "Default" = "default", "US" = "US",
              "China" = "Mainland China",
              "United Kingdoms" = "UK", "Japan" = "Japan",
              "Korea" = "South Korea",
              "Italy" = "Italy", "Italy" = "Italy",
              "Iran" = "Iran", "France" = "France",
              "Spain" = "Spain", "Germany" = "Germany"
            )
          ),
          div(
            strong(textOutput("confirmed_text")),
            br(),
            strong(textOutput("death_text")),
            br(),
            strong(textOutput("recovered_text")),
            br()
          )
        ),
        mainPanel(
          leafletOutput("live_maps"),
          p("This map display
            a global cumulated confirmed cases of the COVID-19")
        )
      )
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
          h2("Selected Countries"),
          h3("Live Update"),
          textOutput(outputId = "summ_sb_lu_chosen_country"),
          p(),
          h3("Coronavirus Map"),
          textOutput(outputId = "summ_sb_cm_chosen_country"),
          p(),
          h3("Percentage of Death and Recovery"),
          textOutput(outputId = "summ_sb_perc_chosen_country"),
          textOutput(outputId = "state_output")
        ),

        mainPanel(
          h2(textOutput(outputId = "summ_heading_lu")),
          h4(textOutput(outputId = "summ_info_one")),
          p(),
          h2(textOutput(outputId = "summ_heading_two")),
          h4(textOutput(outputId = "map_info_one")),
          h4(textOutput(outputId = "map_info_two")),
          h4(textOutput(outputId = "map_info_three")),
          h4(textOutput(outputId = "recovery_rate")),
          h4(textOutput(outputId = "death_rate")),
          p(),
          h2(textOutput(outputId = "summ_heading_three")),
          h4(textOutput(outputId = "rate_death")),
          h4(textOutput(outputId = "rate_recover"))
        )
      ),
    )
  )
)
