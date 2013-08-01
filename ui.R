require(shiny)
require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel('DataTables in Shiny with rCharts'),
  sidebarPanel(
    selectInput('dataset', 'Choose DataSet',
                c('haireye', 'mtcars', 'iris', 'faithful')            
    ),
    selectInput('chartType', 'Type of Chart',
                c('line','bubble','bar')),
    selectInput('xType', 'Type of x Axis',
                c('addCategoryAxis','addMeasureAxis')),
    selectInput('yType', 'Type of y Axis',
                c('addMeasureAxis','addCategoryAxis')),
    uiOutput('variableControls')           
  ),
  mainPanel(
    chartOutput('mychart', 'dimple') 
  )
))