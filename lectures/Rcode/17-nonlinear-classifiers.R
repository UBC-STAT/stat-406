## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----simple-lda, echo=FALSE--------------------------------------------------------------
library(mvtnorm)
library(MASS)
generate_lda <- function(
  n, p=c(.5,.5), 
  mumat=matrix(c(0,0,1,1),2),
  Sigma=diag(2)){
  X = rmvnorm(n, sigma=Sigma)
  tibble(
    y=apply(rmultinom(n,1,p) > 0, 2, which)-1,
    x1 = X[,1] + mumat[1,y+1],
    x2 = X[,2] + mumat[2,y+1])
}


## ----------------------------------------------------------------------------------------
dat1 = generate_lda(100, Sigma = .5*diag(2))
logit_poly = glm(y~x1*x2 + I(x1^2) + I(x2^2), dat1, family="binomial")
lda_poly = lda(y~x1*x2 + I(x1^2) + I(x2^2), dat1)


## ----plot-d1, fig.align='center', fig.width=11, fig.height=7, dev='png',dvi=300,echo=FALSE----
gr = expand_grid(x1=seq(-2.5,3,length.out = 100),x2=seq(-2.5,3,length.out=100))
pts_logit = predict(logit_poly, gr)
pts_lda = predict(lda_poly, gr)
g0=ggplot(dat1, aes(x1,x2)) + 
  scale_shape_manual(values=c("0","1"), guide="none") +
  geom_raster(data=tibble(gr,disc=pts_logit), aes(x1,x2,fill=disc)) +
  geom_point(aes(shape=as.factor(y)), size=4) +
  coord_cartesian(c(-2.5,3),c(-2.5,3)) +
  scale_fill_viridis_b(n.breaks=6,alpha=.5,name="log odds") +
  theme_cowplot() + ggtitle("Polynomial logit") +
  theme(legend.position = "bottom", legend.key.width=unit(2,"cm"))
g1=ggplot(dat1, aes(x1,x2)) + 
  scale_shape_manual(values=c("0","1"), guide="none") +
  geom_raster(data=tibble(gr,disc=pts_lda$x), aes(x1,x2,fill=disc)) +
  geom_point(aes(shape=as.factor(y)), size=4) +
  coord_cartesian(c(-2.5,3),c(-2.5,3)) +
  scale_fill_viridis_b(n.breaks=6,alpha=.5,name=bquote(delta[1]-delta[0])) +
  theme_cowplot() + ggtitle("Polynomial lda") +
  theme(legend.position = "bottom", legend.key.width=unit(2,"cm"))
plot_grid(g0,g1)


## ----bake-it, echo=FALSE-----------------------------------------------------------------
data(gbbakeoff, package="UBCstat406labs")
gbbakeoff = gbbakeoff[complete.cases(gbbakeoff),]
library(tree)
library(maptree)


## ----glimpse-bakers, R.options = list(width = 50)----------------------------------------
gbbakeoff[FALSE,]


## ----our-partition-----------------------------------------------------------------------
smalltree = tree(
  winners~technical_median+percent_star, 
  data = gbbakeoff)


## ----plot-partition, echo=FALSE, fig.align="center", fig.height=5, fig.width=5-----------
plot(gbbakeoff$technical_median, gbbakeoff$percent_star, 
     pch=c("-","+")[gbbakeoff$winners+1], cex=1, bty='n',las=1,
     ylab="% star baker",xlab="times above median in technical",
     col=orange)
partition.tree(smalltree, add=TRUE, col=blue,
               ordvars = c("technical_median","percent_star"))


## ----------------------------------------------------------------------------------------
library(class)
knn3 = knn(dat1[,-1], gr, dat1$y, k=3)


## ---- fig.align="center", fig.width=10, fig.height=6, dev='png',dvi=300,echo=FALSE-------
gr$nn03 = knn3
ggplot(dat1, aes(x1,x2)) + 
  scale_shape_manual(values=c("0","1"), guide="none") +
  geom_raster(data=tibble(gr,disc=knn3), aes(x1,x2,fill=disc)) +
  geom_point(aes(shape=as.factor(y)), size=4) +
  coord_cartesian(c(-2.5,3),c(-2.5,3)) +
  scale_fill_manual(values=c(orange,green)) +
  theme_cowplot() + 
  theme(legend.position = "bottom", legend.title=element_blank(),
        legend.key.width=unit(2,"cm"))


## ---- fig.align="center",fig.width=10, fig.height=6, dev='png',dvi=300,echo=FALSE--------
gr$nn01 = knn(dat1[,-1], gr[,1:2], dat1$y, k=1)
gr$nn02 = knn(dat1[,-1], gr[,1:2], dat1$y, k=2)
gr$nn05 = knn(dat1[,-1], gr[,1:2], dat1$y, k=5)
gr$nn10 = knn(dat1[,-1], gr[,1:2], dat1$y, k=10)
gr$nn20 = knn(dat1[,-1], gr[,1:2], dat1$y, k=20)
pg = pivot_longer(gr, names_to='k',values_to = 'knn',-c(x1,x2))

ggplot(pg, aes(x1,x2)) + geom_raster(aes(fill=knn)) +
  facet_wrap(~k,labeller = label_both) + 
  scale_fill_manual(values=c(orange,green)) +
  geom_point(data=dat1,mapping=aes(x1,x2,shape=as.factor(y)), size=4) +
  scale_shape_manual(values=c("0","1"), guide="none") +
  coord_cartesian(c(-2.5,3),c(-2.5,3)) +
  theme_cowplot() + 
  theme(legend.position = "bottom", legend.title=element_blank(),
        legend.key.width=unit(2,"cm"))


## ----------------------------------------------------------------------------------------
kmax = 20
err = double(kmax)
for(ii in 1:kmax){
  pk = knn.cv(dat1[,-1],dat1$y, k=ii) # does leave one out CV
  err[ii] = mean(pk != dat1$y)
}


## ---- fig.width=10, fig.height=4, fig.align="center", echo=FALSE-------------------------
ggplot(data.frame(k=1:kmax, error=err), aes(k,error)) + geom_point(color=red) +
  geom_line(color=red) + theme_cowplot()


## ----fig.align="center",fig.width=5, fig.height=5, dev='png',dvi=300,echo=FALSE----------
kkk = which.min(err)
gr$opt = knn(dat1[,-1], gr[,1:2], dat1$y, k=kkk)
ggplot(dat1, aes(x1,x2)) + 
  scale_shape_manual(values=c("0","1"), guide="none") +
  geom_raster(data=gr, aes(x1,x2,fill=opt)) +
  geom_point(aes(shape=as.factor(y)), size=4) +
  coord_cartesian(c(-2.5,3),c(-2.5,3)) +
  scale_fill_manual(values=c(orange,green)) +
  theme_cowplot() + 
  theme(legend.position = "bottom", legend.title=element_blank(),
        legend.key.width=unit(2,"cm"))
tt <- table(knn(dat1[,-1],dat1[,-1],dat1$y,k=kkk),dat1$y, dnn=c('predicted','truth'))


## ----echo=FALSE--------------------------------------------------------------------------
knitr::kable(tt)

