## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----embeddings, echo=FALSE,include=FALSE,fig.width=16,fig.height=9----------------------
library(maniTools)
num_pts = 600
d = 2   #target dimension
k = 8   #k nearest neighbors
sim_data <- swiss_roll(num_pts)
pca_dr <- sim_data$data %>% center_and_standardise() %>% prcomp()
proj_pca <- sim_data$data %*% pca_dr$rotation[,1:2] %>% scale()
proj_hess <- Hessian_LLE(sim_data$data, k = k, d = d)$projection %>% scale()
proj_LLE <- LLE2(sim_data$data, dim = d, k = k) %>% scale()
all = cbind(rbind(proj_pca, proj_LLE, proj_hess), sim_data$colors)
colnames(all) = c('x','y','col')
all = as_tibble(all)
all$method = rep(c("pca","hessian maps","LLE"), each=num_pts) 
ggplot(all, aes(x,y,color=col)) + geom_point() + scale_color_viridis_c() +
  facet_wrap(~method, scales="free") + theme_cowplot() +
  theme(legend.position = "none", 
        axis.line = element_blank(), axis.text = element_blank(),
        axis.ticks = element_blank(), axis.title = element_blank())

