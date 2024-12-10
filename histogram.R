library(shiny)
library(shinythemes)
data(dataquality)


ui <- fluidPage(
  titlePanel("Ozone Levels"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId  = "bins",
        label = "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      )
    ),
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)


server <- function(input, output) {
  
  
  output$distPlot <- renderPlot({
    
    x    <- airquality$Ozone
    x    <- na.omit(x)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "black",
         xlab = "Ozone level",
         main = "Histogram of Ozone level")
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)