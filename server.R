#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

server <- function(input, output, session) {
    
    observe({
        locations <- if (is.null(input$type)) character(0) else{
            filter(resourceInventory, Type %in% input$type) %>%
                `$`('Location')%>%
                unique()
        }
        stillSelected <- isolate(input$location[input$location %in% locations])
        updateSelectizeInput(session, "location", choices = locations,
                             selected = stillSelected, server = TRUE)
    })
    
    observe({
        programs <- if (is.null(input$type)) character(0) else {
            resourceInventory %>%
                filter(Type %in% input$type,
                       is.null(input$location) | Location %in% input$location) %>%
                `$`('Program') %>%
                unique()
        }
        stillSelected <- isolate(input$program[input$program %in% programs])
        updateSelectizeInput(session, "program", choices = programs,
                             selected = stillSelected, server = TRUE)
    })
    
    output$resourceTable <- DT::renderDataTable({
        df <- resourceInventory[!is.na(resourceInventory$City),] %>%
            filter(
                is.null(input$type) | Type %in% input$type,
                is.null(input$location)     | Location %in% input$location,
                is.null(input$program)     | Program %in% input$program
            )
        action <- DT::dataTableAjax(session, df, outputId = "resourceTable")
        
        DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
    })
    
    output$map <- renderLeaflet({
        df <- resourceInventory[resourceInventory$City!= "NA",] %>%
            filter(
                is.null(input$type) | Type %in% input$type,
                is.null(input$location)     | Location %in% input$location,
                is.null(input$program)     | Program %in% input$program
            )
        
        leaflet() %>%
            addTiles() %>%
            addMarkers(data = df, lng = ~lon, lat = ~lat, 
                       popup = ~paste(Program, "<br>", "Address:", Street, ", ", City, sep = "" )) 
        
    })
    
    
}
