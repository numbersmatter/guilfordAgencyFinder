library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    dashboardHeader(title = "Agency Finder"),
    
    
    dashboardSidebar(
        selectInput("type", "Choose Service Type:", choices = resourceInventory$Type, multiple = TRUE),
        selectInput("location", "Select Service Location:", choices = c("All Locations"=''), multiple = TRUE),
        selectInput("program", "Select Programs:", choices = c("All Programs"=''), multiple = TRUE)
    ),
    
    
    dashboardBody(
        DT::dataTableOutput("resourceTable"),
        hr(),
        leafletOutput("map", width= 600, height = 400)
    )
)
