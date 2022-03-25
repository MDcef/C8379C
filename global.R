library(RODBC)
library(RPostgres)
library(lubridate)
library(dplyr)
library(dbplyr)
library(tidyverse)
library(glue)
library(vmstools)
library(sf)
require (RPostgreSQL); library(DBI)
library(RPostgreSQL)
library(DBI)
library(odbc)
require(RPostgres)
library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(grid)
library(gridExtra)
library(glue)

# connect to development_db
con1 <- dbConnect(
  Postgres(),
  host = "azsclnxgis01.postgres.database.azure.com",
  dbname = "development_db",
  port = 5432,
  user = "editors_dev@azsclnxgis01",
  password = "Dev!c5374")

con2 <- dbConnect(
  Postgres(),
  host = "azsclnxgis01.postgres.database.azure.com",
  dbname = "geofish",
  port = 5432,
  user = "geofish_age_viewer@azsclnxgis01",
  password = "L00k@tF!sh!"
)


# tt <- dbGetQuery(con1, "SELECT * FROM bycatch_fishing_activity.test_table")
# tacEfC <- dbGetQuery(con1, "SELECT * FROM bycatch_fishing_activity.tacsat_eflalo_csquare_2019")

lancomp <- dbGetQuery(con2, "SELECT * FROM geofish_age.month_landing_composition_2009_2019")

gearChoices = unique(lancomp$gear_name) #setNames(lancomp$gear_name, lancomp$gear_name)
monthChoices = unique(lancomp$le_month) # setNames(lancomp$le_month, lancomp$le_month)
yearChoices = unique(lancomp$le_year) # setNames(lancomp$le_year, lancomp$le_year)