###################
# app.R
# 
# Main controller. 
# Used to import your ui and server components; initializes the app.
###################

library(shiny)
library(shinyjs)
library(DT)
library(bslib)
library(shinyWidgets)
library(DBI)
library(RSQLite)
library(here)
#Load components
source('ui.R')
source('server.R')

# Run the Shiny app
shinyApp(ui, server)
