## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----data-setup--------------------------------------------------------------------------
set.seed(123)
n = 406
df = tibble(
  x1 = rnorm(n),
  x2 = rnorm(n, mean=2, sd=1),
  x3 = rexp(n, rate=1),
  x4 = x2 + rnorm(n, sd=.1),
  x5 = x1 + rnorm(n, sd=.1),
  x6 = x1 - x2 + rnorm(n, sd=.1),
  x7 = x1 + x3 + rnorm(n, sd=.1),
  y = x1*3 + x2/3 + rnorm(n, sd=2.2)
)


## ----full-model--------------------------------------------------------------------------
full = lm(y~., data=df)


## ----full-table, echo=FALSE--------------------------------------------------------------
summary(full)


## ----true-model--------------------------------------------------------------------------
truth = lm(y~x1+x2, data=df)


## ----true-table, echo=FALSE--------------------------------------------------------------
summary(truth)


## ----try-them-all------------------------------------------------------------------------
library(leaps)
trythemall = regsubsets(y~., data=df)
summary(trythemall)


## ----more-all-subsets1-------------------------------------------------------------------
infocrit = tibble(
  BIC = summary(trythemall)$bic, 
  Cp = summary(trythemall)$cp,
  size = 1:7)


## ----more-all-subsets2, echo=FALSE, dev="svg"--------------------------------------------
infocrit %>% pivot_longer(-size, names_to="crit") %>%
  ggplot(aes(size, value, color=crit)) + geom_point() + geom_line() + 
  facet_wrap(~crit, 2, scales = "free_y") + theme_cowplot() +
  scale_color_brewer(palette = "Set1") +
  theme(axis.title.y=element_blank(), legend.position = "none")


## ----step-forward------------------------------------------------------------------------
stepup = regsubsets(y~., data=df, method = "forward")
summary(stepup)


## ----more-step-forward, echo=FALSE, dev="svg", fig.width=10, fig.height=5, fig.align="center"----
infocrit2 = tibble(
  BIC = summary(stepup)$bic, 
  Cp = summary(stepup)$cp,
  size = 1:7)
infocrit2 %>% pivot_longer(-size, names_to="crit") %>%
  ggplot(aes(size, value, color=crit)) + geom_point() + geom_line() + 
  facet_wrap(~crit, 1, scales = "free_y") + theme_cowplot() +
  scale_color_brewer(palette = "Set1") +
  theme(axis.title.y=element_blank(), legend.position = "none")


## ----replication-exercise, cache=TRUE, echo=FALSE----------------------------------------
fun <- function() {
  n = 812
  df = tibble(x1 = rnorm(n), x2 = rnorm(n, mean=2, sd=1), x3 = rexp(n, rate=1),
    x4 = x2 + rnorm(n, sd=.1), x5 = x1 + rnorm(n, sd=.1),
    x6 = x1 - x2 + rnorm(n, sd=.1), x7 = x1 + x3 + rnorm(n, sd=.1),
    y = x1*3 + x2/3 + rnorm(n, sd=2.2)
  )
  train = df[1:406,]; test=df[407:n,]
  truth = lm(y~x1+x2, data=train)
  full = lm(y~., data=train)
  stepup = regsubsets(y~., data=train, method="forward")
  coefs = double(8)
  names(coefs) = names(coef(full))
  best = which.min(summary(stepup)$cp)
  coefs[names(coef(stepup,best))] = coef(stepup,best)
  out = c(correct = mean((test$y-predict(truth, newdata = test))^2),
          full = mean((test$y-predict(full, newdata = test))^2),
          step = mean((test$y - as.matrix(cbind(1,test[,-8])) %*% coefs )^2),
          truth = mean((test$y - as.matrix(test[,1:2]) %*% c(3,1/3))^2),
          nbest = best)
  out
}
set.seed(12345)
sim = t(replicate(50, fun()))


## ----synth-results, dev="svg", fig.width=10, fig.height=5, echo=FALSE, fig.align="center"----
sim = as.data.frame(sim)
mses = sim %>% dplyr::select(-nbest) %>% mutate(full = (full-truth)/truth*100, step=(step-truth)/truth*100, correct = (correct-truth)/truth*100,truth=NULL)
g1 = mses %>% pivot_longer(everything(), names_to = "method", values_to = "mse") %>%
  ggplot(aes(method,mse,fill=method)) + geom_boxplot() +
  theme_cowplot() + scale_fill_brewer(palette = "Set1") +
  theme(legend.position = "none") + ylab("% increase in mse relative to oracle")
g2 = sim %>% ggplot(aes(y=nbest)) + geom_bar(aes(x=..prop..), fill=orange) + 
  theme_cowplot() + xlab("proportion of times") + ylim(c(0,7.5)) + 
  ylab("# selected predictors")
plot_grid(g1,g2,rel_widths = c(.66,.34), axis = "b")

