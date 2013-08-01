require(shiny)
require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel('rCharts Dimple plot Builder'),
  sidebarPanel(
    selectInput('dataset', 'Choose DataSet',
                data()$results[,3]         
    ),
    selectInput('chartType', 'Type of Chart',
                c('line','bubble','bar')),
    selectInput('xType', 'Type of x Axis',
                c('addCategoryAxis','addMeasureAxis'), selected = NULL),
    selectInput('yType', 'Type of y Axis',
                c('addMeasureAxis','addCategoryAxis'), selected = NULL),
    uiOutput('variableControls')           
  ),
  mainPanel(
    chartOutput('mychart', 'dimple') 
  )
))