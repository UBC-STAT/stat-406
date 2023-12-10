## ----eval=FALSE-----------------------------------------------------------------
## logistic <- glm(y ~ ., dat, family = "binomial")


## ----eval=FALSE-----------------------------------------------------------------
## lasso_logit <- cv.glmnet(x, y, family = "binomial")
## ridge_logit <- cv.glmnet(x, y, alpha = 0, family = "binomial")
## gam_logit <- gam(y ~ s(x), data = dat, family = "binomial")


## ----simple-lda, echo=FALSE-----------------------------------------------------
library(mvtnorm)
library(MASS)
generate_lda_2d <- function(
    n, p = c(.5, .5),
    mu = matrix(c(0, 0, 1, 1), 2),
    Sigma = diag(2)) {
  X <- rmvnorm(n, sigma = Sigma)
  tibble(
    y = which(rmultinom(n, 1, p) == 1, TRUE)[, 1],
    x1 = X[, 1] + mu[1, y],
    x2 = X[, 2] + mu[2, y]
  )
}


## -------------------------------------------------------------------------------
dat1 <- generate_lda_2d(100, Sigma = .5 * diag(2))
logit <- glm(y ~ ., dat1 |> mutate(y = y - 1), family = "binomial")
summary(logit)


## ----plot-d1--------------------------------------------------------------------
#| code-fold: true
#| fig-width: 8
#| fig-height: 5
gr <- expand_grid(x1 = seq(-2.5, 3, length.out = 100), 
                  x2 = seq(-2.5, 3, length.out = 100))
pts <- predict(logit, gr)
g0 <- ggplot(dat1, aes(x1, x2)) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = tibble(gr, disc = pts), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_steps2(n.breaks = 6, name = "log odds") 
g0


## -------------------------------------------------------------------------------
logit_irwls <- function(y, x, maxit = 100, tol = 1e-6) {
  p <- ncol(x)
  beta <- double(p) # initialize coefficients
  beta0 <- 0
  conv <- FALSE # hasn't converged
  iter <- 1 # first iteration
  while (!conv && (iter < maxit)) { # check loops
    iter <- iter + 1 # update first thing (so as not to forget)
    eta <- beta0 + x %*% beta
    mu <- 1 / (1 + exp(-eta))
    gp <- 1 / (mu * (1 - mu)) # inverse of derivative of logistic
    z <- eta + (y - mu) * gp # effective transformed response
    beta_new <- coef(lm(z ~ x, weights = 1 / gp)) # do Weighted Least Squares
    conv <- mean(abs(c(beta0, beta) - betaNew)) < tol # check if the betas are "moving"
    beta0 <- betaNew[1] # update betas
    beta <- betaNew[-1]
  }
  return(c(beta0, beta))
}

