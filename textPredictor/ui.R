library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Text Predictor"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(width = 7,
            textInput("textString", label = "Enter some text"),
            submitButton("Predict")
            ),
        
        
        # Show a plot of the generated distribution
        mainPanel(width = 5,
                h4("The most likely next word is"),
                textOutput("predictedWord")
            )
    )
))