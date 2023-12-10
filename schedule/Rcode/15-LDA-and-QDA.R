## -------------------------------------------------------------------------------
set.seed(406406406)
n <- 100
pi <- .6
mu0 <- -1
mu1 <- 2
sigma <- 2
tib <- tibble(
  y = rbinom(n, 1, pi),
  x = rnorm(n, mu0, sigma) * (y == 0) + rnorm(n, mu1, sigma) * (y == 1)
)


## -------------------------------------------------------------------------------
#| code-fold: true
gg <- ggplot(tib, aes(x, y)) +
  geom_point(colour = blue) +
  stat_function(fun = ~ 6 * (1 - pi) * dnorm(.x, mu0, sigma), colour = orange) +
  stat_function(fun = ~ 6 * pi * dnorm(.x, mu1, sigma), colour = orange) +
  annotate("label",
    x = c(-3, 4.5), y = c(.5, 2 / 3),
    label = c("(1-pi)*p[0](x)", "pi*p[1](x)"), parse = TRUE
  )
gg


## ----simple-lda-----------------------------------------------------------------
library(mvtnorm)
library(MASS)
generate_lda_2d <- function(
    n, p = c(.5, .5), 
    mu = matrix(c(0, 0, 1, 1), 2),
    Sigma = diag(2)) {
  X <- rmvnorm(n, sigma = Sigma)
  tibble(
    y = which(rmultinom(n, 1, p) == 1, TRUE)[,1],
    x1 = X[, 1] + mu[1, y],
    x2 = X[, 2] + mu[2, y]
  )
}
dat1 <- generate_lda_2d(100, Sigma = .5 * diag(2))
lda_fit <- lda(y ~ ., dat1)


## ----plot-d1, fig.align='center', fig.width=7, fig.height=7, dev='png', dvi=300, echo=FALSE----
gr <- expand_grid(
  x1 = seq(-2.5, 3, length.out = 100),
  x2 = seq(-2.5, 3, length.out = 100)
)
pts <- predict(lda_fit, gr)
g0 <- ggplot(dat1, aes(x1, x2)) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = tibble(gr, disc = c(pts$x)), aes(x1, x2, fill = disc)) +
  theme_bw(base_size = 24) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_steps2(
    n.breaks = 6,
    name = bquote(delta[1] - delta[0])
  ) +
  theme(legend.position = "bottom", legend.key.width = unit(3, "cm"))
g0


## ----3class-lda-----------------------------------------------------------------
moreclasses <- generate_lda_2d(150, c(.2, .3, .5), matrix(c(0, 0, 1, 1, 1, 0), 2), .5 * diag(2))
separateclasses <- generate_lda_2d(150, c(.2, .3, .5), matrix(c(-1, -1, 2, 2, 2, -1), 2), .1 * diag(2))


## ----3class-plot,echo=FALSE,fig.align='center',fig.height=6,fig.width=12,dev='png',dvi=300----
library(cowplot)
lda_3fit <- lda(y ~ ., moreclasses)
lda_separate <- lda(y ~ ., separateclasses)
pts3 <- predict(lda_3fit, gr)
ptss <- predict(lda_separate, gr)
g1 <- ggplot(moreclasses, aes(x1, x2)) +
  scale_shape_manual(values = levels(pts3$class), guide = "none") +
  geom_raster(data = tibble(gr, disc = pts3$class), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_viridis_d(alpha = .5, name = bquote(hat(g)(x))) +
  theme_bw(base_size = 24) +
  theme(legend.position = "bottom")
g2 <- ggplot(separateclasses, aes(x1, x2)) +
  scale_shape_manual(values = levels(ptss$class), guide = "none") +
  geom_raster(data = tibble(gr, disc = ptss$class), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  theme_bw(base_size = 24) +
  scale_fill_viridis_d(alpha = .5, name = bquote(hat(g)(x))) +
  theme(legend.position = "bottom")
plot_grid(g1, g2)


## ----fit-qda--------------------------------------------------------------------
qda_fit <- qda(y ~ ., dat1)
qda_3fit <- qda(y ~ ., moreclasses)


## ----qda-vs-lda-2class,echo=FALSE,fig.align='center',fig.height=5,fig.width=12,dev='png',dvi=300----
pts_qda <- predict(qda_fit, gr)
pts_qda3 <- predict(qda_3fit, gr)
z <- apply(pts_qda$posterior, 1, function(x) log(x[2] / x[1]))
gq0 <- ggplot(dat1, aes(x1, x2)) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = tibble(gr, disc = z), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  theme_bw(base_size = 24) +
  scale_fill_steps2(n.breaks = 8, name = bquote(delta[1] - delta[0])) +
  theme(legend.position = "bottom", legend.key.width = unit(3, "cm"))
plot_grid(g0, gq0)


## ----3class-comparison,echo=FALSE,fig.align='center',fig.height=6,fig.width=12,dev='png',dvi=300----
gq1 <- ggplot(moreclasses, aes(x1, x2)) +
  scale_shape_manual(values = levels(pts_qda3$class), guide = "none") +
  geom_raster(data = tibble(gr, disc = pts_qda3$class), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  theme_bw(base_size = 24) +
  scale_fill_viridis_d(alpha = .5, name = bquote(hat(g)(x))) +
  theme(legend.position = "bottom")
plot_grid(g1, gq1)

