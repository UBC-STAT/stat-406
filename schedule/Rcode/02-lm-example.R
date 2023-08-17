## ----setup, include=FALSE----------------------------------------------------------------
source("rmd_config.R")
knitr::opts_chunk$set(dpi=300,warning=FALSE,message=FALSE)


## ----------------------------------------------------------------------------------------
library(UBCstat406labs)
library(tidyverse)
mobility


## ----------------------------------------------------------------------------------------
set.seed(20200901)
mob = mobility[complete.cases(mobility),]
n = nrow(mob)
mob = mob %>% select(-Name,-ID,-State)
set = sample.int(n, floor(n*.75), FALSE)
train = mob[set,]  #<<
test = mob[setdiff(1:n, set),]
full = lm(Mobility ~ ., data=train)


## ----------------------------------------------------------------------------------------
full %>% broom::tidy()
full %>% broom::glance()


## ----------------------------------------------------------------------------------------
plot(full, 1)


## ----------------------------------------------------------------------------------------
plot(full, 2)


## ----------------------------------------------------------------------------------------
reduced <- lm(
  Mobility ~ Commute + Gini_99 + Test_scores + HS_dropout +
    Manufacturing + Migration_in + Religious + Single_mothers, 
  data=train)
reduced %>% broom::tidy()
reduced %>% broom::glance()


## ----------------------------------------------------------------------------------------
plot(reduced, 1)


## ----------------------------------------------------------------------------------------
plot(reduced, 2)


## ----------------------------------------------------------------------------------------
test$full = predict(full, newdata = test)
test$reduced = predict(reduced, newdata = test)
mses <- function(preds, obs) mean((obs-preds)^2)
sapply(
  test[, c("full","reduced")], mses, 
  obs=test$Mobility)


## ---- echo=FALSE-------------------------------------------------------------------------
test %>% select(Mobility, full, reduced) %>%
  pivot_longer(-Mobility) %>%
  ggplot(aes(Mobility,value)) + geom_point(color="orange") + 
  facet_wrap(~name, 2) +
  cowplot::theme_cowplot() + xlab('observed mobility') + 
  ylab('predicted mobility') +
  geom_abline(slope=1,intercept = 0,col="blue")

