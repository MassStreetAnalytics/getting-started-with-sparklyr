# Databricks notebook source
#This example has a bug in it.

#https://docs.databricks.com/user-guide/faq/sparklyr.html#sparklyr
install.packages("Rcpp")
install.packages("tidyverse")
install.packages("sparklyr")

# COMMAND ----------

library(tidyverse)
library(sparklyr)

# COMMAND ----------

sc = spark_connect(method = "databricks")

# COMMAND ----------

tbl_import_iris = spark_read_csv(
sc, 
path = "/FileStore/tables/07o5weo11509349233303/iris_dataset.csv", 
col_names = TRUE, 
name = "import_iris", 
overwrite = TRUE
)

# COMMAND ----------

#Split the iris data into test/train sets
#Register the training set
#Create an R reference object for the training set
#sdf_partition is not actually a partition
partition_iris = sdf_partition(tbl_import_iris, training=0.5, testing=0.5, seed = 1000) 

# COMMAND ----------

#this is all done with SparkSQL so you have to give things a table name
sdf_register(partition_iris, c("spark_iris_training", "spark_iris_test")) 

#Create local reference to the training set.
tidy_iris <- tbl(sc, "spark_iris_training") %>% select(Species, PetalLength, PetalWidth)

# COMMAND ----------

### Build and Train a Model in Spark
model_iris <- tidy_iris %>% ml_decision_tree(response="Species", features=c("PetalLength", "PetalWidth"))

# COMMAND ----------

### Test the Model
test_iris <- tbl(sc, "spark_iris_test")

#Pull results from Spark back into R.
pred_iris <- sdf_predict(model_iris, test_iris) %>% collect

# COMMAND ----------

### Visualize the Model Prediction


pred_iris %>% inner_join(data.frame(prediction=0:2, lab=model_iris$model.parameters$labels)) %>% ggplot(aes(PetalLength, PetalWidth, col=lab)) + geom_point()
