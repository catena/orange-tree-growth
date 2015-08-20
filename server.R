
library(shiny)
library(plotly)

shinyServer(function(input, output) {
    
    growth <- reactive({ predict(fm1, list(age = input$ageInput)) })
    
    output$trendPlot <- renderPlotly({
        age.in <- input$ageInput
        p %>% add_trace(y = c(0, growth(), 250), x = rep(age.in, 3), showlegend = F,
                        line = list(color = "black", width = 2, dash = "solid"))
    })
    
    output$predictedValue <- renderText({
        paste0(round(growth()), "mm")
    })
})

fm1 <- nls(circumference ~ SSlogis(age, Asym, xmid, scale), data = Orange)

age.pred <- seq(20, max(1600), len = 100)
p <- plot_ly(x = age, y = circumference, data = Orange, group = Tree,
             line = list(width = 1, opacity = 0.8)) %>%
    layout(title = "Orange tree data and fitted model",
           xaxis = list(title = "Age (days)"),
           yaxis = list(title = "Circumference (mm)")) %>% 
    add_trace(y = predict(fm1, list(age = unique(age.pred))), x = age.pred,
              group = "fitted",
              line = list(shape = "spline", width = 3, dash = "solid"))

# g <- qplot(age, circumference, data = Orange, geom = c("point", "line"), 
#            color = Tree, xlab = "Age (days)", ylab = "Circumference (mm)",
#            main = "Growth of Orange Trees")
# age <- seq(0, 1600, length.out = 101)
# g <- g + geom_line(aes(x = age, y = predict(fm1, list(age = age))), 
#                    size = 2, color = "#777777")
# g