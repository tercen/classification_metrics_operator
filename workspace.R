library(tercen)
library(dplyr)

options("tercen.workflowId" = "7b9fc17ffad7902a066fc1f4cf01393d")
options("tercen.stepId"     = "528ddb1c-800f-4751-9605-2bdb6e02c5ab")

getOption("tercen.workflowId")
getOption("tercen.stepId")

df <- (ctx = tercenCtx())  %>% 
  select(.y, .ri) %>%
  mutate(predicted = ctx$select(ctx$colors[[1]])[[1]]) %>%
  mutate(truth = ctx$select(ctx$labels[[1]])[[1]])

lev <- union(df$predicted, df$truth)
mat <- table(factor(df$predicted, levels = lev), factor(df$truth, levels = lev))

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
