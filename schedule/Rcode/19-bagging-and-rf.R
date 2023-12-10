## ----mobility-rf----------------------------------------------------------------
library(randomForest)
library(kableExtra)
set.seed(406406)
mob <- Stat406::mobility |>
  mutate(mobile = as.factor(Mobility > .1)) |>
  select(-ID, -Name, -Mobility, -State) |>
  drop_na()
n <- nrow(mob)
trainidx <- sample.int(n, floor(n * .75))
testidx <- setdiff(1:n, trainidx)
train <- mob[trainidx, ]
test <- mob[testidx, ]
rf <- randomForest(mobile ~ ., data = train)
bag <- randomForest(mobile ~ ., data = train, mtry = ncol(mob) - 1)
preds <-  tibble(truth = test$mobile, rf = predict(rf, test), bag = predict(bag, test))

kbl(cbind(table(preds$truth, preds$rf), table(preds$truth, preds$bag))) |>
  add_header_above(c("Truth" = 1, "RF" = 2, "Bagging" = 2))


## ----mobility-results-----------------------------------------------------------
#| fig-height: 5
#| fig-width: 8
varImpPlot(rf, pch = 16, col = orange)


## -------------------------------------------------------------------------------
tab <- table(predict(bag), train$mobile) 
kbl(tab) |> add_header_above(c("Truth" = 1, "Bagging" = 2))
1 - sum(diag(tab)) / sum(tab) ## OOB misclassification error, no need for CV

