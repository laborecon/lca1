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
            csvfile <- "H-1B_FY15_Q4.csv"
            xsearch <- c("CASE_STATUS","EMPLOYER_NAME","WORKSITE_CITY","WORKSITE_STATE")
            
            # Read csv file if necessary
            if (!exists("oo")){
                print(paste("READ", csvfile))
                withProgress(message = "Loading file",
                             detail = "this can take a minute or so...", value = 0, {
                                 for (i in 1:10){
                                     incProgress(1/10)
                                     Sys.sleep(0.5)
                                 }
                                 incProgress(1)
                                 oo <<- read.csv(csvfile)
                                 incProgress(1/2)
                             })
            }
            xx <- oo
            # Make value changes before searches
            levels(xx$CASE_STATUS)[levels(xx$CASE_STATUS)=="CERTIFIED-WITHDRAWN"] <- "CERT-WITHDR"
            lw <- as.character(oo$WAGE_RATE_OF_PAY)
            lw <- sub("([0-9.]+)[ ]*-[ ]*[0-9.]+", "\\1", lw, perl = TRUE)
            lw <- sub("([0-9.]+)[ ]*-[ ]*", "\\1", lw, perl = TRUE)
            xx$LOW_WAGE <- as.numeric(lw)
            xx$WAGE_PW <- xx$LOW_WAGE / xx$PREVAILING_WAGE
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
            print("H-1B Disclosure Data FY15 Q4")
            if (nchar(sfilter) > 0) print(paste0("(", sfilter,")"))
            print("")
            
            # Output sums and totals
            #print(paste("SUM(TOTAL.WORKERS) =", format(sum(xx$TOTAL.WORKERS), big.mark=",",scientific=FALSE)))
            print(paste("SUM(TOTAL.WORKERS) =", format(sum(xx$TOTAL.WORKERS[!is.na(xx$TOTAL.WORKERS)]), big.mark=",",scientific=FALSE)))
            print(paste("NUMBER OF ROWS     =", format(length(xx$TOTAL.WORKERS), big.mark=",",scientific=FALSE)))
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
            print(paste0("input$xshow2=", input$xshow2)) # DEBUG
            print(input$xshow2)
            print(length(input$xshow2))
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
