library(tercen)
library(dplyr)

ctx <- tercenCtx()

df <- ctx  %>% 
  select(.y, .ri) %>%
  mutate(predicted = ctx$select(ctx$colors[[1]])[[1]]) %>%
  mutate(truth = ctx$select(ctx$labels[[1]])[[1]])

lev <- union(df$predicted, df$truth)
mat <- table(factor(df$predicted, levels = lev), factor(df$truth, levels = lev))

precision <- diag(mat) / rowSums(mat)
recall <- diag(mat) / colSums(mat)
f1 <- 2*precision*recall / (precision+recall)

df_tmp<- data.frame(label = names(precision), precision, recall, f1) 
#df_out<-ctx$addNamespace(df_tmp)

# table = tercen::dataframe.as.table(df_tmp) 
# table$properties$name = 'value'
# table$columns[[1]]$type = 'double'
# 
# relation = SimpleRelation$new()
# relation$id = table$properties$name
# 
# join = JoinOperator$new()
# join$rightRelation = relation
# 
# result = OperatorResult$new()
# result$tables = list(table)
# result$joinOperators = list(join)

df.out<-df %>%
  select(-.y) %>%
  merge(. ,df_tmp,
               by.x = "truth",
               by.y = "label",
               all.x = TRUE) %>%
  ctx$addNamespace()


ctx$save(df.out)

