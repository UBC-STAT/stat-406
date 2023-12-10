## ----plotting-functions---------------------------------------------------------
#| code-fold: true
#| fig-width: 12
#| fig-height: 6
library(mvtnorm)
normBall <- function(q = 1, len = 1000) {
  tg <- seq(0, 2 * pi, length = len)
  out <- data.frame(x = cos(tg)) %>%
    mutate(b = (1 - abs(x)^q)^(1 / q), bm = -b) %>%
    gather(key = "lab", value = "y", -x)
  out$lab <- paste0('"||" * beta * "||"', "[", signif(q, 2), "]")
  return(out)
}

ellipseData <- function(n = 100, xlim = c(-2, 3), ylim = c(-2, 3),
                        mean = c(1, 1), Sigma = matrix(c(1, 0, 0, .5), 2)) {
  df <- expand.grid(
    x = seq(xlim[1], xlim[2], length.out = n),
    y = seq(ylim[1], ylim[2], length.out = n)
  )
  df$z <- dmvnorm(df, mean, Sigma)
  df
}

lballmax <- function(ed, q = 1, tol = 1e-6) {
  ed <- filter(ed, x > 0, y > 0)
  for (i in 1:20) {
    ff <- abs((ed$x^q + ed$y^q)^(1 / q) - 1) < tol
    if (sum(ff) > 0) break
    tol <- 2 * tol
  }
  best <- ed[ff, ]
  best[which.max(best$z), ]
}

nbs <- list()
nbs[[1]] <- normBall(0, 1)
qs <- c(.5, .75, 1, 1.5, 2)
for (ii in 2:6) nbs[[ii]] <- normBall(qs[ii - 1])
nbs <- bind_rows(nbs)
nbs$lab <- factor(nbs$lab, levels = unique(nbs$lab))
seg <- data.frame(
  lab = levels(nbs$lab)[1],
  x0 = c(-1, 0), x1 = c(1, 0), y0 = c(0, -1), y1 = c(0, 1)
)
levels(seg$lab) <- levels(nbs$lab)
ggplot(nbs, aes(x, y)) +
  geom_path(size = 1.2) +
  facet_wrap(~lab, labeller = label_parsed) +
  geom_segment(data = seg, aes(x = x0, xend = x1, y = y0, yend = y1), size = 1.2) +
  theme_bw(base_family = "", base_size = 24) +
  coord_equal() +
  scale_x_continuous(breaks = c(-1, 0, 1)) +
  scale_y_continuous(breaks = c(-1, 0, 1)) +
  geom_vline(xintercept = 0, size = .5) +
  geom_hline(yintercept = 0, size = .5) +
  xlab(bquote(beta[1])) +
  ylab(bquote(beta[2]))


## -------------------------------------------------------------------------------
#| code-fold: true
nb <- normBall(1)
ed <- ellipseData()
bols <- data.frame(x = 1, y = 1)
bhat <- lballmax(ed, 1)
ggplot(nb, aes(x, y)) +
  geom_path(colour = red) +
  geom_contour(mapping = aes(z = z), colour = blue, data = ed, bins = 7) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  geom_point(data = bols) +
  coord_equal(xlim = c(-2, 2), ylim = c(-2, 2)) +
  theme_bw(base_family = "", base_size = 24) +
  geom_label(
    data = bols, mapping = aes(label = bquote("hat(beta)[ols]")), parse = TRUE,
    nudge_x = .3, nudge_y = .3
  ) +
  geom_point(data = bhat) +
  xlab(bquote(beta[1])) +
  ylab(bquote(beta[2])) +
  geom_label(
    data = bhat, mapping = aes(label = bquote("hat(beta)[s]^L")), parse = TRUE,
    nudge_x = -.4, nudge_y = -.4
  )


## ----ridge-v-lasso--------------------------------------------------------------
#| code-fold: true
library(glmnet)
data(prostate, package = "ElemStatLearn")
X <- prostate |> dplyr::select(-train, -lpsa) |>  as.matrix()
Y <- prostate$lpsa
lasso <- glmnet(x = X, y = Y) # alpha = 1 by default
ridge <- glmnet(x = X, y = Y, alpha = 0)
op <- par()


## -------------------------------------------------------------------------------
par(mfrow = c(1, 2), mar = c(5, 3, 5, .1))
plot(lasso, main = "Lasso")
plot(ridge, main = "Ridge")


## -------------------------------------------------------------------------------
#| echo: false
par(op)


## ----tidy-glmnet----------------------------------------------------------------
#| include: false
#| eval: false
## df <- data.frame(as.matrix(t(ridge$beta)))
## df1 <- data.frame(as.matrix(t(lasso$beta)))
## df$l1norm <- colSums(abs(ridge$beta))
## df1$l1norm <- colSums(abs(lasso$beta))
## df$method <- "ridge"
## df1$method <- "lasso"
## bind_rows(df, df1) %>%
##   pivot_longer(
##     names_to = "predictor", values_to = "coefficient",
##     cols = -c(l1norm, method)
##   ) %>%
##   ggplot(aes(x = l1norm, y = coefficient, colour = predictor)) +
##   geom_path() +
##   facet_wrap(~method, scales = "free_x") +
##   geom_hline(colour = "black", linetype = "dotted", yintercept = 0) +
##   scale_colour_brewer(palette = "Set1")


## ----ridge-v-lasso-again--------------------------------------------------------
par(mfrow = c(1, 2), mar = c(5, 3, 5, .1))
plot(lasso, main = "Lasso", xvar = "lambda")
plot(ridge, main = "Ridge", xvar = "lambda")


## -------------------------------------------------------------------------------
#| echo: false
par(op)


## -------------------------------------------------------------------------------
#| code-line-numbers: 1|2|3|4|5|
lasso <- cv.glmnet(X, Y) # estimate full model and CV no good reason to call glmnet() itself
# 2. Look at the CV curve. If the dashed lines are at the boundaries, redo and adjust lambda
lambda_min <- lasso$lambda.min # the value, not the location (or use lasso$lambda.1se)
coeffs <- coefficients(lasso, s = "lambda.min") # s can be string or a number
preds <- predict(lasso, newx = X, s = "lambda.1se") # must supply `newx`


## -------------------------------------------------------------------------------
par(mfrow = c(1, 2), mar = c(5, 3, 3, 0))
plot(lasso) # a plot method for the cv fit
plot(lasso$glmnet.fit) # the glmnet.fit == glmnet(X,Y)
abline(v = colSums(abs(coef(lasso$glmnet.fit)[-1, drop(lasso$index)])), lty = 2)


## ----include=FALSE--------------------------------------------------------------
par(op)


## ----fig.width=11,fig.align="center",dev="svg",fig.height=4---------------------
ridge <- cv.glmnet(X, Y, alpha = 0, lambda.min.ratio = 1e-10) # added to get a minimum
par(mfrow = c(1, 4))
plot(ridge, main = "Ridge")
plot(lasso, main = "Lasso")
plot(ridge$glmnet.fit, main = "Ridge")
abline(v = sum(abs(coef(ridge)))) # defaults to `lambda.1se`
plot(lasso$glmnet.fit, main = "Lasso")
abline(v = sum(abs(coef(lasso)))) # again, `lambda.1se` unless told otherwise

