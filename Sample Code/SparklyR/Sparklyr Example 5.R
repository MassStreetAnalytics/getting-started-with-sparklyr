#Not today

spark_apply(iris_tbl, function(data) {
  data[1:4] + rgamma(1,2)
})

spark_apply(
  iris_tbl,
  function(e) broom::tidy(lm(Petal_Width ~ Petal_Length, e)),
  names = c("term", "estimate", "std.error", "statistic", "p.value"),
  group_by = "Species"
)
