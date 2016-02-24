shinyUI(pageWithSidebar(
    headerPanel("H-1B Disclosure Data FY15 Q4"),
    sidebarPanel(
        width = 2,
        # List fields that can be searched
        textInput("CASE_STATUS",    "Search CASE_STATUS",    value = "") ,
        textInput("EMPLOYER_NAME",  "Search EMPLOYER_NAME",  value = "") ,
        textInput("WORKSITE_CITY",  "Search WORKSITE_CITY",  value = "") ,
        textInput("WORKSITE_STATE", "Search WORKSITE_STATE", value = "") ,
        selectInput("xsearch1", NULL,
                    choice   = c("EMPLOYMENT_START_DATE","JOB_TITLE","SOC_NAME","TOTAL.WORKERS","PW_WAGE_LEVEL","PREVAILING_WAGE","PW_UNIT_OF_PAY","WAGE_RATE_OF_PAY","WAGE_UNIT_OF_PAY","LOW_WAGE","WAGE_PW","H.1B_DEPENDENT","WILLFUL.VIOLATOR"),
                    selected = "H.1B_DEPENDENT"), 
        textInput("ysearch1", NULL, value = ""),
        selectInput("xsearch2", NULL,
                    choice   = c("EMPLOYMENT_START_DATE","JOB_TITLE","SOC_NAME","TOTAL.WORKERS","PW_WAGE_LEVEL","PREVAILING_WAGE","PW_UNIT_OF_PAY","WAGE_RATE_OF_PAY","WAGE_UNIT_OF_PAY","LOW_WAGE","WAGE_PW","H.1B_DEPENDENT","WILLFUL.VIOLATOR"),
                    selected = "WILLFUL.VIOLATOR"), 
        textInput("ysearch2", NULL, value = ""),
        # List fields to be sorted by
        selectInput("xsort", "Sort by",
            choice   = c("EMPLOYMENT_START_DATE","TOTAL.WORKERS","PW_WAGE_LEVEL","PREVAILING_WAGE","WAGE_RATE_OF_PAY","LOW_WAGE","WAGE_PW"),
            selected = "TOTAL.WORKERS"), 
        radioButtons("xsortdir", NULL, c("Ascending","Descending"), "Descending", inline = TRUE),
        # List choice and selected checkboxes for selecting which fields to display
        checkboxGroupInput("xshow", "Show",
            choice   = c("CASE_STATUS","EMPLOYMENT_START_DATE","EMPLOYER_NAME","JOB_TITLE","SOC_NAME","TOTAL.WORKERS","PW_WAGE_LEVEL","PREVAILING_WAGE","PW_UNIT_OF_PAY","WAGE_RATE_OF_PAY","WAGE_UNIT_OF_PAY","LOW_WAGE","WAGE_PW","H.1B_DEPENDENT","WILLFUL.VIOLATOR","WORKSITE_CITY","WORKSITE_STATE"),
            selected = c("CASE_STATUS",                        "EMPLOYER_NAME","JOB_TITLE",           "TOTAL.WORKERS",                                                   "WAGE_RATE_OF_PAY",                              "WAGE_PW",                                    "WORKSITE_CITY","WORKSITE_STATE"),
            inline = TRUE),
        # List options for maximum column width, total width, and total rows
        textInput("colwidth",  "Maximum Column Width", value = "40") ,
        textInput("totwidth",  "Maximum Total Width", value = "240") ,
        textInput("totrows",  "Maximum Total Rows", value = "900") ),
    mainPanel(
        div(
            tabsetPanel(id = "tabs",
                tabPanel("Output",
                    width = 10,
                    verbatimTextOutput("myText")
                ),
                #tabPanel("Plot",
                #         width = 10,
                #         imageOutput("myImage")
                #),
                tabPanel("Usage",
                    width = 10,
                    includeMarkdown("lca_usage.Rmd")
                )
            )
        ),
        width = 10)
    )
)