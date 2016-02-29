shinyUI(pageWithSidebar(
    headerPanel("H-1B Disclosure Data, Oct 2014 - Dec 2015"),
    sidebarPanel(
        width = 2,
        # List fields that can be searched
        textInput("CASE_STATUS",    "Search CASE_STATUS",    value = "") ,
        textInput("EMPLOYER_NAME",  "Search EMPLOYER_NAME",  value = "") ,
        textInput("WORKSITE_CITY",  "Search WORKSITE_CITY",  value = "") ,
        textInput("WORKSITE_STATE", "Search WORKSITE_STATE", value = "") ,
        selectInput("xsearch1", NULL, choices =
            c("EMPLOYMENT_START_DATE","JOB_TITLE","SOC_NAME","TOTAL.WORKERS","PW_WAGE_LEVEL","PREVAILING_WAGE",
              "PW_UNIT_OF_PAY","WAGE_RATE_OF_PAY","WAGE_UNIT_OF_PAY","LOW_WAGE","WAGE_PW","H.1B_DEPENDENT","WILLFUL.VIOLATOR",

              "CASE_NUMBER","CASE_SUBMITTED","DECISION_DATE","VISA_CLASS","EMPLOYMENT_END_DATE","EMPLOYER_ADDRESS1",
              "EMPLOYER_ADDRESS2","EMPLOYER_CITY","EMPLOYER_STATE","EMPLOYER_POSTAL_CODE","EMPLOYER_COUNTRY",
              "EMPLOYER_PROVINCE","EMPLOYER_PHONE","EMPLOYER_PHONE_EXT","AGENT_ATTORNEY_NAME","AGENT_ATTORNEY_CITY",
              "AGENT_ATTORNEY_STATE","SOC_CODE","NAIC_CODE","FULL_TIME_POSITION","PW_WAGE_SOURCE",
              "PW_WAGE_SOURCE_YEAR","PW_WAGE_SOURCE_OTHER","WORKSITE_COUNTY","WORKSITE_POSTAL_CODE"),
            selected = "H.1B_DEPENDENT"),
        textInput("ysearch1", NULL, value = ""),
        selectInput("xsearch2", NULL, choices =
            c("EMPLOYMENT_START_DATE","JOB_TITLE","SOC_NAME","TOTAL.WORKERS","PW_WAGE_LEVEL","PREVAILING_WAGE",
              "PW_UNIT_OF_PAY","WAGE_RATE_OF_PAY","WAGE_UNIT_OF_PAY","LOW_WAGE","WAGE_PW","H.1B_DEPENDENT","WILLFUL.VIOLATOR",

              "CASE_NUMBER","CASE_SUBMITTED","DECISION_DATE","VISA_CLASS","EMPLOYMENT_END_DATE","EMPLOYER_ADDRESS1",
              "EMPLOYER_ADDRESS2","EMPLOYER_CITY","EMPLOYER_STATE","EMPLOYER_POSTAL_CODE","EMPLOYER_COUNTRY",
              "EMPLOYER_PROVINCE","EMPLOYER_PHONE","EMPLOYER_PHONE_EXT","AGENT_ATTORNEY_NAME","AGENT_ATTORNEY_CITY",
              "AGENT_ATTORNEY_STATE","SOC_CODE","NAIC_CODE","FULL_TIME_POSITION","PW_WAGE_SOURCE",
              "PW_WAGE_SOURCE_YEAR","PW_WAGE_SOURCE_OTHER","WORKSITE_COUNTY","WORKSITE_POSTAL_CODE"),
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
        selectInput("xshow2", "Show (other)", choices =
            c("CASE_NUMBER","CASE_SUBMITTED","DECISION_DATE","VISA_CLASS","EMPLOYMENT_END_DATE","EMPLOYER_ADDRESS1",
              "EMPLOYER_ADDRESS2","EMPLOYER_CITY","EMPLOYER_STATE","EMPLOYER_POSTAL_CODE","EMPLOYER_COUNTRY",
              "EMPLOYER_PROVINCE","EMPLOYER_PHONE","EMPLOYER_PHONE_EXT","AGENT_ATTORNEY_NAME","AGENT_ATTORNEY_CITY",
              "AGENT_ATTORNEY_STATE","SOC_CODE","NAIC_CODE","FULL_TIME_POSITION","PW_WAGE_SOURCE",
              "PW_WAGE_SOURCE_YEAR","PW_WAGE_SOURCE_OTHER","WORKSITE_COUNTY","WORKSITE_POSTAL_CODE"),
            selected = "", multiple = TRUE),
        # List options for maximum column width, total width, and total rows
        numericInput("colwidth", "Maximum Column Width", value = "40") ,
        numericInput("totwidth", "Maximum Total Width",  value = "240") ,
        numericInput("totrows",  "Maximum Total Rows",   value = "900") ),
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