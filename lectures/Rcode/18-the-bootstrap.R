## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ---- echo=FALSE-------------------------------------------------------------------------
library(MASS)
fatcats = cats
fatcats$Hwt = fitted(lm(Hwt~Bwt, data=cats)) + rt(nrow(fatcats), 3)


## ---- fig.width=8, fig.height=6, fig.align='center', echo=FALSE--------------------------
ggplot(fatcats, aes(Bwt, Hwt)) + geom_point(color=blue) + theme_cowplot() +
  xlab("Cat body weight") + ylab("Cat heart weight")


## ----------------------------------------------------------------------------------------
cats.lm = lm(Hwt ~ 0+Bwt,data=fatcats)
summary(cats.lm)
confint(cats.lm)


## ---- fig.align='center', fig.width=7, fig.height=5--------------------------------------
qqnorm(residuals(cats.lm))
qqline(residuals(cats.lm))


## ----------------------------------------------------------------------------------------
B = 500
bhats = double(B)
alpha = .05
for(b in 1:B){
  samp = sample.int(
    nrow(fatcats), replace = TRUE)
  newcats = fatcats[samp,]
  bhats[b] = coef(
    lm(Hwt~0+Bwt,data=newcats))
}
2*coef(cats.lm) - 
  quantile(
    bhats, 
    probs = c(1-alpha/2, alpha/2))
confint(cats.lm)

