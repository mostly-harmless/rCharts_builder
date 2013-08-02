require(rCharts)
require(shiny)
require(reshape2)
require(xts)

convertDecimalDate <- function(x) {
  #https://stat.ethz.ch/pipermail/r-help/2007-August/138171.html
  # get the year and then determine the number of seconds in the year so you can
  # use the decimal part of the year
  x.year <- floor(x)
  # fraction of the year
  x.frac <- x - x.year
  # number of seconds in each year
  x.sec.yr <- unclass(ISOdate(x.year+1,1,1,0,0,0)) - unclass(ISOdate(x.year,1,1,0,0,0))
  # now get the actual time
  x.actual <- ISOdate(x.year,1,1,0,0,0) + x.frac * x.sec.yr
  as.Date(x.actual)
}


shinyServer(function(input, output, session){
  # convert the data into a format that the libraries like
  # we will have to make some assumptions here  
  #plotdata <- data.frame()
  
  mydata <- function(dataset) {
    if(exists(eval(dataset))){
      dataUse <- get(dataset)
    } else dataUse = data.frame()
    if( is.list(dataUse) || is.table(dataUse) ){
      dataUse <- data.frame(dataUse)
      return(dataUse)
    } else if (xtsible(dataUse) || is.ts(dataUse)){
      if (xtsible(dataUse)) {
        dataUse.df <- as.xts(dataUse)
      } else {
        dataUse.df <- as.xts(
          coredata(dataUse),
          order.by = as.Date(sapply(index(dataUse), FUN=convertDecimalDate))
        )
      }
      dataUse.df <- data.frame(
        index(dataUse.df),
        coredata(dataUse.df),
        stringsAsFactors = FALSE
      )
      if (!is.null(colnames(dataUse))) {
        colnames(dataUse.df) <- c("date",colnames(dataUse.df)[-1])
      } else {
        colnames(dataUse.df) <- c("date", input$dataset)
      }
      dataUse.df$date <- format(as.Date(dataUse.df$date))
      dataUse.df <- melt(dataUse.df, id.vars = 1)
      colnames(dataUse.df) <- c("date","Name","Value")
      return(dataUse.df)
    } else {
      return(dataUse)
    }    
  }
  
    observe({
      input$dataset  # Do take a dependency on input$dataset

      plotdata = mydata(input$dataset)
      
      updateSelectInput(
        session,
        "xType",
        label = 'Type of x Axis',
        choices = c('addCategoryAxis','addMeasureAxis', 'addTimeAxis'),
        selected = 1
      )
      
      output$variableControls <- renderUI({
        variables <- colnames(plotdata)
        tagList(     
          tags$script("if ($('#x').data('selleckt')) $('#x').data('selleckt').destroy()"),
          tags$script("if ($('#y').data('selleckt')) $('#y').data('selleckt').destroy()"),
          tags$script("if ($('#groups').data('selleckt')) $('#groups').data('selleckt').destroy()"),                      
          selectInput("x", "Select X", variables, selected = NULL,multiple=TRUE),
          selectInput("y", "Select Y", variables, selected = NULL,multiple=TRUE),
          selectInput("groups", "Select Groups", variables, selected = NULL,multiple=TRUE),
          tags$script("$('#x,#y,#groups').selleckt()")      
        )
      })
      
      print("gotdata")
      print(ls())
      output$mychart <- renderChart2({
        if("x" %in% names(input) && "y" %in% names(input)) {
          if (!(is.null(input$x)) && !(is.null(input$y))) {
            print('drawingchart')
            d1 <- dPlot(
              y=input$y,
              x=input$x,
              groups = input$groups,
              data = plotdata,
              type=input$chartType
            )
            if(input$xType == "addTimeAxis") {
              d1$xAxis(type = input$xType, inputFormat = "%Y-%m-%d", outputFormat = "%Y")
            } else d1$xAxis(type = input$xType)
            if(input$yType == "addTimeAxis") {
              d1$yAxis(type = input$xType, inputFormat = "%Y-%m-%d", outputFormat = "%Y")
            } else d1$yAxis(type = input$yType)
            d1$legend(x = 60, y = 10, width = 700, height = 20, horizontalAlign = "right")
            d1
          }
        }
      })
    })  
})