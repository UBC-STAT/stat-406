## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----load-lidar, echo=FALSE--------------------------------------------------------------
data(lidar, package="UBCstat406labs")
set.seed(12345)
lidar_unif = lidar[sample.int(nrow(lidar), 40),] %>% arrange(range)
pt = 15
nn = 3
neibs = sort.int(abs(lidar_unif$range-lidar_unif$range[pt]), 
                     index.return = TRUE)$ix[1:nn]
lidar_unif$neighbors = 1:40 %in% neibs
g1 = ggplot(lidar_unif, aes(range,logratio,color=neighbors)) + geom_point() +
  scale_color_manual(values = c(blue,red)) + theme_cowplot() +
  geom_vline(xintercept = lidar_unif$range[pt], color=red) + 
  annotate("rect", fill=red, alpha=.25, ymin=-Inf, ymax=Inf,
           xmin=min(lidar_unif$range[neibs]), xmax = max(lidar_unif$range[neibs])) +
  theme(legend.position = "none")
g2 = ggplot(lidar_unif, aes(range,logratio)) + geom_point(color=blue) + 
  theme_cowplot() + 
  geom_line(data=tibble(
    range=seq(min(lidar_unif$range),max(lidar_unif$range),length.out = 101),
    logratio=FNN::knn.reg(
      lidar_unif$range,matrix(range,ncol=1),y=lidar_unif$logratio)$pred), color=orange)
plot_grid(g1,g2,nrow=2)


## ----small-lidar-again, echo=FALSE-------------------------------------------------------
g2


## ---- fig.height = 4, fig.align='center', fig.width=8, echo=FALSE,fig.height=4-----------
ggplot(lidar_unif, aes(range, logratio)) + geom_point(color=blue) + 
  coord_cartesian(ylim=c(-1,0)) + theme_cowplot() +
  geom_segment(aes(x=range[15],y=-1,xend=range[15],yend=logratio[15]),color=blue) + 
  geom_segment(aes(x=range[25],y=-1,xend=range[25],yend=logratio[25]),color=green) +
  geom_rect(aes(xmin=range[15]-15,xmax=range[15]+15,ymin=-1,ymax=-.7),fill=blue) +
  geom_rect(aes(xmin=range[25]-15,xmax=range[25]+15,ymin=-1,ymax=-.7),fill=green)


## ----boxcar, fig.width=8, fig.height=3, echo=FALSE, fig.align="center"-------------------
testpts = seq(min(lidar_unif$range),max(lidar_unif$range),length.out = 101)
dmat = abs(outer(testpts, lidar_unif$range, "-"))
S = (dmat*(dmat<15))
S = S / rowSums(S)
boxcar = tibble(range=testpts, logratio=S %*% lidar_unif$logratio)
ggplot(lidar_unif, aes(range, logratio)) + geom_point(color=blue) + 
  theme_cowplot() +
  geom_line(data=boxcar,color=orange)


## ---- fig.height = 4, fig.align='center', fig.width=6, echo=FALSE------------------------
gaussian_kernel = function(x) dnorm(x, mean=lidar_unif$range[15],sd=7.5)*3
ggplot(lidar_unif, aes(range, logratio+1)) + geom_point(color=blue) + 
  coord_cartesian(ylim=c(0,1)) + theme_cowplot() +
  geom_segment(aes(x=range[15],y=0,xend=range[15],yend=logratio[15]+1),color=orange)+
  stat_function(fun=gaussian_kernel, geom="area",fill=orange)


## ---- fig.height = 4, fig.align='center', fig.width=6, echo=FALSE------------------------
gaussian_kernel = function(x) dnorm(x, mean=lidar_unif$range[15],sd=15)*3
ggplot(lidar_unif, aes(range, logratio+1)) + geom_point(color=blue) + 
  coord_cartesian(ylim=c(0,1)) + theme_cowplot() +
  geom_segment(aes(x=range[15],y=0,xend=range[15],yend=logratio[15]+1),color=orange)+
  stat_function(fun=gaussian_kernel, geom="area",fill=orange)
x = lidar_unif$range


## ---- eval=FALSE-------------------------------------------------------------------------
## dmat = as.matrix(dist(x))
## Sgauss <- function(sigma){
##   gg = exp(-dmat^2/(2*sigma^2)) / (sigma * sqrt(2*pi))
##   sweep(gg, 1, rowSums(gg),'/')
## }


## ---- fig.height = 4, fig.align='center', fig.width=8, echo=FALSE------------------------
Sgauss <- function(sigma){
  gg = exp(-dmat^2/(2*sigma^2)) / (sigma * sqrt(2*pi))
  sweep(gg, 1, rowSums(gg),'/')
}
boxcar$S15 = with(lidar_unif, Sgauss(15) %*% logratio)
boxcar$S08 = with(lidar_unif, Sgauss(8) %*% logratio)
boxcar$S30 = with(lidar_unif, Sgauss(30) %*% logratio)
bc = boxcar %>% select(range, S15,S08,S30) %>% 
  pivot_longer(-range, names_to = "Sigma")
ggplot(lidar_unif, aes(range, logratio)) + 
  geom_point(color=blue) + 
  geom_line(data=bc, aes(range, value, color=Sigma)) +
  scale_color_brewer(palette="Set1") +
  theme_cowplot()


## ----------------------------------------------------------------------------------------
epan <- function(x) 3/4*(1-x^2)*(abs(x)<1)


## ----fig.height=3, fig.width=8, fig.align='center', echo=FALSE---------------------------
ggplot(data.frame(x=c(-2,2)), aes(x)) + stat_function(fun=epan,color=green) +
  theme_cowplot()


## ----------------------------------------------------------------------------------------
loocv <- function(y, S){
  yhat = S %*% y
  cv = mean( (y-yhat)^2 / (1 - diag(S))^2 )
  cv
}


## ---- echo=FALSE-------------------------------------------------------------------------
dmat = as.matrix(dist(lidar$range))
loocvs = double(100)
sigmas = exp(seq(log(300), log(.3), length=100))
for(i in 1:100){
  S = Sgauss(sigmas[i])
  loocvs[i] = loocv(lidar$logratio, S)
}
bests = which.min(loocvs)
lidar$smoothed = Sgauss(sigmas[bests]) %*% lidar$logratio


## ----smoothed-lidar, echo=FALSE, fig.width=10, fig.height=5,fig.align="center"-----------
g3 = ggplot(data.frame(sigma=sigmas, loocv=loocvs), aes(sigma,loocv)) + 
  geom_point(color=blue) + geom_vline(xintercept=sigmas[bests], color=red) +
  scale_x_log10() + theme_cowplot()
g4 = ggplot(lidar, aes(range, logratio)) + geom_point(color=blue) +
  geom_line(aes(y=smoothed), color=orange, size=2) + theme_cowplot()
plot_grid(g3,g4,nrow=1)

