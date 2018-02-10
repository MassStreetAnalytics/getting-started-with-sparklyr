#Use SQL to query data

# Set wd to directory of source file.
# This only works in R studio.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(tidyverse)
library(sparklyr)
library(DBI)

#This is NOT a Spark Context!
#You interact with data via Spark SQL
#That requires a Spark Session not a
#Spark context.
#Make sure you have Java installed.
sc = spark_connect(master="local")


#Construct path in a platform independent way
tbl_import_iris = spark_read_csv(
  sc, 
  path = file.path("../../Data","iris_dataset.csv",fsep = .Platform$file.sep), 
  col_names = TRUE, 
  name = "import_iris", 
  overwrite = TRUE
)


iris_preview = dbGetQuery(sc, "SELECT * FROM import_iris WHERE Species = 'versicolor'")

#Clean Up
spark_disconnect(sc)
rm(list=ls())
