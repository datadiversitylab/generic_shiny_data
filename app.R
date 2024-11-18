library(shiny)
library(shinyjs)
library(leaflet)
library(DT)
library(bslib)

# Sample data
population_data <- data.frame(
  name = c("Population A", "Population B", "Population C", "Population D"),
  species = c("Species 1", "Species 2", "Species 3", "Species 4"),
  longitude = c(-110.95, -110.97, -110.92, -110.93),
  latitude = c(32.23, 32.24, 32.25, 32.26),
  behavior = c("Behavior 1", "Behavior 2", "Behavior 3", "Behavior 4"),
  url = c("http://test.com/a", "http://test.com/b", "http://test.com/c", "http://test.com/d")
)

ui <- navbarPage(
  
  theme = bs_theme(bootswatch = "minty"),
  
  title = "The ACDB",
  
  # Landing page
  tabPanel(
    "Landing Page",
    fluidPage(
      titlePanel("Welcome to the Animal Culture Database"),
      fluidRow(
        column(6, h3("Text Placeholder"), p("This is placeholder text for the landing page."))
      )
    )
  ),
  
  # About tab
  tabPanel(
    "About",
    fluidPage(
      titlePanel("About"),
      h3("Text Placeholder"),
      p("This section contains information about the app.")
    )
  ),
  
  # Populations Tab
  tabPanel(
    "Populations",
    fluidPage(
      titlePanel("Populations"),
      
      # Map
      leafletOutput("population_map", height = 400),
      
      # Data table
      h3("Population data"),
      dataTableOutput("population_table")
    )
  )
)

server <- function(input, output, session) {
  
  # Render leaflet map
  output$population_map <- renderLeaflet({
    leaflet(data = population_data) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~longitude, lat = ~latitude,
        popup = ~paste("<b>Name:</b>", name, "<br>",
                       "<b>Species:</b>", species, "<br>",
                       "<b>Behavior:</b>", behavior)
      )
  })
  
  # Render data table
  output$population_table <- renderDataTable({
    datatable(
      population_data[, c("name", "species", "longitude", "latitude", "behavior")],
      options = list(pageLength = 5),
      escape = FALSE,
      rownames = FALSE
    ) %>%
      formatStyle(
        "name",
        cursor = "pointer",
        color = "blue",
        textDecoration = "underline"
      )
  })
  
  # Open link in new tab on row click
  observeEvent(input$population_table_rows_selected, {
    selected_row <- input$population_table_rows_selected
    if (length(selected_row) > 0) {
      selected_url <- population_data$url[selected_row]
      shinyjs::runjs(sprintf("window.open('%s', '_blank')", selected_url))
    }
  })
}

shinyApp(ui, server)
