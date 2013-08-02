require(shiny)
require(rCharts)
shinyUI(bootstrapPage(
  tagList(
    tags$head(
      tags$script(src = 'js/jquery-ui.min.js'),
      tags$script(src = 'js/mustache.js'),
      tags$script(src = 'js/underscore.js'),
      tags$script(src = 'js/selleckt.js'),
      tags$link(rel = 'stylesheet', href ='css/selleckt.css')
    ),
    headerPanel('rCharts Dimple plot Builder')
  ),
  sidebarPanel(
    selectInput('dataset', 'Choose DataSet',
      c(objects(1),data()$results[,3])
    ),
    checkboxInput(
      'uploadyes', 'Upload Dataset'
    ),
    conditionalPanel(
      condition = "input.uploadyes == '1'",
      fileInput('datafile', 'Choose CSV File',
                accept=c('text/csv', 'text/comma-separated-values,text/plain'))
    ),
    selectInput('chartType', 'Type of Chart',
      c('line','area','bubble','bar')),
    selectInput('xType', 'Type of x Axis',
      c('addCategoryAxis','addMeasureAxis', 'addTimeAxis')),
    selectInput('yType', 'Type of y Axis',
      c('addMeasureAxis','addCategoryAxis')),
    uiOutput('variableControls')           
  ),
  mainPanel(
    chartOutput('mychart', 'dimple') 
  )
))