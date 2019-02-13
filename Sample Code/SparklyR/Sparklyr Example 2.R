#Using dplyr functionality

library(sparklyr)
library(tidyverse)

sc <- spark_connect(master = "local")

flights_tbl = spark_read_csv(
  sc, 
  path = file.path("../../Data","flights.csv",fsep = .Platform$file.sep), 
  col_names = TRUE, 
  name = "flights", 
  overwrite = TRUE
)


# filter by departure delay and print the first few records
flights_tbl %>% filter(dep_delay == 2)

delay = flights_tbl %>% 
  group_by(tailnum) %>%
  summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>%
  filter(count > 20, dist < 2000, !is.na(delay)) %>%
  collect

# plot delays
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area(max_size = 2)

#Clean Up
spark_disconnect(sc)
rm(list=ls())


?ml_decision_tree

library(nycflights13)
?nycflights13

install.packages("nycflights13")
library(nycflights13)
?nycflights13::flights

dim(flights)
R.version
