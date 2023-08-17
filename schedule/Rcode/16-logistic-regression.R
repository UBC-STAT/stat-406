## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----eval=FALSE--------------------------------------------------------------------------
## logistic = glm(y~., dat, family="binomial")


## ----eval=FALSE--------------------------------------------------------------------------
## lasso_logit = cv.glmnet(x, y, family="binomial")
## ridge_logit = cv.glmnet(x, y, alpha=0, family="binomial")


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
logit = glm(y~., dat1, family="binomial")
summary(logit)


## ----plot-d1, fig.align='center', fig.width=7, fig.height=7, dev='png',dvi=300,echo=FALSE----
gr = expand_grid(x1=seq(-2.5,3,length.out = 100),x2=seq(-2.5,3,length.out=100))
pts = predict(logit, gr)
g0=ggplot(dat1, aes(x1,x2)) + 
  scale_shape_manual(values=c("0","1"), guide="none") +
  geom_raster(data=tibble(gr,disc=pts), aes(x1,x2,fill=disc)) +
  geom_point(aes(shape=as.factor(y)), size=4) +
  coord_cartesian(c(-2.5,3),c(-2.5,3)) +
  scale_fill_viridis_b(n.breaks=6,alpha=.5,name="log odds") +
  theme_cowplot() + 
  theme(legend.position = "bottom", legend.key.width=unit(3,"cm"))
g0


## ----------------------------------------------------------------------------------------
logit_irwls <- function(y, x, maxit = 100, tol=1e-6){
  p = ncol(x)
  beta = double(p) # initialize coefficients 
  conv = FALSE # hasn't converged
  iter = 1 # first iteration
  while(!conv && (iter<maxit)){ # check loops
    iter = iter + 1 # update first thing (so as not to forget) 
    eta = x %*% beta 
    mu = exp(eta)/(1+exp(eta))
    gp = 1/(mu*(1-mu)) # evaluate g'(mu)
    z = eta + (y - mu) * gp # effective transformed response
    betaNew = coef(lm(z~x-1, weights=1/gp)) # do weighted regression
    conv = (mean((beta-betaNew)^2)<tol) # check if the betas are "moving" 
    beta = betaNew # update betas
  }
  return(beta) 
}

