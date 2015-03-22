library(shiny)

# Define UI for application that predicts child height for the given 
# father or mother height 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Child Height Prediction from Father or Mother Heights"),
  
  # Sidebar with a slider input for parent heights
  sidebarPanel(
    helpText("This is a simple shiny app that predicts",
             "a child's height from their parent's height.",
             "It uses a Pearson and Lees data on the heights",
             "of parents and children classified by gender.",
             "The dataset can be found in the HisData package.",
             "The app uses a linear prediction to predict a",
             "son or daughter's height for the given father or",
             "mother's height.",
             " ",
             "Slide Parent Height and view how these changes",
             "are reflected on the chart."),             
    
    selectInput("par", "Select Parent:",
                c("Father",
                  "Mother")),
    
    selectInput("chl", "Select Child:",
                c("Son",
                  "Daughter")),
                  
    sliderInput("parentHeight", 
                "Parent Height:", 
                min = 58,
                max = 75, 
                value = 67)
  ),
  
  # predict a child height from the parent height
  mainPanel(
    plotOutput("pcPlot")
  )
))