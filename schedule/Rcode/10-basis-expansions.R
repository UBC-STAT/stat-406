## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ---- echo=FALSE, fig.width=8, fig.height=4, fig.align="center", dev="svg", warning=FALSE----
data(lidar, package = "UBCstat406labs")
lidar %>% ggplot(aes(range,logratio)) + geom_point(color=blue) + theme_cowplot() +
  geom_smooth(color=orange, formula = y~poly(x,3), method="lm", se=FALSE)


## ---- echo=FALSE, fig.width=10, fig.height=5, fig.align="center", dev="svg", warning=FALSE----
lidar %>% ggplot(aes(range,logratio)) + geom_point(color=blue) + theme_cowplot() +
  geom_smooth(aes(color="a"), formula = y~poly(x,4), method="lm", se=FALSE) +
  geom_smooth(aes(color="b"), formula = y~poly(x,7), method="lm", se=FALSE) +
  geom_smooth(aes(color="c"), formula = y~poly(x,13), method="lm", se=FALSE) +
  scale_color_manual(name="Taylor order",
    values=c(green,red,"purple"), labels=c("4 terms","7 terms","13 terms"))


## ----echo=FALSE, dev="svg"---------------------------------------------------------------
nmods = 20
loocv <- function(out) mean(residuals(out)^2/(1-hatvalues(out))^2)
cvscores = double(nmods)
for(i in 1:nmods) cvscores[i] = with(lidar, loocv(lm(logratio~poly(range,i))))
g1 = ggplot(data.frame(ord=1:nmods,cvscores=cvscores), aes(ord,cvscores)) +
  geom_point(color=blue) +
  geom_line(color=blue) + ylab('LOO CV') + xlab('polynomial order') +
  geom_vline(xintercept = which.min(cvscores), linetype="dotted") +
  theme_cowplot()
g2 = ggplot(lidar, aes(range,logratio)) + geom_point(color=blue) + 
  theme_cowplot() +
  geom_smooth(color=orange, 
              formula = y~poly(x,which.min(cvscores)), method="lm", se=FALSE)
plot_grid(g1,g2,nrow=2)


## ----simulation, cache=TRUE, echo=FALSE--------------------------------------------------
x = (lidar$range - min(lidar$range)+.005) / (max(lidar$range)-min(lidar$range)+.01)
Xmat = cbind(poly(x,20), splines::bs(x, df=20), 
             cos(2*pi*outer(x,1:20)), sin(2*pi*outer(x,1:20)))
y = lidar$logratio
library(glmnet)
mse <- function(x,y) mean((x-y)^2)
lidar_sim <- function(ord=20, train=0.75){
  n = nrow(lidar)
  train = as.logical(rbinom(n, 1, .75)); test=!train # not precisely 75%, but on average
  polycv = double(ord)
  for(i in 1:20) polycv[i] = loocv(lm(y~Xmat[,1:i], subset=train))
  bpoly = lm(y[train]~Xmat[train,1:which.min(polycv)])
  lasso = cv.glmnet(Xmat[train,],y[train])
  ridge = cv.glmnet(Xmat[train,],y[train],alpha = 0)
  elnet = cv.glmnet(Xmat[train,],y[train],alpha=.5)
  out = data.frame(
    methods=c("poly","lasso","ridge","elnet"),
    mses = c(mse(y[test], cbind(1,Xmat[test,1:which.min(polycv)])%*%coef(bpoly)),
             mse(y[test], predict(lasso,Xmat[test,],s="lambda.min")),
             mse(y[test], predict(ridge,Xmat[test,],s="lambda.min")),
             mse(y[test], predict(elnet,Xmat[test,],s="lambda.min"))
             ),
    nvars = c(which.min(polycv),
              sum(abs(coef(lasso,s="lambda.min"))>0),
              ncol(Xmat),
              sum(abs(coef(elnet,s="lambda.min"))>0))
  )
  out
}
set.seed(12345)
sim_out = lapply(1:10,lidar_sim)
sim_results = bind_rows(sim_out)


## ----sim-results, dev="svg", fig.height=4, fig.width=10, fig.align="center", echo=FALSE----
sim_results %>% pivot_longer(-methods) %>%
  ggplot(aes(methods, value, fill=methods)) + geom_boxplot() +
  facet_wrap(~name, scales = "free_y") + theme_cowplot() + ylab("") +
  theme(legend.position = "none") + xlab("")

