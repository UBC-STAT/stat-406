## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----------------------------------------------------------------------------------------
library(mvtnorm)
X1 = rmvnorm(50,c(-1,2),sigma=matrix(c(1,.5,.5,1),2))
X2 = rmvnorm(40,c(2,-1),sigma=matrix(c(1.5,.5,.5,1.5),2))


## ----plotting-dumb-clusts, echo=FALSE, fig.align="center", fig.width=10,fig.height=5-----
clust_raw = rbind(X1,X2)
clust = tibble(x1=clust_raw[,1], x2=clust_raw[,2],
               true = as.factor(rep(c(1,2), times=c(50,40))))
clust %>% ggplot(aes(x=x1,y=x2,color=true)) + geom_point() +
  theme_cowplot() + scale_color_manual(values = c(orange,blue)) +
  theme(legend.position = "none")


## ---- echo=FALSE, fig.align='center',fig.width=10,fig.height=5---------------------------
K = 2:40
all_clusters <- lapply(K, FUN = function(x){
  out = kmeans(clust_raw, x)
  list(assignments = out$cluster, withinss = out$tot.withinss,
              betweenss = out$betweenss)
})
all_assignments = sapply(all_clusters, FUN = function(x) as.factor(x$assignments))
summaries = sapply(all_clusters, FUN = function(x) c(x$withinss, x$betweenss))
summaries = tibble('within'=summaries[1,],'between'=summaries[2,],'K'=K) %>% 
  mutate(CH = (between/(K-1))/(within/(nrow(clust_raw)-K)))
summaries %>% gather(key='key',value='value',-K) %>%
  ggplot(aes(K,value)) + geom_line(color=blue) + ylab('')+
  coord_cartesian(c(1,20)) +
  facet_wrap(~key,ncol=3,scales='free_y') + theme_cowplot()


## ---- echo=FALSE,fig.align='center',fig.width=10,fig.height=5----------------------------
all_assignments = all_assignments %>% as_tibble()
names(all_assignments) = paste0('K = ',K)
small_assignments = all_assignments[,c(1,2,4,9,14,19,29,39)]
bind_cols(small_assignments, clust) %>% 
  gather(key='key',value='value',-x1,-x2) %>%
  ggplot(aes(x1,x2,color=value)) + geom_point() + facet_wrap(~key) +
  theme_cowplot() + theme(legend.position = 'none') +
  scale_color_viridis_d()

