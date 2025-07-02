###################
# server.R
# 
# Server controller. 
# Used to define the back-end aspects of the app.
###################

library(RSQLite)
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(palmerpenguins)


#Using a CSV file
#penguins_data <- read.csv(here("db", "penguins.csv"))

#Using a SQL file
con <- dbConnect(RSQLite::SQLite(), here("db", "penguins.sqlite"))
penguins_data <- dbReadTable(con, "penguins")
dbDisconnect(con)


server <- function(input, output, session) {
  
  # Clean data: remove rows with NA in core numeric fields
  penguins_clean <- na.omit(penguins_data)
  
  # Distribution plots per species
  output$distPlot <- renderPlot({
    features <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")
    
    penguins_long <- penguins_clean %>%
      tidyr::pivot_longer(cols = all_of(features), names_to = "feature", values_to = "value")
    
    ggplot(penguins_long, aes(x = value, fill = species)) +
      geom_density(alpha = 0.5) +
      facet_wrap(~feature, scales = "free") +
      theme_minimal() +
      labs(title = "Distributions by Species", x = "", y = "Density")
  })
  
  # Summary table: species-level
  species_summary <- penguins_clean %>%
    group_by(species) %>%
    summarise(
      Count = n(),
      Mean_Bill_Length = round(mean(bill_length_mm), 2),
      Mean_Bill_Depth = round(mean(bill_depth_mm), 2),
      Mean_Flipper_Length = round(mean(flipper_length_mm), 2),
      Mean_Body_Mass = round(mean(body_mass_g), 2),
      .groups = "drop"
    )
  
  output$speciesTable <- renderDT({
    datatable(species_summary, selection = "single", rownames = FALSE)
  })
  
  # Modal for details on species row click
  observeEvent(input$speciesTable_rows_selected, {
    selected_species <- species_summary$species[input$speciesTable_rows_selected]
    
    species_data <- penguins_clean %>%
      filter(species == selected_species)
    
    island_stats <- species_data %>%
      group_by(island) %>%
      summarise(
        Count = n(),
        Mean_Bill_Length = round(mean(bill_length_mm), 2),
        Mean_Body_Mass = round(mean(body_mass_g), 2),
        .groups = "drop"
      )
    
    sex_ratio <- species_data %>%
      count(sex) %>%
      tidyr::pivot_wider(names_from = sex, values_from = n, values_fill = 0)
    
    year_distribution <- species_data %>%
      count(year)
    
    showModal(modalDialog(
      title = paste("Details for", selected_species),
      
      h4("Island stats"),
      renderTable(island_stats),
      
      h4("Sampling years"),
      renderTable(year_distribution),
      
      h4("Sex ratio information"),
      renderTable(sex_ratio),
      
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  
}

