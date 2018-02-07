#Install spark and sparklyr if neccessary.

install.packages("sparklyr")
install.packages("tidyverse")
install.packages("rstudioapi")

#Get the latest build
devtools::install_github("rstudio/sparklyr")

#Install Spark the easy way.
#Check for the latest release.
#https://spark.apache.org/
#Make sure you update Java.
#After install, restart your machine.
spark_install("2.2.1")