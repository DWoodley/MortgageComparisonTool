library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
  # Application title
    titlePanel("Mortgage Comparison Tool"),
  
    # Sidebar with a slider inputs for mortgage parameters
    sidebarLayout(

        sidebarPanel(
            sliderInput(inputId = "face",
                        label = "Mortgage Face Amount ($ 000s)",
                        min = 100,
                        max = 400,
                        value = 100,
                        step = 2),
            
            sliderInput(inputId = "rate1",
                   label = "Mortgage 1 Interest Rate",
                   min = 3,
                   max = 12,
                   value = 3.875,
                   step = 0.125),
       
            sliderInput(inputId = "term1",
                   label = "Mortgage 1 Term to Maturity (Months)",
                   min = 180,
                   max = 360,
                   value = 360,
                   step = 60),

            sliderInput(inputId = "rate2",
                    label = "Mortgage 2 Interest Rate",
                    min = 3,
                    max = 12,
                    value = 3.625,
                    step = 0.125),
        
            sliderInput(inputId = "term2",
                    label = "Mortgage 2 Term to Maturity (Months)",
                    min = 180,
                    max = 360,
                    value = 240,
                    step = 60)
        ),
    
        mainPanel(
            plotOutput("MortgagePlot")
        )
        
    ),
    helpText("The Mortgage Comparison Tool allows side by side comparision
             of pairs of conventional U.S. mortgages."), 
    helpText(""),         
    helpText("Sliders inputs:"),  
    helpText("1. Mortgage Face Amount: Selects the beginning balances for both mortgages between 100 to 400"),  
    helpText("2. Mortgage 1 Interest Rate: Selects first mortgage rate between 3% to 12%"), 
    helpText("3. Mortgage 1 Term to Maturity: Selects first mortgage stated maturity between 180 to 360 months"),  
    helpText("4. Mortgage 2 Interest Rate: Selects second mortgage rate between 3% to 12%"),  
    helpText("5. Mortgage 2 Term to Maturity: Selects second mortgage stated maturity between 180 to 360 months")
))