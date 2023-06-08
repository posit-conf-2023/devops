library(dplyr)
library(palmerpenguins)
library(DBI)
library(duckdb)
library(knitr)


con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "my-db.duckdb") # create a db connection
DBI::dbWriteTable(con, "penguins", palmerpenguins::penguins) 
DBI::dbDisconnect(con)


df <- dplyr::tbl(con, "penguins")

df %>%
  group_by(species, sex) %>%
  summarise(
    across(
      ends_with("mm") | ends_with("g"),
      \(x) mean(x, na.rm = TRUE)
    )
  ) %>%
  dplyr::collect() %>%
  knitr::kable()