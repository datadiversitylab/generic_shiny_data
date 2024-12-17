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
      .navbar { position: sticky; top: 0; z-index: 1020; }
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
              " In hac habitasse platea dictumst. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam luctus, ipsum quis posuere aliquam, justo felis eleifend arcu, quis vehicula ligula diam in massa. Sed sed nisl et tellus iaculis vulputate at eget quam. Duis sed tortor tellus. Aenean lacus neque, congue sit amet ligula id, condimentum accumsan justo. Nunc eu cursus massa, in dictum orci. Phasellus a erat in dui consectetur dapibus. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus feugiat justo, non efficitur augue fringilla id. Donec at elit blandit, faucibus nisi eu, posuere turpis. Aenean dapibus odio eu diam euismod, vel interdum elit pulvinar. Vivamus at lorem a neque hendrerit sollicitudin. Donec at suscipit neque. Integer eget gravida lacus. Maecenas luctus dapibus hendrerit. Integer vel metus sed diam volutpat sagittis. Aliquam eu convallis tellus. Ut hendrerit ut mauris accumsan egestas. Vivamus iaculis ut mauris sed eleifend. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " Sed pretium eros sit amet magna scelerisque, non posuere elit placerat. Pellentesque consectetur neque massa, nec commodo nisl convallis vel. Aliquam in pellentesque elit. Nulla bibendum rhoncus libero vitae viverra. Vivamus tincidunt enim a turpis scelerisque interdum. Nunc ullamcorper lacinia nulla, vitae tempus magna ultrices ut. Quisque bibendum viverra nisi ut mollis. Donec accumsan massa leo, non fringilla eros malesuada eu. Donec convallis justo vel commodo vulputate. "
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
              
              # Species covered
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", uiOutput("species_count")),
                tags$p(style = "font-size: 16px; color: #555;", "Species covered")
              ),
              
              # Behaviors documented
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", uiOutput("behavior_count")),
                tags$p(style = "font-size: 16px; color: #555;", "Behaviors documented")
              ),
              
              # Populations cataloged
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", uiOutput("population_count")),
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
        #titlePanel("Populations"),
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
              " In non nulla sed neque pellentesque semper ut quis odio. Nulla pellentesque ante arcu, sit amet aliquam lectus aliquam at. Nunc semper quam eu ex eleifend, ut tempor lacus aliquam. Quisque at libero ipsum. Aliquam erat volutpat. Phasellus libero nulla, ultricies id aliquam id, sodales sit amet odio. Maecenas luctus sit amet ex eu faucibus. Sed blandit, tortor sed dignissim rutrum, lorem est congue elit, vitae dapibus nunc diam vitae metus. In sed tortor non ante laoreet laoreet. Cras vel tellus euismod, iaculis orci fringilla, efficitur dolor. Sed egestas ultrices accumsan. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " Vestibulum et erat at mauris ornare feugiat. Vivamus vitae augue ac neque congue egestas sed nec turpis. Nam dolor nunc, aliquam venenatis interdum mattis, luctus in velit. Nulla facilisi. Nullam interdum diam vel lobortis bibendum. Nulla ut sem elit. In at sapien fringilla, auctor elit ac, vulputate ante. Maecenas viverra consectetur venenatis. Cras eu dapibus augue, ut pretium quam. Sed commodo lacinia lacus accumsan mollis. Fusce imperdiet ligula eros, vitae pellentesque mauris convallis eu. Vestibulum facilisis purus in risus cursus, vitae eleifend mi consequat. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 0;",
              " Nunc placerat blandit enim, ac convallis magna pharetra at. Donec quis ornare mi, hendrerit tristique eros. Curabitur ultrices ultricies ornare. Suspendisse potenti. Cras iaculis turpis eget arcu pretium feugiat. Pellentesque condimentum lorem quis facilisis sollicitudin. Nulla eu lacus elementum, scelerisque quam non, condimentum turpis. Nunc at lectus at quam varius feugiat vitae ac ante. In suscipit sagittis augue accumsan maximus. Sed et elit et mi laoreet efficitur id quis neque. "
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
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ullamcorper risus massa, quis facilisis augue vehicula ut. Pellentesque posuere porta luctus. Integer massa erat, imperdiet non pharetra nec, tempus eget. "
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
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean non nunc vitae augue convallis maximus ut sit amet augue. Nunc egestas, dolor in cursus ultrices, enim diam fermentum diam, sed. "
            ),
            dataTableOutput("groups_table")
          )
        )
      )
    ),
    
    tabPanel(
      tags$div(icon("question-circle"), "Help"),
      fluidPage(
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 40px 20px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          # Help Title
          tags$div(
            style = "background-color: #f9f9f9; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h1(
              style = "font-size: 36px; font-weight: bold; text-align: center; color: #4CAF50; margin-bottom: 20px;",
              "Help and FAQs"
            ),
            tags$p(
              style = "text-align: center; color: #555555; margin-bottom: 40px;",
              " Nunc sodales libero et tortor interdum, nec viverra libero cursus. In lobortis ligula quam, vitae ultrices neque aliquam sed. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc sapien neque, faucibus in rutrum id, dignissim ut turpis. Pellentesque gravida mauris non convallis tristique. Mauris vel cursus nisi, in pretium neque. In hendrerit est eget sodales varius. "
            )
          ),
          
          # FAQ Sections
          tags$div(
            style = "margin-top: 20px;",
            
            # Question 1
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "How do I search for populations?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec quis felis ac felis efficitur suscipit. Curabitur vitae lacus vel ligula aliquet dignissim quis eget lacus."
              )
            ),
            
            # Question 2
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "How can I contribute data to the database?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum, nisl eu interdum aliquet, felis nulla sollicitudin elit, in faucibus risus urna vel justo."
              )
            ),
            
            # Question 3
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Where can I learn more about animal culture?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ullamcorper enim nec justo congue, ac cursus mauris aliquet. Pellentesque habitant morbi tristique senectus et netus."
              )
            ),
            
            # Question 4
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Who can I contact for technical support?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer non nisi erat. Fusce faucibus purus in magna vehicula consequat. Aliquam tempus vitae libero et laoreet."
              )
            )
          )
        )
      )
    ),
    
    tabPanel(
      "Edit Database",
      sidebarLayout(
        sidebarPanel(
          selectInput("edit_table_select", "Select Table to Edit:", 
                      choices = c("groups_table", "species_table", "behaviors_table", "sources_table")),
          actionButton("save_changes", "Save Changes", class = "btn-success"),
          actionButton("refresh_app", "Refresh App", class = "btn-primary")  # Refresh button
        ),
        mainPanel(
          h4("Edit Table:"),
          DTOutput("editable_table"),
          verbatimTextOutput("edit_info")  # To preview edits made
        )
      )
    )
    
    
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
  #on.exit(dbDisconnect(conn))
  
  # Compute stats
  species_count <- length(unique(species_table$species_id))
  behavior_count <- nrow(behaviors_table)
  population_count <- nrow(groups_table)
  
  # Send stats to the UI
  output$species_count <- renderText({ paste0(species_count, "+") })
  output$behavior_count <- renderText({ paste0(behavior_count, "+") })
  output$population_count <- renderText({ paste0(population_count, "+") })
  
  # Navigate to Populations tab when button is clicked
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
      # Use modern tile provider for aesthetics
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
              lapply(names(behavior), function(col_name) {
                
                # Check if the column name ends with "_source"
                if (grepl("_source$", col_name)) {
                  # Get references associated with the behavior
                  behavior_source <- behavior[[col_name]]
                  
                  if (!behavior_source == "") {
                    source_row <- sources_table[sources_table$source_id == behavior_source, ]
                    
                    if (nrow(source_row) > 0 && !is.na(source_row$doi)) {
                      # Render as a hyperlink if DOI exists
                      tags$p(
                        tags$b(paste0(col_name, ": ")),
                        tags$a(
                          href = paste0("https://doi.org/", source_row$doi),
                          target = "_blank",
                          behavior_source
                        )
                      )
                    } else {
                      # Render as plain text if no DOI exists
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
  
  # Reactive value to store selected table
  selected_table <- reactiveVal()
  
  # Load selected table into reactive value
  observeEvent(input$edit_table_select, {
    table_data <- dbReadTable(conn, input$edit_table_select)
    selected_table(table_data)
  })
  
  # Render editable table
  output$editable_table <- renderDT({
    req(selected_table())
    datatable(selected_table(), editable = TRUE)
  })
  
  # Store edits in reactive values
  edits <- reactiveValues(data = NULL)
  
  observeEvent(input$editable_table_cell_edit, {
    info <- input$editable_table_cell_edit
    str(info)  # Display edit info for debugging
    edits$data <- editData(selected_table(), info, proxy = DT::dataTableProxy("editable_table"))
  })
  
  # Save updated table to database
  observeEvent(input$save_changes, {
    req(edits$data)
    dbWriteTable(conn, input$edit_table_select, edits$data, overwrite = TRUE)
    showNotification(paste("Table", input$edit_table_select, "updated successfully!"), type = "message")
    # Reload table to confirm changes
    selected_table(edits$data)
  })
  
  # Refresh the app
  observeEvent(input$refresh_app, {
    showNotification("Refreshing the app to reflect changes...", type = "message")
    session$reload()  # Reload the app
  })
  
  # Close database connection on session end
  onSessionEnded(function() {
    dbDisconnect(conn)
  })
  
}





# Run the Shiny app
shinyApp(ui, server)
