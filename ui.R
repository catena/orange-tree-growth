
library(shiny)
library(plotly)

shinyUI(fluidPage(
    
    headerPanel("Growth of Orange Trees"),
    
    sidebarPanel(
        p("Select the age (in days) of your orange tree, and we shall show you the estimated trunk circumference at breast height."),
        br(),
        sliderInput("ageInput", "Age (days):", min = 10, max = 1600, 
                    value = 100, step = 10),
        br(),
        p("Estimated Trunk Circumference is ", 
          tags$b(textOutput("predictedValue", inline = T)))
    ),
    
    mainPanel(
        plotlyOutput("trendPlot")
    )
))
