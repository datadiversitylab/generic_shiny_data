library(shiny)
library(shinyjs)
library(leaflet)
library(DT)
library(bslib)
library(shinyWidgets)
library(DBI)
library(RSQLite)

# UI
ui <- 
  navbarPage(
    id = "tabs",
    theme = bs_theme(bootswatch = "cosmo",
                     primary = "#4CAF50",
                     secondary = "#555555",
                     base_font = font_google("Roboto")  # Use a modern Google font
                     ),
    div(
      tags$img(src = "DDL logo_white.png", style = "height: 40px; margin-right: 10px;"),
      style = "font-size: 24px; font-weight: bold; padding: 0 20px;",
      "The Animal Culture Database"
    ),    
    header = tags$style(
      HTML("
      .navbar-nav {
        margin: 0 auto;
        display: flex;
        justify-content: center;
      }
      .navbar-nav > li > a {
        font-size: 16px;
        font-weight: 500;
        padding: 15px 20px;
      }
    ")
    ),
    # Landing page
    tabPanel(
      tags$div(icon("home"), "Home"),
      fluidPage(
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 40px 20px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          tags$div(
            style = "background-color: #f9f9f9; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            
            # Title and subtitle
            tags$h1(
              style = "font-size: 48px; font-weight: 300; text-align: center; color: #4CAF50; margin-bottom: 20px;",
              "Animal Culture Database (ACDB)"
            ),
            tags$h2(
              style = "font-size: 24px; font-weight: 300; text-align: center; color: #555555; margin-bottom: 40px;",
              "Exploring the World’s Diversity of Nonhuman Animal Traditions"
            ),
            
            # Introduction text
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "Welcome to the Animal Culture Database, a resource designed to bring together and highlight the richness of socially transmitted behaviors in nonhuman animal populations. In this database, we’ve consolidated data on XXX, and other cultural traditions—all for YY species in one central place."
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "Through our interactive platform, you will be able to explore how species and populations around the globe navigate their environments, share knowledge, and respond to changes. Our goal is to make it easier to spot patterns in cultural diversity, identify gaps in current understanding, and ultimately inform conservation efforts that account for these dynamic, learned behaviors."
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "We invite researchers, conservationists, educators, and the public to use the database, discover hidden connections, and contribute with new observations."
            ),
            tags$div(
              style = "text-align: center;",
              actionButton(inputId = "explore_button", 
                           label = "Explore the Database",
                           style = "display:inline-block; padding: 15px 30px; border-radius: 5px; background: #4CAF50; color: #ffffff; text-decoration: none; font-size: 18px; font-weight: 400; transition: background 0.3s ease;")
              
            )
          ),
          
          # Quick Stats Section
          tags$div(
            style = "margin-top: 40px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h3(
              style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center; margin-bottom: 20px;",
              "Quick Stats"
            ),
            tags$div(
              style = "display: flex; justify-content: space-around; text-align: center;",
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", "120+"),
                tags$p(style = "font-size: 16px; color: #555;", "Species covered")
              ),
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", "200+"),
                tags$p(style = "font-size: 16px; color: #555;", "Behaviors documented")
              ),
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", "50+"),
                tags$p(style = "font-size: 16px; color: #555;", "Populations cataloged")
              )
            )
          )
        )
      )
    )
    ,
    
    # Populations page
    tabPanel(
      value = "Populations_tab",
      tags$div(icon("globe"), "Populations"),
      fluidPage(
        titlePanel("Populations"),
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 20px 0; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          tags$div(
            style = "background-color: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            
            # Introduction section
            tags$h3(
              style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center; margin-bottom: 20px;",
              "Explore population-level data"
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "This section allows you to explore population-level details drawn from the Animal Culture Database. Each population entry here reflects a group of individuals within a species that share specific sets of behaviors. Taken together, these data help highlight how cultural practices play out within and across distinct environments."
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "Below, you’ll find an interactive map and a searchable table. The map is your starting point: navigate through various regions, click on a marker of interest, and get a quick snapshot of the behaviors documented there. The table provides a more in-depth look, featuring species names, descriptions of cultural traits, and notes on how these traditions are transmitted among individuals."
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 0;",
              "Selecting a specific population in the table will result in additional context on particular behaviors."
            )
          )
        ),
        
        # Map and Table Section
        tags$div(
          style = "max-width: 1100px; margin: 40px auto;",
          
          # Map with a shadow effect
          tags$div(
            style = "background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); margin-bottom: 40px;",
            tags$h4(
              style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 15px;",
              "Interactive Map"
            ),
            tags$p(
              style = "margin-bottom: 10px;",
              "Use the map below to explore regions and populations of interest."
            ),
            leafletOutput("population_map", height = 400)
            
          ),
          
          # Table with a shadow effect
          tags$div(
            style = "background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h4(
              style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 15px;",
              "Population Data Table"
            ),
            tags$p(
              style = "margin-bottom: 10px;",
              "Search or filter the table below for detailed population information."
            ),
            dataTableOutput("groups_table")
          )
        )
      )
    ),
    
    tabPanel(tags$div(icon("question-circle"), "Help")),
    
    
  )


server <- function(input, output, session) {
  # Connect to SQLite database
  db_path <- "db/animal_culture_db.sqlite"  # Ensure the database file is in your working directory
  conn <- dbConnect(RSQLite::SQLite(), dbname = db_path)
  
  # Read tables from the SQLite database
  groups_table <- dbReadTable(conn, "groups_table")
  species_table <- dbReadTable(conn, "species_table")
  behaviors_table <- dbReadTable(conn, "behaviors_table")
  sources_table <- dbReadTable(conn, "sources_table")
  
  
  # Ensure the connection is closed when the session ends
  on.exit(dbDisconnect(conn))
  
  # Navigate to Populations tab when button is clicked
  observeEvent(input$explore_button, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "Populations_tab")
  })
  
  # Render leaflet map
  output$population_map <- renderLeaflet({
    leaflet(data = groups_table) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~long, lat = ~lat,
        popup = ~paste("<b>Group:</b>", group_name, "<br>",
                       "<b>Location Evidence:</b>", location_evidence)
      )
  })
  
  
  # Render the main population table
  output$groups_table <- renderDataTable({
    datatable(
      groups_table[, c("group_name", "lat", "long", "location_evidence")],
      selection = "single",
      options = list(pageLength = 5)
    )
  })
  

  
  # Observe row selection to trigger the modal
  # Observe row selection to trigger the modal
  observeEvent(input$groups_table_rows_selected, {
    selected_id <- groups_table$group_id[input$groups_table_rows_selected]
    
    # Filter relevant data
    selected_species <- species_table[species_table$species_id == groups_table$species_id[groups_table$group_id == selected_id], ]
    selected_behaviors <- behaviors_table[behaviors_table$group_id == selected_id, ]
    selected_references <- sources_table[sources_table$behavior_id %in% selected_behaviors$behavior_id, ]
    selected_group <- groups_table[groups_table$group_id == selected_id, ]
    
    # Show modal with behavior details as text
    showModal(modalDialog(
      title = div(
        style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center;",
        paste("Details for", selected_group$group_name)
      ),
      div(
        style = "background-color: #f9f9f9; padding: 20px;",
        # Species Details
        tags$h3("Species Details"),
        tableOutput("species_details_text")
      ),
      div(
        style = "background-color: #ffffff; padding: 20px;",
        # Behavior Details
        tags$h3("Behavior Details"),
        uiOutput("behavior_details_text")  # Placeholder for behavior details as text
      ),
      div(
        style = "background-color: #ffffff; padding: 20px;",
        # References Section
        tags$h3("References"),
        uiOutput("references_text")  # Placeholder for references as text
      ),
      div(
        style = "background-color: #f9f9f9; padding: 20px;",
        # Group Location Map
        tags$h3("Group Location Map"),
        leafletOutput("modal_map", height = 400)
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
    
    # Render species details as a single paragraph with column names boldfaced
    output$species_details_text <- renderUI({
      tagList(
        lapply(seq_len(nrow(selected_species)), function(i) {
          species <- selected_species[i, ]
          tags$p(
            HTML(
              paste(
                sapply(names(species), function(col_name) {
                  paste0("<b>", col_name, ":</b> ", as.character(species[[col_name]]))
                }),
                collapse = "; "
              )
            )
          )
        })
      )
    })
    
    
    # Render behavior details as text paragraphs, each column boldfaced
    output$behavior_details_text <- renderUI({
      tagList(
        lapply(seq_len(nrow(selected_behaviors)), function(i) {
          behavior <- selected_behaviors[i, ]
          tagList(
            lapply(names(behavior), function(col_name) {
              tags$p(
                tags$b(paste0(col_name, ": ")),
                as.character(behavior[[col_name]])
              )
            })
          )
        })
      )
    })
    
    
    # Render references grouped by behavior
    output$references_text <- renderUI({
      references_by_behavior <- split(selected_references$reference_text, selected_references$behavior_id)
      tagList(
        lapply(names(references_by_behavior), function(behavior_id) {
          tagList(
            tags$h4(paste("References for Behavior:", behavior_id)),
            tags$ul(
              lapply(references_by_behavior[[behavior_id]], function(ref) {
                tags$li(ref)
              })
            )
          )
        })
      )
    })
    
    # Render map in modal
    output$modal_map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        addMarkers(
          lng = selected_group$long,
          lat = selected_group$lat,
          popup = paste0(
            "<b>Group:</b> ", selected_group$group_name, "<br>",
            "<b>Location Evidence:</b> ", selected_group$location_evidence
          )
        ) %>%
        setView(lng = selected_group$long, lat = selected_group$lat, zoom = 12)
    })
  })
  
}





# Run the Shiny app
shinyApp(ui, server)
