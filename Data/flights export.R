library("nycflights13")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library("Lahman")
library("tidyverse")

write_csv(Lahman::Batting, "batting.csv")
