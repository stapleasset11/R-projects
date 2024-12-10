#Import libraries

library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

#Read data
weather <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv"))
weather$play <- as.factor(weather$play)
# Readying the model
model <- randomForest(play ~., data = weather, ntree = 500, mtry = 4, importance = TRUE)

#saveRDS(model, "model.rds")
#model <- readRDS("model.rds")


ui <- fluidPage(theme=shinytheme("united"),
                headerPanel("Play Golf."),
                sidebarPanel(
                  HTML("<h3>Input Parameter</h3>"),
                  selectInput("outlook",label="Outlook:",
                              choices = list("Sunny" = "sunny", "Overcast" = "overcast", "Rainy" = "rainy"),
                              selected="Rainy"),
                  sliderInput("temperature", "Temperature:",
                              min = 64, max = 86,
                              value = 70),
                  sliderInput("humidity", "Humidity:",
                              min = 65, max = 96,
                              value = 90),
                  selectInput("windy", label = "Windy:", 
                              choices = list("Yes" = "TRUE", "No" = "FALSE"), 
                              selected = "TRUE"),
                  actionButton("submitbutton", "Submit", class = "btn btn-primary")
                ),
                
                mainPanel(
                  tags$label(h3('Status/Output')), # Status/Output Text Box
                  verbatimTextOutput('contents'),
                  tableOutput('tabledata') # Prediction results table
                  
                )
                )
                
server <- function(input,output,session){
  datasetInput <- reactive ({
    df <- data.frame(
      Name  = c("outlook",
                "temperature",
                "humidity",
                "windy"),
      Value = as.character(c(input$outlook,
                             input$temperature,
                             input$humidity,
                             input$windy)),
      stringsAsFactors = FALSE)
    play <- "play"
    df <- rbind(df, play)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
  })
  
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

shinyApp(ui = ui ,server = server)
