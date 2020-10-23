## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----good-pca, echo=FALSE, fig.align='center',fig.height=4,fig.width=5-------------------
library(mvtnorm)
m = c(2,3)
covmat = matrix(c(1,.75,.75,1),2)
ee = eigen(covmat)
x = rmvnorm(200, m, covmat)
z = apply(x, 1, function(x) sqrt(sum(x^2)))
df = data.frame(x=x[,1], y=x[,2], z=z)
ss = sqrt(ee$values)
df_arrows = data.frame(x1 = m[1], y1 = m[2],
                       x2 = m[1] + 3*ee$vectors[1,]*ss/sum(ss),
                       y2 = m[2] + 3*ee$vectors[2,]*ss/sum(ss))
ggplot(df) + geom_point(aes(x,y,color=z)) + 
  scale_color_viridis_c()+ coord_fixed() +
  theme_cowplot() +theme(legend.position = 'none') +
  geom_segment(aes(x=x1,y=y1,xend=x2,yend=y2), data=df_arrows, arrow=arrow(), size=2, color=orange)


## ----pca-reduced, fig.align='center',fig.height=5,fig.width=8,echo=FALSE-----------------
xx = scale(x, center=m, scale=FALSE) %*% ee$vectors[,1]
df2 = data.frame(x=xx + m[1], y=xx + m[2], z=z)
ggplot(df2) + geom_point(aes(x=x,y=y,col=z)) + 
  theme_cowplot() +theme(legend.position = 'none') +
  scale_color_viridis_c()


## ----spiral, fig.align='center',fig.height=5,fig.width=6, echo=FALSE---------------------
tt = seq(0,4*pi,length=100)
df_spiral = data.frame(x = 3/2*tt*sin(tt), y = 0.5*tt*cos(tt), z=tt) %>%
  mutate(x = x/sd(x), y=y/sd(y))
ee = eigen(crossprod(scale(as.matrix(df_spiral[,1:2]))))
ss = sqrt(ee$values)
df_arrows = data.frame(x1 = 0, y1 = 0,
                       x2 =  ee$vectors[1,]*ss/sum(ss)*2,
                       y2 =  ee$vectors[2,]*ss/sum(ss)*2)
gsp = ggplot(df_spiral) + geom_point(aes(x=x,y=y,col=z)) + 
  coord_fixed() +
  scale_color_viridis_c() + theme_cowplot() + theme(legend.position = 'none') +
  geom_segment(aes(x=x1,y=y1,xend=x2,yend=y2), data=df_arrows, arrow=arrow(), size=2,color=orange)
gsp


## ----spiral-reduced, fig.align='center',fig.height=4,fig.width=6, echo=FALSE-------------
xx = as.matrix(df_spiral[,1:2]) %*% ee$vectors[,1]
df_spiral2 = data.frame(x=xx, y=xx, z=tt)
ggplot(df_spiral2) + geom_point(aes(x=x,y=y,col=z)) + 
  scale_color_viridis_c() + theme_cowplot() + 
  theme(legend.position = 'none')


## ---- fig.align='center',fig.height=5,fig.width=6, echo=FALSE----------------------------
gsp


## ----get-kpca, echo=FALSE----------------------------------------------------------------
n = nrow(df_spiral)
I_M = (diag(n) - tcrossprod(rep(1,n))/n)
kp = (tcrossprod(as.matrix(df_spiral[,1:2])) + 1)^2
Kp = I_M %*% kp %*% I_M
Ep = eigen(Kp, symmetric = TRUE)
polydf = tibble(
  x=Ep$vectors[,1]*Ep$values[1],
  y=Ep$vectors[,2]*Ep$values[2],
  z = df_spiral$z)
kg = exp(-as.matrix(dist(df_spiral[,1:2]))^2 / .1)
Kg = I_M %*% kg %*% I_M
Eg = eigen(Kg, symmetric = TRUE)
gaussdf = tibble(
  x=Eg$vectors[,1]*Eg$values[1],
  y=Eg$vectors[,2]*Eg$values[2],
  z = df_spiral$z)
dfkern = bind_rows(df_spiral, df_spiral2, polydf, gaussdf)
dfkern$method = rep(c('data','pca','kpoly (d=2)', 'kgauss (gamma=.1)'), each=n)


## ----plot-kpca, echo=FALSE, fig.align='center', fig.height=6, fig.width=10---------------
dfkern %>% 
  ggplot(aes(x=x,y=y,color=z)) + geom_point() + theme_cowplot()+
  facet_wrap(~method, scales='free', nrow=2) +
  scale_color_viridis_c() + theme(legend.position = 'none') +
  ylab('x2') + xlab('x1')

