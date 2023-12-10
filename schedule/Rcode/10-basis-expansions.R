## -------------------------------------------------------------------------------
#| code-fold: true
set.seed(406406)
data(arcuate, package = "Stat406") 
arcuate <- arcuate |> slice_sample(n = 220)
arcuate %>% 
  ggplot(aes(position, fa)) + 
  geom_point(color = blue) +
  geom_smooth(color = orange, formula = y ~ poly(x, 3), method = "lm", se = FALSE)


## -------------------------------------------------------------------------------
#| code-fold: true
arcuate %>% 
  ggplot(aes(position, fa)) + 
  geom_point(color = blue) + 
  geom_smooth(aes(color = "a"), formula = y ~ poly(x, 4), method = "lm", se = FALSE) +
  geom_smooth(aes(color = "b"), formula = y ~ poly(x, 7), method = "lm", se = FALSE) +
  geom_smooth(aes(color = "c"), formula = y ~ poly(x, 25), method = "lm", se = FALSE) +
  scale_color_manual(name = "Taylor order",
    values = c(green, red, orange), labels = c("4 terms", "7 terms", "25 terms"))


## -------------------------------------------------------------------------------
max_deg <- 20
cv_nice <- function(mdl) mean( residuals(mdl)^2 / (1 - hatvalues(mdl))^2 ) 
cvscores <- map_dbl(seq_len(max_deg), ~ cv_nice(lm(fa ~ poly(position, .), data = arcuate)))


## -------------------------------------------------------------------------------
#| code-fold: true
library(cowplot)
g1 <- ggplot(tibble(cvscores, degrees = seq(max_deg)), aes(degrees, cvscores)) +
  geom_point(colour = blue) +
  geom_line(colour = blue) + 
  labs(ylab = 'LOO-CV', xlab = 'polynomial degree') +
  geom_vline(xintercept = which.min(cvscores), linetype = "dotted") 
g2 <- ggplot(arcuate, aes(position, fa)) + 
  geom_point(colour = blue) + 
  geom_smooth(
    colour = orange, 
    formula = y ~ poly(x, which.min(cvscores)), 
    method = "lm", 
    se = FALSE
  )
plot_grid(g1, g2, ncol = 2)


## ----simulation-----------------------------------------------------------------
library(glmnet)
mapto01 <- function(x, pad = .005) (x - min(x) + pad) / (max(x) - min(x) + 2 * pad)
x <- mapto01(arcuate$position)
Xmat <- cbind(
  poly(x, 20), 
  splines::bs(x, df = 20), 
  cos(2 * pi * outer(x, 1:20)), sin(2 * pi * outer(x, 1:20))
)
y <- arcuate$fa
rmse <- function(z, s) sqrt(mean( (z - s)^2 ))
nzero <- function(x) with(x, nzero[match(lambda.1se, lambda)])
sim <- function(maxdeg = 20, train_frac = 0.75) {
  n <- nrow(arcuate)
  train <- as.logical(rbinom(n, 1, train_frac))
  test <- !train # not precisely 25%, but on average
  polycv <- map_dbl(seq(maxdeg), ~ cv_nice(lm(y ~ Xmat[,seq(.)], subset = train))) # figure out which order to use
  bpoly <- lm(y[train] ~ Xmat[train, seq(which.min(polycv))]) # now use it
  lasso <- cv.glmnet(Xmat[train, ], y[train])
  ridge <- cv.glmnet(Xmat[train, ], y[train], alpha = 0)
  elnet <- cv.glmnet(Xmat[train, ], y[train], alpha = .5)
  tibble(
    methods = c("poly", "lasso", "ridge", "elnet"),
    rmses = c(
      rmse(y[test], cbind(1, Xmat[test, 1:which.min(polycv)]) %*% coef(bpoly)),
      rmse(y[test], predict(lasso, Xmat[test,])),
      rmse(y[test], predict(ridge, Xmat[test,])),
      rmse(y[test], predict(elnet, Xmat[test,]))
    ),
    nvars = c(which.min(polycv), nzero(lasso), nzero(ridge), nzero(elnet))
  )
}
set.seed(12345)
sim_results <- map(seq(20), sim) |> list_rbind() # repeat it 20 times


## ----sim-results----------------------------------------------------------------
#| code-fold: true
sim_results |>  
  pivot_longer(-methods) |> 
  ggplot(aes(methods, value, fill = methods)) + 
  geom_boxplot() +
  facet_wrap(~ name, scales = "free_y") + 
  ylab("") +
  theme(legend.position = "none") + 
  xlab("") +
  scale_fill_viridis_d(begin = .2, end = 1)

