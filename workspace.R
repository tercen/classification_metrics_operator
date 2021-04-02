library(tercen)
library(dplyr)

options("tercen.workflowId" = "968e828a2d8eb509f7ccd060700068fe")
options("tercen.stepId"     = "c45ed612-7847-46d5-ac55-cc2f1f2c0a02")

getOption("tercen.workflowId")
getOption("tercen.stepId")

df <- (ctx = tercenCtx())  %>% 
  select(.y, .ri) %>%
  mutate(predicted = ctx$select(ctx$colors[[1]])[[1]]) %>%
  mutate(true = ctx$rselect()[[1]][.$.ri + 1])

mat <- table(df$predicted, df$true)

precision <- diag(mat) / rowSums(mat)
recall <- diag(mat) / colSums(mat)
f1 <- 2*precision*recall / (precision+recall)

df_out <- data.frame(label = names(precision), precision, recall, f1)

table = tercen::dataframe.as.table(ctx$addNamespace(df_out)) 
table$properties$name = 'value'
table$columns[[1]]$type = 'double'

relation = SimpleRelation$new()
relation$id = table$properties$name

join = JoinOperator$new()
join$rightRelation = relation

result = OperatorResult$new()
result$tables = list(table)
result$joinOperators = list(join)

ctx$save(result) 