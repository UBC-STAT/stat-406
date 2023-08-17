## ----setup, include=FALSE----------------------------------------------------------------
source("rmd_config.R")


## ----sampling, eval=FALSE----------------------------------------------------------------
## p = 3
## n = 100
## sigma = 2


## ----sampling-2, eval=FALSE--------------------------------------------------------------
## epsilon = rnorm(n,sd=sigma) # this is random
## X = matrix(runif(n*p), n, p) # treat this as fixed, but I need numbers
## beta = rpois(p+1, 5) # parameter, also fixed, but I again need numbers
## Y = cbind(1,X) %*% beta + epsilon # epsilon is random, so this is
## ## Equiv: Y = beta[1] + X %*% beta[-1] + epsilon

