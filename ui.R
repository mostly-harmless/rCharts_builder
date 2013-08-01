require(shiny)
require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel('DataTables in Shiny with rCharts'),
  sidebarPanel(
    selectInput('dataset', 'Choose DataSet',
                c('mtcars', 'iris', 'faithful')            
    ),
    selectInput('pagination', 'Choose Pagination',
                c('two_button', 'full_numbers')            
    )
  ),
  mainPanel(
    chartOutput('mychart', 'dimple') 
  )
))