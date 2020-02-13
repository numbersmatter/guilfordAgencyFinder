library(shiny)
library(dplyr)
library(shinydashboard)
library(readr)
library(httr)
library(jsonlite)
library(leaflet)


config<- config::get(file = "config/config.yml")



dwtoken <- paste("Bearer ", config$dw_token, sep = "")


dw <- httr::GET("https://api.data.world/v0/queries/4c8d3c10-07d9-4788-921b-e4b9020cda50/results", 
                add_headers(
                  accept= "text/csv",
                  authorization = dwtoken
                ))

content_raw <-content(dw, as = 'text')

resourceInventory <- fromJSON(content_raw)

resourceInventory <- resourceInventory %>%
  rename("Type" = type,
         "Location" = location,
         "Program" = program,
         "Street"  = street,
         "City"    = city
  )