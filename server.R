###################
# server.R
# 
# Server controller. 
# Used to define the back-end aspects of the app.
###################


server <- function(input, output, session) {
  # Connect to SQLite database
  db_path <- "db/animal_culture_db.sqlite"
  conn <- dbConnect(RSQLite::SQLite(), dbname = db_path)
  
  # Read tables from the SQLite database
  groups_table <- dbReadTable(conn, "groups_table")
  species_table <- dbReadTable(conn, "species_table")
  behaviors_table <- dbReadTable(conn, "behaviors_table")
  sources_table <- dbReadTable(conn, "sources_table")
  
  # Ensures that the connection is closed when the session ends
  on.exit(dbDisconnect(conn))
  
  # Compute stats for the UI
  species_count <- length(unique(species_table$species_id))
  behavior_count <- nrow(behaviors_table)
  population_count <- nrow(groups_table)
  
  # Send stats to the UI
  output$species_count <- renderText({ paste0(species_count, "+") })
  output$behavior_count <- renderText({ paste0(behavior_count, "+") })
  output$population_count <- renderText({ paste0(population_count, "+") })
  
  # Navigate to Populations tab when button in landing page is clicked
  observeEvent(input$explore_button, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "Populations_tab")
  })
  
  # Render leaflet map
  # Calculate the number of recorded behaviors per group
  behavior_counts <- aggregate(behavior_id ~ group_id, data = behaviors_table, FUN = length)
  colnames(behavior_counts)[2] <- "behavior_count"  # Rename column for clarity
  
  # Join groups_table with species_table to get species and common names
  groups_with_species <- merge(groups_table, species_table, by.x = "species_id", by.y = "species_id", all.x = TRUE)
  
  # Join the behavior counts with the group data
  groups_with_species <- merge(groups_with_species, behavior_counts, by.x = "group_id", by.y = "group_id", all.x = TRUE)
  
  # Replace NA behavior counts with 0 (for groups with no behaviors)
  groups_with_species$behavior_count[is.na(groups_with_species$behavior_count)] <- 0
  
  # Render leaflet map
  output$population_map <- renderLeaflet({
    leaflet(data = groups_with_details) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%  # Light-themed tiles
      addCircleMarkers(
        lng = ~long, lat = ~lat,
        radius = 6,  # Marker size
        color = "#4CAF50",  # Outline color
        fillColor = "#2E7D32",  # Fill color
        fillOpacity = 0.8,  # Transparency
        weight = 2,  # Border weight
        label = ~paste0(group_name, " (", behavior_count, " behaviors)"),  # Quick hover label
        popup = ~paste0(
          "<div style='font-family: Arial, sans-serif; font-size: 14px; line-height: 1.6; color: #333;'>",
          "<b style='font-size: 16px; color: #4CAF50;'>", group_name, "</b><br>",
          "<b>Species:</b> ", canonicalName, "<br>",
          "<b>Common Name:</b> ", common_name, "<br>",
          "<b>Recorded Behaviors:</b> ", behavior_count, "<br>",
          "<b>Location Evidence:</b> ", location_evidence, "<br>",
          "<a href='#' style='color: #2E7D32; text-decoration: underline;' ",
          "onclick='Shiny.setInputValue(\"map_click\", \"", group_id, "\", {priority: \"event\"}); return false;'>More...</a>",
          "</div>"
        )
        , clusterOptions = markerClusterOptions()
      )
  })
  
  #Include counts per group in the table
  # Join groups_table with species_table to get species and common names
  groups_with_details <- merge(groups_table, species_table, by.x = "species_id", by.y = "species_id", all.x = TRUE)
  
  # Join the behavior counts with the group data
  groups_with_details <- merge(groups_with_details, behavior_counts, by.x = "group_id", by.y = "group_id", all.x = TRUE)
  
  # Replace NA behavior counts with 0 (for groups with no behaviors)
  groups_with_details$behavior_count[is.na(groups_with_details$behavior_count)] <- 0
  
  # Render the main population table
  output$groups_table <- renderDataTable({
    datatable(
      groups_with_details[, c("group_name", "canonicalName", "common_name", "behavior_count", "lat", "long", "location_evidence")],
      colnames = c("Group Name", "Species Name", "Common Name", "Number of Behaviors", "Latitude", "Longitude", "Location Evidence"),
      selection = "single",
      options = list(pageLength = 10),
      extensions = 'Buttons'
    )
  })
  
  # Function to display modal based on selected group_id
  showGroupModal <- function(selected_id) {
    # Filter relevant data
    species_id <- groups_table$species_id[groups_table$group_id == selected_id]
    selected_species <- species_table[species_table$species_id == species_id, ]
    selected_behaviors <- behaviors_table[behaviors_table$group_id == selected_id, ]
    selected_references <- sources_table[sources_table$behavior_id %in% selected_behaviors$behavior_id, ]
    selected_group <- groups_table[groups_table$group_id == selected_id, ]
    
    # Show modal with tabs
    showModal(modalDialog(
      size = "xl",
      title = div(style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center;",
                  paste("Details for", selected_group$group_name)),
      div(
        style = "background-color: #f9f9f9; padding: 20px;",
        tabsetPanel(
          id = "modal_tabs",
          type = "tabs",
          tabPanel("Taxonomic Information", uiOutput("species_details_text")),
          tabPanel("Behavior Details", uiOutput("behavior_details_text")),
          tabPanel("Location Map", leafletOutput("modal_map", height = 400))
        )
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
    
    # Render species details
    output$species_details_text <- renderUI({
      tagList(
        tags$div(
          style = "margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #ffffff;",
          lapply(seq_len(nrow(selected_species)), function(i) {
            species <- selected_species[i, ]
            tags$p(
              HTML(
                paste(
                  sapply(names(species), function(col_name) {
                    paste0("<b>", col_name, ":</b> ", as.character(species[[col_name]]))
                  }),
                  collapse = "<br>"
                )
              )
            )
          })
        )
      )
    })
    
    # Render behavior details
    output$behavior_details_text <- renderUI({
      tagList(
        lapply(seq_len(nrow(selected_behaviors)), function(i) {
          behavior <- selected_behaviors[i, ]
          tags$div(
            style = "margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #ffffff;",
            tags$h4(style = "color: #4CAF50; margin-bottom: 10px;", behavior$behavior),
            tagList(
              
              # Link references directly to the description
              lapply(names(behavior), function(col_name) {
                
                # Check if the column name ends with "_source" (as it will be a reference)
                if (grepl("_source$", col_name)) {
                  # Get references associated with the behavior
                  behavior_source <- behavior[[col_name]]
                  
                  if (!behavior_source == "") {
                    source_row <- sources_table[sources_table$source_id == behavior_source, ]
                    
                    if (nrow(source_row) > 0 && !is.na(source_row$doi)) {
                      # Render as a hyperlink if doi exists
                      tags$p(
                        tags$b(paste0(col_name, ": ")),
                        tags$a(
                          href = paste0("https://doi.org/", source_row$doi),
                          target = "_blank",
                          behavior_source
                        )
                      )
                    } else {
                      # Render as plain text if no doi exists
                      tags$p(
                        tags$b(paste0(col_name, ": ")),
                        as.character(behavior_source)
                      )
                    }
                  }
                } else {
                  # Default behavior for non-_source columns
                  tags$p(
                    tags$b(paste0(col_name, ": ")),
                    as.character(behavior[[col_name]])
                  )
                }
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
  }
  
  # Trigger modal via table row selection
  observeEvent(input$groups_table_rows_selected, {
    selected_id <- groups_table$group_id[input$groups_table_rows_selected]
    showGroupModal(selected_id)
  })
  
  # Trigger modal via map marker click
  observeEvent(input$map_click, {
    selected_id <- input$map_click
    showGroupModal(selected_id)
  })
  
}
