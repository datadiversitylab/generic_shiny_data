library(DBI)
library(RSQLite)

db_path <- "www/db/animal_culture_db.sqlite" 
conn <- dbConnect(SQLite(), dbname = db_path)


# Population table
population_table <- data.frame(
  population_id = 1:4,
  population_name = c("Population A", "Population B", "Population C", "Population D"),
  longitude = c(-110.95, -110.97, -110.92, -110.93),
  latitude = c(32.23, 32.24, 32.25, 32.26),
  location_name = c("Location A", "Location B", "Location C", "Location D")
)

# Taxonomy table
taxonomy_table <- data.frame(
  population_id = 1:4,
  population_name = c("Population A", "Population B", "Population C", "Population D"),
  species = c("Species 1", "Species 2", "Species 3", "Species 4"),
  genus = c("Genus 1", "Genus 2", "Genus 3", "Genus 4"),
  family = c("Family 1", "Family 2", "Family 3", "Family 4")
)

# Behavior table
behavior_table <- data.frame(
  behavior_id = 1:8,  # Unique identifier for each behavior
  population_id = c(1, 1, 2, 2, 3, 3, 4, 4),  # Relates to population_id
  behavior_name = c("Behavior 1A", "Behavior 1B", "Behavior 2A", "Behavior 2B",
                    "Behavior 3A", "Behavior 3B", "Behavior 4A", "Behavior 4B"),
  type_of_behavior = c("Type A", "Type B", "Type A", "Type B",
                       "Type C", "Type D", "Type C", "Type D")
)

# References table
references_table <- data.frame(
  reference_id = 1:12,  # Unique identifier for each reference
  behavior_id = c(1, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 8),  # Relates to behavior_id
  reference_text = c(
    "Citation 1 for Behavior 1A", "Citation 2 for Behavior 1A",
    "Citation 1 for Behavior 1B", "Citation 1 for Behavior 2A",
    "Citation 2 for Behavior 2A", "Citation 1 for Behavior 2B",
    "Citation 1 for Behavior 3A", "Citation 1 for Behavior 3B",
    "Citation 2 for Behavior 3B", "Citation 1 for Behavior 4A",
    "Citation 1 for Behavior 4B", "Citation 2 for Behavior 4B"
  )
)


dbWriteTable(conn, "population_table", population_table, overwrite = TRUE)
dbWriteTable(conn, "taxonomy_table", taxonomy_table, overwrite = TRUE)
dbWriteTable(conn, "behavior_table", behavior_table, overwrite = TRUE)
dbWriteTable(conn, "references_table", references_table, overwrite = TRUE)

# Close the connection
dbDisconnect(conn)
