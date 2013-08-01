require(rCharts)
require(shiny)
require(data.table)

shinyServer(function(input, output, session){
  mydata <- reactive({
    switch(input$dataset, mtcars = mtcars, iris = iris,
           faithful = data.table(faithful)
    )
  })
  output$mychart <- renderChart2({
    plotdata <- subset(data.frame(HairEyeColor),Sex=="Female")
    d1 <- dPlot(Freq~Hair, groups = "Eye", data = plotdata, type="bar")
    d1$yAxis( type = "addPctAxis" )
    d1$legend(x = 60, y = 10, width = 700, height = 20, horizontalAlign = "right")
    d1
  })
})