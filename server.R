require(rCharts)
require(shiny)
require(data.table)

shinyServer(function(input, output, session){
  mydata <- reactive({
    get(input$dataset)
  })
  
  output$variableControls <- renderUI({
    variables <- colnames(mydata())
    tagList(
      checkboxGroupInput("x", "Select X", variables),
      checkboxGroupInput("y", "Select Y", variables)  
    )
  })
  
  output$mychart <- renderChart2({
    if("x" %in% names(input) && "y" %in% names(input)) {
      if (!(is.null(input$x)) && !(is.null(input$y))) {
        plotdata <- mydata()
        d1 <- dPlot(
          y=input$y,
          x=input$x,
          data = plotdata,
          type=input$chartType
        )
        if("xType" %in% names(input) && !is.null(input$xType)) {
          d1$xAxis(type = input$xType)
        }
        if("yType" %in% names(input) && !is.null(input$yType)) {
          d1$yAxis(type = input$yType)
        }
        d1$legend(x = 60, y = 10, width = 700, height = 20, horizontalAlign = "right")
        d1
      }
    }
  })
  
})