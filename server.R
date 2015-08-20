
library(shiny)
library(plotly)

shinyServer(function(input, output) {
    
    # predicted value of circumference
    growth <- reactive({ predict(fit, list(age = input$ageInput)) })
    
    output$trendPlot <- renderPlotly({
        # update plot markers
        age.in <- input$ageInput
        p %>% add_trace(y = c(0, growth(), 250), x = rep(age.in, 3), showlegend = F,
                        line = list(color = "black", width = 2, dash = "solid"))
    })
    
    output$predictedValue <- renderText({
        paste0(round(growth()), "mm")
    })
})

# fit using nls model
fit <- nls(circumference ~ SSlogis(age, Asym, xmid, scale), data = Orange)

# create plotly plot
age.pred <- seq(20, max(1600), len = 100)
p <- plot_ly(x = age, y = circumference, data = Orange, group = Tree,
             line = list(width = 1, opacity = 0.8)) %>%
    layout(title = "Orange tree data and fitted model. (Trunk circumference of 5 trees measured at 7 different ages)",
           xaxis = list(title = "Age (days)"),
           yaxis = list(title = "Circumference (mm)")) %>% 
    add_trace(y = predict(fit, list(age = unique(age.pred))), x = age.pred,
              group = "fitted",
              line = list(shape = "spline", width = 3, dash = "solid"))

