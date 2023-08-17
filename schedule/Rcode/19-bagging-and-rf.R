## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")
library(randomForest)


## ----mobility-rf-------------------------------------------------------------------------
data(mobility, package="UBCstat406labs")
mob = mobility %>% 
  mutate(mobile=as.factor(Mobility>.1)) %>%
  dplyr::select(-ID,-Name,-Mobility,-State) %>% 
  drop_na()
n = nrow(mob)
trainidx = sample.int(n, floor(n*.75))
testidx = setdiff(1:n, trainidx)
train = mob[trainidx,]; test=mob[testidx,]
rf = randomForest(mobile~., data=train)
bag = randomForest(mobile~., data=train,
  mtry=ncol(mob)-1)
preds = tibble(
  truth=test$mobile,
  rf = predict(rf, test),
  bag = predict(bag, test))
cbind(table(preds$truth, preds$rf), 
      table(preds$truth, preds$bag))


## ----mobility-results--------------------------------------------------------------------
varImpPlot(rf)


## ----------------------------------------------------------------------------------------
tab = table(predict(bag), train$mobile)
tab
1-sum(diag(tab))/sum(tab) ## misclassification error

