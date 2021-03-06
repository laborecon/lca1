shinyServer(
    function(input, output) {
        #output$myImage <- renderImage({
        #    input$tabs
        #    list(src = "plot1.png",
        #         contentType = 'image/png',
        #         width = 840,
        #         height = 840,
        #         alt = "plot")
        #}, deleteFile = FALSE)
        output$myText <- renderPrint({
            library(plyr)
            # Initialize any local variables
            yr <- 15
            csvfile  <- "H-1B_FY15_Q4.csv"
            csvfile2 <- "H-1B_FY16_Q1.csv"
            xsearch <- c("CASE_STATUS","EMPLOYER_NAME","WORKSITE_CITY","WORKSITE_STATE")
            
            # Read csv file if necessary
            if (!exists("oo")){
                #print(paste("READ", csvfile))
                withProgress(message = "Loading data for FY 2015,",
                             detail = "this can take a minute or so...", value = 0, {
                    for (i in 1:10){
                        incProgress(1/10)
                        Sys.sleep(0.5)
                    }
                    oo <- read.csv(csvfile)
                    #incProgress(1/10)
                })
                withProgress(message = "Loading data for FY 2016,",
                             detail = "please wait...", value = 0, {
                    for (i in 1:9){
                        incProgress(1/10)
                        Sys.sleep(0.5)
                    }
                    #print(paste("READ", csvfile2))
                    pp <- read.csv(csvfile2)
                    incProgress(1/10)
                    pp$AGENT_ATTORNEY_NAME <- paste(pp$AGENT_ATTORNEY_FIRST_NAME, pp$AGENT_ATTORNEY_LAST_NAME)
                    pp$WAGE_RATE_OF_PAY <- paste(as.character(pp$WAGE_RATE_OF_PAY_FROM), "-", as.character(pp$WAGE_RATE_OF_PAY_TO))
                    pp$PW_WAGE_LEVEL <- ""
                    colnames(pp)[colnames(pp)=="TOTAL_WORKERS"] <- "TOTAL.WORKERS"
                    colnames(pp)[colnames(pp)=="PW_SOURCE"] <- "PW_WAGE_SOURCE"
                    colnames(pp)[colnames(pp)=="PW_SOURCE_OTHER"] <- "PW_WAGE_SOURCE_OTHER"
                    colnames(pp)[colnames(pp)=="H1B_DEPENDENT"] <- "H.1B_DEPENDENT"
                    colnames(pp)[colnames(pp)=="WILLFUL_VIOLATOR"] <- "WILLFUL.VIOLATOR"
                    qq <- with(pp, data.frame(
                        CASE_NUMBER, CASE_STATUS, CASE_SUBMITTED, DECISION_DATE,
                        VISA_CLASS, EMPLOYMENT_START_DATE, EMPLOYMENT_END_DATE, EMPLOYER_NAME,
                        EMPLOYER_ADDRESS1, EMPLOYER_ADDRESS2, EMPLOYER_CITY, EMPLOYER_STATE,
                        EMPLOYER_POSTAL_CODE, EMPLOYER_COUNTRY, EMPLOYER_PROVINCE, EMPLOYER_PHONE,
                        EMPLOYER_PHONE_EXT, AGENT_ATTORNEY_NAME, AGENT_ATTORNEY_CITY, AGENT_ATTORNEY_STATE,
                        JOB_TITLE, SOC_CODE, SOC_NAME, NAIC_CODE,
                        TOTAL.WORKERS, FULL_TIME_POSITION, PREVAILING_WAGE, PW_UNIT_OF_PAY,
                        PW_WAGE_LEVEL, PW_WAGE_SOURCE, PW_WAGE_SOURCE_YEAR, PW_WAGE_SOURCE_OTHER,
                        WAGE_RATE_OF_PAY, WAGE_UNIT_OF_PAY, H.1B_DEPENDENT, WILLFUL.VIOLATOR,
                        WORKSITE_CITY, WORKSITE_COUNTY, WORKSITE_STATE, WORKSITE_POSTAL_CODE)
                    )
                    oo <<- rbind(oo, qq)
                })
            }
            xx <- oo
            # Make value changes before searches
            levels(xx$CASE_STATUS)[levels(xx$CASE_STATUS)=="CERTIFIED-WITHDRAWN"] <- "CERT-WITHDR"
            lw <- as.character(oo$WAGE_RATE_OF_PAY)
            lw <- sub("([0-9.]+)[ ]*-[ ]*[0-9.]+", "\\1", lw, perl = TRUE)
            lw <- sub("([0-9.]+)[ ]*-[ ]*", "\\1", lw, perl = TRUE)
            xx$LOW_WAGE <- as.numeric(gsub(",", "", lw))
            #xx$LOW_WAGE <- as.numeric(lw)
            #xx$WAGE_PW <- xx$LOW_WAGE / as.numeric(xx$PREVAILING_WAGE)
            xx$WAGE_PW <- xx$LOW_WAGE / as.numeric(gsub(",", "", xx$PREVAILING_WAGE))
            xx$WAGE_PW[xx$PW_UNIT_OF_PAY != xx$WAGE_UNIT_OF_PAY] <- NA
            #xx$WAGE_PW <- format(round(xx$WAGE_PW, 4), nsmall = 4)
            xx$WAGE_PW <- round(xx$WAGE_PW, 4)

            # Do searches
            sfilter <- ""
            for (i in 1:length(xsearch)){
                #pattern <- trimws(input[[xsearch[i]]]) # trim whitespace
                pattern <- input[[xsearch[i]]]
                if (nchar(pattern) > 0){
                    xx <- xx[grep(pattern, xx[[xsearch[i]]], ignore.case = TRUE),]  
                    print(paste0("Search ", xsearch[i], " for ", pattern))
                    sfilter <- paste0(sfilter,", ", xsearch[i], "=", pattern)
                }
            }
            if (nchar(input$ysearch1) > 0){
                xx <- xx[grep(input$ysearch1, xx[[input$xsearch1]], ignore.case = TRUE),]  
                print(paste0("Search ", input$xsearch1, " for ", input$ysearch1))
                sfilter <- paste0(sfilter,", ", input$xsearch1, "=", input$ysearch1)
            }
            if (nchar(input$ysearch2) > 0){
                xx <- xx[grep(input$ysearch2, xx[[input$xsearch2]], ignore.case = TRUE),]  
                print(paste0("Search ", input$xsearch2, " for ", input$ysearch2))
                sfilter <- paste0(sfilter,", ", input$xsearch2, "=", input$ysearch2)
            }
            sfilter <- sub("^, ","",sfilter)
            
            # Sort by specified sort fields
            if (input$xsortdir == "Ascending") xx <- xx[order(xx[[input$xsort]]),]
            else{
                if (class(xx[[input$xsort]])=="factor") xx <- xx[rev(order(xx[[input$xsort]])),]
                else xx <- xx[order(-xx[[input$xsort]]),]
            } 
            print(paste0("Sort by ", input$xsort, ", ", input$xsortdir))
            print("")
            #print("H-1B Disclosure Data FY15 Q4")
            print("H-1B DISCLOSURE DATA, OCT 2014 - DEC 2015")
            if (nchar(sfilter) > 0) print(paste0("(", sfilter,")"))
            print("")
            
            # Output sums and totals
            #print(paste("SUM(TOTAL.WORKERS) =", format(sum(xx$TOTAL.WORKERS), big.mark=",",scientific=FALSE)))
            print(paste("SUM(TOTAL.WORKERS) =", format(sum(xx$TOTAL.WORKERS[!is.na(xx$TOTAL.WORKERS)]), big.mark=",",scientific=FALSE)))
            print(paste("NUMBER OF ROWS     =", format(length(xx$TOTAL.WORKERS), big.mark=",",scientific=FALSE)))
            print(paste("MEDIAN(LOW_WAGE)   =", format(median(xx$LOW_WAGE[!is.na(xx$LOW_WAGE) & xx$WAGE_UNIT_OF_PAY == "Year"]), big.mark=",",scientific=FALSE)))
            print(paste("MEAN(LOW_WAGE)     =", format(round(mean(xx$LOW_WAGE[!is.na(xx$LOW_WAGE) & xx$WAGE_UNIT_OF_PAY == "Year"]), digits=0), big.mark=",",scientific=FALSE)))
            print("")

            # Limit to Maximum Total Rows if necessary
            itotrows <- as.integer(input$totrows)
            if (nrow(xx) > itotrows) xx <- head(xx, n = itotrows)
            
            # Number all rows and set total width to Maximum Total Width
            if (nrow(xx) > 0) row.names(xx) <- 1:nrow(xx)
            options(width = input$totwidth)
            
            # Display only the specified fields
            #xx <- subset(xx, select = input$xshow)
            xx <- subset(xx, select = append(input$xshow, input$xshow2))
            #for (i in 1:length(input$xshow)){
            #  xx[[input$xshow[i]]] <- strtrim(xx[[input$xshow[i]]], width=input$colwidth)
            #}
            if ("EMPLOYER_NAME" %in% colnames(xx)){
                xx$EMPLOYER_NAME <- strtrim(xx$EMPLOYER_NAME, width=input$colwidth)
            }
            if ("JOB_TITLE" %in% colnames(xx)){
                xx$JOB_TITLE     <- strtrim(xx$JOB_TITLE, width=input$colwidth)
            }
            if ("SOC_NAME" %in% colnames(xx)){
                xx$SOC_NAME      <- strtrim(xx$SOC_NAME, width=input$colwidth)
            }
            #xx$WORKSITE_CITY <- strtrim(xx$WORKSITE_CITY, width=input$colwidth)
            colnames(xx)[colnames(xx)=="EMPLOYMENT_START_DATE"] <- "EMP_START_DATE"
            colnames(xx)[colnames(xx)=="TOTAL.WORKERS"] <- "WORKERS"
            colnames(xx)[colnames(xx)=="WORKSITE_STATE"] <- "STATE"
            print(xx)
        })
    }
)
