library(shiny)
library(ggplot2)
library(HistData)

# Define server logic required to generate and plot a linear regression line with predicted 
# child height for the given parent height
shinyServer(function(input, output) {
  
  # Expression that generates a parent-child heights scatterplot with regression line
  # and predicted child height for the given parent height. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  
  pc.data <- reactive({
    PearsonLee[PearsonLee$par==input$par & PearsonLee$chl==input$chl,]
  })
  
  pc.plot <- reactive({
    ggplot(pc.data(), aes(x=parent, y=child, weight=frequency)) +
    geom_point(shape=1, size = 3, alpha = 0.3, position = position_jitter(width = 0.2)) +    # Use hollow circles
    geom_smooth(method=lm, aes(x=parent, y=child, weight=frequency)) +  # Add linear regression line 
    xlab(input$par) +
    ylab(input$chl)
  })
  
  childheight <- reactive({
    childheight.lm = lm(child ~ parent, data=pc.data(), weights=frequency)
    predict(childheight.lm, newdata = data.frame(parent=input$parentHeight), interval="confidence")
  })
  
  
#  .e <- environment()
  output$pcPlot <- renderPlot({
    
    ph <- input$parentHeight
    ch <- childheight()[1,"fit"]
    
    pc.plot() + 
      #theme(axis.ticks = element_blank(), axis.text = element_blank()) +
      geom_vline(xintercept = ph, linetype="dashed", color = "red") +
      geom_hline(yintercept = ch, linetype="dashed", color = "red") +
#      geom_text(aes(0,ph,label = print(ph), vjust = -1), environment = .e) +
#      scale_y_continuous(breaks = NULL) +
#      scale_x_continuous(breaks = NULL)
      scale_y_continuous(breaks = sort(c(seq(min(pc.data()$child), max(pc.data()$child), length.out=6), round(childheight()[1,"fit"], digits=1)))) +
      scale_x_continuous(breaks = sort(c(seq(min(pc.data()$parent), max(pc.data()$parent), length.out=6), input$parentHeight)))
  })
})
  
