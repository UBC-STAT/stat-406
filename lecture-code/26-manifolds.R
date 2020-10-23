## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----echo=FALSE, fig.align='center',fig.height=4,fig.width=4-----------------------------
quad <- function(x) x^2
ggplot(data.frame(x=c(-1,1)), aes(x)) + stat_function(fun=quad, color=blue) +
  geom_abline(slope = 1, intercept = -.25, color=red) + theme_cowplot()


## ----elephant, echo=FALSE, fig.align='center',fig.width=8,fig.height=5-------------------
tt = -100:500/100
elephant <- function(tt,eye=TRUE){
  x = 12*cos(3*tt) - 14*cos(5*tt) + 50*sin(tt) + 18*sin(2*tt)
  y = -30*sin(tt) + 8*sin(2*tt) - 10*sin(3*tt) - 60*cos(tt)
  if(eye) return(data.frame(y=c(y,20),x=c(-x,20)))
  else return(data.frame(y=y,x=-x))
}
ele = elephant(tt,FALSE)
ele$tt = tt
noisy_ele = ele %>% mutate(y=y+rnorm(nrow(ele),0,5), x=x+rnorm(nrow(ele),0,5))

ggplot(noisy_ele, aes(x=y,y=x,col=tt)) + geom_point() + 
  theme_cowplot() + scale_color_viridis_c() + 
  theme(legend.position = 'none') +
  geom_path(data=ele, aes(x=y,y=x), color="black",size=2)


## ----manifold-meths----------------------------------------------------------------------
library(maniTools)
elef = noisy_ele[,1:2]
pca = elef %>% center_and_standardise() %>% prcomp()
pca = as.matrix(elef) %*% pca$rotation[,1:2] 
cmds = cmdscale(dist(elef), k = 2) 
le = Laplacian_Eigenmaps(elef, 5, 2)$eigenvectors 


## ----mani-plots, echo=FALSE,fig.align='center',fig.width=10,fig.height=4.5---------------
names(pca) = NULL
all = cbind(rbind(as.matrix(elef), pca, cmds, le), noisy_ele$tt)
colnames(all) = c('y','x','col')
all = as_tibble(all)
all$method = rep(c("data","pca","cmds","le"), each=nrow(elef)) 
ggplot(all, aes(y,x,color=col)) + geom_point() + scale_color_viridis_c() +
  facet_wrap(~method, scales="free", ncol = 4) + theme_cowplot() +
  theme(legend.position = "none", 
        axis.line = element_blank(), axis.text = element_blank(),
        axis.ticks = element_blank(), axis.title = element_blank())

