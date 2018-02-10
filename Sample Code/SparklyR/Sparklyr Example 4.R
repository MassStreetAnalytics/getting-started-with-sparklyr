#Linear regression output

# Set wd to directory of source file.
# This only works in R studio.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(tidyverse)
library(sparklyr)

sc = spark_connect(master="local")

#Construct path in a platform independent way
mtcars_tbl = spark_read_csv(
  sc, 
  path = file.path("../../Data","mtcars.csv",fsep = .Platform$file.sep), 
  col_names = TRUE, 
  name = "mt_cars", 
  overwrite = TRUE
)


# transform our data set, and then partition into 'training', 'test'
partitions = mtcars_tbl %>%
  filter(hp >= 100) %>%
  mutate(cyl8 = cyl == 8) %>%
  sdf_partition(training = 0.5, test = 0.5, seed = 1000)


# fit a linear model to the training dataset
fit = partitions$training %>% ml_linear_regression(response = "mpg", features = c("wt", "cyl"))

summary(fit)

#Clean Up
spark_disconnect(sc)
rm(list=ls())
