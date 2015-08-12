library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Text Predictor"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(width = 4,
            textInput("textString", label = "Enter some text"),
            submitButton("Predict")
            ),
        
        
        # Show a plot of the generated distribution
        mainPanel("Main panel")
    )
))