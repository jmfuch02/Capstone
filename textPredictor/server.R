library(shiny)

# Load corpus, tdms, etc. here

load(".RData")
source("cleanDeployShiny.R")

shinyServer(function(input, output) {
    
    output$predictedWord <- renderText({
        
        predictNextWord(input$textString)
        
    })
    
})