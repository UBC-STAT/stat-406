## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----echo=FALSE--------------------------------------------------------------------------
library(randomForest)
data(mobility, package="UBCstat406labs")
mob = mobility %>% 
  mutate(mobile=as.numeric(Mobility>.1)) %>%
  dplyr::select(-ID,-Name,-Mobility,-State) %>% 
  drop_na()
n = nrow(mob)
trainidx = sample.int(n, floor(n*.75))
testidx = setdiff(1:n, trainidx)
train = mob[trainidx,]; test=mob[testidx,]
rf = randomForest(as.factor(mobile)~., data=train)
bag = randomForest(as.factor(mobile)~., data=train,
  mtry=ncol(mob)-1)
preds = tibble(
  truth=test$mobile,
  rf = predict(rf, test),
  bag = predict(bag, test))


## ---- fig.align='center', fig.height=5, fig.width=10-------------------------------------
library(gbm)
adab = gbm(mobile~., data=train, n.trees = 500, distribution = "adaboost")
preds$adab = as.numeric(predict(adab, test)>0)
par(mar=c(5,15,0,1))
summary(adab, las=1)


## ----loss-funs, fig.align="center", echo=FALSE, fig.height=4-----------------------------
losses = tibble(x = seq(-2,2,length.out = 100),
       Misclassification = as.numeric(x<0),
       Exponential = exp(-x),
       Binomial_deviance = log2(1+exp(-2*x)),
       Squared_error = (x-1)^2,
       Support_vector = pmax((1-x),0))
losses %>% pivot_longer(-x) %>%
  ggplot(aes(x, y=value, color=name)) + geom_line() + theme_cowplot() +
  coord_cartesian(ylim=c(0,3)) + 
  theme(legend.title = element_blank(), legend.position = c(.65,.65)) + 
  scale_color_brewer(palette = "Set1") +
  ylab("Loss") + xlab(bquote(y~f(x)))


## ----gbm---------------------------------------------------------------------------------
grad_boost = gbm(mobile~., data=train, n.trees = 500, distribution = "bernoulli")


## ---- fig.height=3.5, fig.width=10, fig.align='center', echo=FALSE-----------------------
boost_preds = tibble(
  adaboost = predict(adab, test),
  gbm = predict(grad_boost,test),
  truth = test$mobile)
g1 = ggplot(boost_preds, aes(adaboost, gbm, color=as.factor(truth))) +
  geom_text(aes(label=truth)) + geom_vline(xintercept = 0) + 
  geom_hline(yintercept = 0) +
  theme_cowplot() + theme(legend.position = 'none') +
  scale_color_manual(values=c('orange','blue')) +
  annotate("text", x=-4,y=5, color=green,
           label=round(with(boost_preds,mean((gbm>0)==truth)),2)) +
  annotate("text", x=4,y=-5, color=green, 
           label=round(with(boost_preds,mean((adaboost>0)==truth)),2))
boost_oob = tibble(adaboost=adab$oobag.improve, gbm=grad_boost$oobag.improve,
                   ntrees=1:500)
g2 = boost_oob %>% pivot_longer(-ntrees, values_to = "OOB_Error") %>% 
  ggplot(aes(x=ntrees, y=OOB_Error, color=name)) + geom_line() + 
  theme_cowplot() + scale_color_manual(values=c(orange,blue)) +
  theme(legend.title = element_blank())
plot_grid(g1,g2)

