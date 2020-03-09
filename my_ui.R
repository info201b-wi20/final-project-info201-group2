my_ui <- fluidPage(
  navbarPage(
    "Coronavirus Data",
    tabPanel(
      "Project Overview",
      h1("Coronavirus"),
      
      p("Coronavirus (more formally referred to as novel Coronavirus;
        or COVID-19) is a large family of viruses that has newly
        been identified in humans. Coronavirus has proven to be
        a serious threat to the wellbeing of many people across 
        the world. According to CNN as of March 2nd, 2020 there
        have been over 3,000 victims
        globally. We are interested in researching this field
        because it is a genuinely concerning illness and there
        have been several confirmed cases even in North America.
        As of March 2nd, 2020 there have been 5 deaths due to 
        coronavirus in Washington; this further
        raises concerns as this issue is now impacting our community
        directly. So we gathered information and datasets from 
        Johns Hopkins CSS and generate this report."),
      

      ),
    
    tabPanel(
      "Interactive Page #1",
      sidebarLayout(
        sidebarPanel(
        ),
        mainPanel(
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
      "Interactive Page #3",
      sidebarLayout(
        sidebarPanel(
        ),
        mainPanel(
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