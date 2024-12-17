library(DBI)
library(RSQLite)

# Database file path
db_path <- "db/animal_culture_db.sqlite" 

# Connect to the SQLite database
conn <- dbConnect(SQLite(), dbname = db_path)

# Read data from CSV files
species <- read.csv("db/nov2624_species.csv", encoding = "latin1")
groups <- read.csv("db/dec1324_groups.csv", encoding = "latin1")
behaviors <- read.csv("db/dec924_behaviors.csv", encoding = "latin1")
sources <- read.csv("db/dec924_sources.csv", encoding = "latin1")

# Write the tables to the SQLite database
dbWriteTable(conn, "species_table", species, overwrite = TRUE)
dbWriteTable(conn, "groups_table", groups, overwrite = TRUE)
dbWriteTable(conn, "behaviors_table", behaviors, overwrite = TRUE)
dbWriteTable(conn, "sources_table", sources, overwrite = TRUE)

# Disconnect from the database
dbDisconnect(conn)
