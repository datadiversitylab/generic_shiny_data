library(palmerpenguins)
library(here)
library(DBI)
library(RSQLite)

write.csv(penguins, here("db", "penguins.csv"), row.names = FALSE)
con <- dbConnect(RSQLite::SQLite(), here("db", "penguins.sqlite"))
dbWriteTable(con, "penguins", penguins, overwrite = TRUE)
dbDisconnect(con)
