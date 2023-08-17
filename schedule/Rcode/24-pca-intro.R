## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ---- echo=FALSE, fig.align='center', fig.width=10, fig.height=5-------------------------
df = data.frame(x1=rep(rnorm(20,sd=1),3),x2=rep(rnorm(20,sd=.2),3),
                lab = rep(c('data','x2 only','x1 only'),each=20))
df[21:40,1] = 0
df[41:60,2] = 0
ggplot(df,aes(x1,x2,color=lab)) + geom_point() + 
  coord_cartesian(c(-2,2), c(-2,2)) +
  scale_color_manual(values=c(blue,orange,green)) +
  theme_cowplot() + facet_wrap(~lab) +
  theme(legend.title = element_blank(), legend.position = 'none')


## ---- echo=FALSE, fig.align='center', fig.width=10, fig.height=4-------------------------
library(UBCstat406labs)
theta = -pi/4
R = matrix(c(cos(theta),sin(theta),-sin(theta),cos(theta)),2)
X = as.matrix(df[1:20,1:2]) %*% R
df2 = data.frame(x1=rep(X[,1],3),x2=rep(X[,2],3),
                lab = rep(c('data','x2 only','x1 only'),each=20))
df2[21:40,1] = 0
df2[41:60,2] = 0
ggplot(df2,aes(x1,x2,color=lab)) + geom_point() + 
  scale_color_manual(values=c(blue,orange,green)) +
  coord_cartesian(c(-2,2), c(-2,2)) +
  theme_cowplot() + facet_wrap(~lab) +
  theme(legend.title = element_blank(), legend.position = 'none')


## ---- echo=FALSE, fig.align='center',fig.width=10,fig.height=4---------------------------
df3 = bind_rows(df,df2)
df3$version = rep(c('original','rotated'),each=60)
df3 %>% 
  ggplot(aes(x1,x2,color=lab)) + geom_point() + 
  scale_color_manual(values=c(blue,orange,green)) +
  coord_cartesian(c(-2,2),c(-2,2)) + 
  facet_grid(~version) + theme_cowplot() +
  theme(legend.title = element_blank(), legend.position = 'bottom')


## ----pca-leaf----------------------------------------------------------------------------
data(leaf)
X = leaf %>% dplyr::select(Eccentricity:Entropy)
pca = prcomp(X, scale=TRUE) ## DON'T USE princomp()


## ----pca-leaf-plot, fig.align='center',fig.height=3,fig.width=10,echo=FALSE--------------
proj_pca <- as.matrix(X) %*% pca$rotation[,1:2] %>% scale() %>% as_tibble()
proj_pca$species = as.factor(leaf$Species)
g1 = ggplot(proj_pca, aes(PC1,PC2,color=species)) + 
  geom_point() + theme_cowplot() + theme(legend.position = 'none') +
  scale_color_viridis_d()
g2 = ggplot(tibble(var_explained=pca$sdev/sum(pca$sdev), M=1:ncol(X)),
            aes(M, var_explained))+ geom_point(color=orange) + 
  geom_segment(aes(xend=M,yend=0), color=blue) + theme_cowplot()
plot_grid(g1,g2)

