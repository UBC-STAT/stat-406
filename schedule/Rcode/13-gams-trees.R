## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ---- fig.align='center',fig.width=10,fig.height=4,message=FALSE-------------------------
library(mgcv)
set.seed(12345)
n = 500
simple = tibble(
  x1 = runif(n, 0, 2*pi),
  x2 = runif(n),
  y = 5 + 2*sin(x1) + 8*sqrt(x2) +
    rnorm(n,sd=.25))


## ----simple-data, echo=FALSE, fig.align='center',fig.width=5,fig.height=3----------------
pivot_longer(simple, -y, names_to="predictor", values_to="x") %>%
  ggplot(aes(x,y)) + geom_point(col=blue) +
  facet_wrap(~predictor,scales = 'free_x') + theme_cowplot()


## ----------------------------------------------------------------------------------------
ex_smooth = gam(
  y~s(x1)+s(x2), data=simple)


## ----gam-mod, echo=FALSE, fig.width=5,fig.height=4, fig.align='center'-------------------
plot(ex_smooth, pages = 1, scale=0, shade=TRUE, resid=TRUE, se=2, bty='n', las=1)


## ----------------------------------------------------------------------------------------
ex_smooth2 = gam(
  y~s(x1,x2), data=simple)


## ----gam-mod2, echo=FALSE, fig.width=6,fig.height=6, fig.align='center'------------------
plot(ex_smooth2, pers=TRUE, scale=0, shade=TRUE, resid=TRUE, se=2, bty='n', las=1)


## ----small-tree-prelim, echo=FALSE-------------------------------------------------------
data("mobility", package = "UBCstat406labs")
library(tree)
library(maptree)
mob = mobility[complete.cases(mobility),] %>% dplyr::select(-ID,-Name)
set.seed(12345)
par(mar=c(0,0,0,0),oma=c(0,0,0,0))


## ----small-tree, fig.align="center", fig.width=10,fig.height=4---------------------------
bigtree = tree(Mobility~., data=mob)
smalltree = prune.tree(bigtree, k=.09)
draw.tree(smalltree, digits=2)


## ----partition-view, echo=FALSE, fig.width=12,fig.height=5,fig.align="center"------------
mob$preds = predict(smalltree)
par(mfrow=c(1,2))
draw.tree(smalltree, digits=2)
cols = viridisLite::viridis(20, direction = -1)[cut(log(mob$Mobility),20)]
plot(mob$Black, mob$Commute, pch=19, cex=.4, bty='n',las=1, col=cols, 
     ylab="Commute time",xlab="% Black")
partition.tree(smalltree,add=TRUE, ordvars = c("Black","Commute"))


## ----big-tree,  fig.align="center", fig.width=10,fig.height=5,echo=FALSE-----------------
draw.tree(bigtree, digits=2)

