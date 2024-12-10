
library(shiny)
library(shinythemes)

ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  "My First App",
                  tabPanel("Navbar 1",
                           sidebarPanel(
                             tags$h3("Input"),
                             textInput("txt1","Enter first name",""),
                             textInput("txt2","Enter last name",""),
                             
                           ),
                           mainPanel(
                             h1("Header 1"),
                             h4("Output 1"),
                             verbatimTextOutput("txtout"),
                           )),
                  tabPanel("Navbar 2",
                           sidebarPanel(
                             tags$h3("Input"),
                             textInput("txt1","How old are you",""),
                             textInput("txt2","What is your level of education",""),
                           ),
                           mainPanel(
                             h1("Header 1"),
                             h4("Output 1"),
                             verbatimTextOutput("txtout"),
                           )),
                  tabPanel("Navbar 3", "This panel is intentionally left blank")
                ))

server <- function(input,output){
  output$txtout <- renderText({
    paste( input$txt1, input$txt2, sep = " " )
  })
  
}

shinyApp(ui = ui, server = server)


