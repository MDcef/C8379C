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


#retrieve data from database
lancomp <- dbGetQuery(con2, "SELECT * FROM geofish_age.month_landing_composition_2009_2019")

#withdraws the unique entries from the selected columns to be the choosable labels in the sidebar
gearChoices = unique(lancomp$gear_name)

speChoices = unique(lancomp$species_common)

#sorting to descending
monthChoices = unique(lancomp$le_month)
monthChoices <- as.data.frame(monthChoices)
monthChoices <- monthChoices[order(monthChoices),]

yearChoices = unique(lancomp$le_year)
yearChoices <- as.data.frame(yearChoices)
yearChoices <- subset(yearChoices, yearChoices >1999)
yearChoices <- yearChoices[order(yearChoices),]

