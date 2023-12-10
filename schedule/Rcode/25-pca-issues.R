## ----good-pca, echo=FALSE, fig.align='center',fig.height=4,fig.width=5----------
library(mvtnorm)
m <- c(2, 3)
covmat <- matrix(c(1, .75, .75, 1), 2)
ee <- eigen(covmat)
x <- rmvnorm(200, m, covmat)
z <- apply(x, 1, function(x) sqrt(sum(x^2)))
df <- data.frame(x = x[, 1], y = x[, 2], z = z)
ss <- sqrt(ee$values)
df_arrows <- data.frame(
  x1 = m[1], y1 = m[2],
  x2 = m[1] + 3 * ee$vectors[1, ] * ss / sum(ss),
  y2 = m[2] + 3 * ee$vectors[2, ] * ss / sum(ss)
)
pgood <- ggplot(df) +
  geom_point(aes(x, y, colour = z)) +
  scale_colour_viridis_c() +
  coord_cartesian(c(-1, 5), c(0, 6)) +
  theme(legend.position = "none") +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = df_arrows, arrow = arrow(), linewidth = 2, colour = orange)
pgood


## ----pca-reduced, fig.align='center',fig.height=4,fig.width=10,echo=FALSE-------
xx <- scale(x, center = m, scale = FALSE) %*% ee$vectors[, 1]
yy <- scale(x, center = m, scale = FALSE) %*% ee$vectors[, 2]
df2 <- tibble(x = xx + m[1], y = m[2], z = z)
pred <- ggplot(df2) +
  geom_jitter(aes(x = x, y = y, col = z), width = 0, height = .2) +
  theme(legend.position = "none") +
  coord_cartesian(c(-1, 5), ylim = c(0, 6)) +
  labs(x = bquote(XV[1]), y = bquote(XV[2] %==% 0)) +
  scale_colour_viridis_c()
cowplot::plot_grid(pgood, pred, align = "v")


## ----spiral, fig.align='center',fig.height=5,fig.width=6, echo=FALSE------------
#| code-fold: true
n <- 100
tt <- seq(0, 4 * pi, length = n)
jit <- runif(n, -.2, .2)
df_spiral <- data.frame(x = 3 / 2 * tt * sin(tt) + runif(n, -.2, .2) * sqrt(tt), y = 0.5 * tt * cos(tt) + runif(n, -.2, .2) * sqrt(tt), z = tt) %>%
  mutate(x = x / sd(x), y = y / sd(y))
ee <- eigen(crossprod(scale(as.matrix(df_spiral[, 1:2]))))
ss <- sqrt(ee$values)
df_arrows <- data.frame(
  x1 = 0, y1 = 0,
  x2 = ee$vectors[1, ] * ss / sum(ss) * 2,
  y2 = ee$vectors[2, ] * ss / sum(ss) * 2
)
gsp <- ggplot(df_spiral) +
  geom_point(aes(x = x, y = y, col = z)) +
  coord_cartesian(c(-2.5, 2), c(-2, 2.5)) +
  scale_colour_viridis_c() +
  theme(legend.position = "none") +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = df_arrows, arrow = arrow(), size = 2, colour = orange)
gsp


## ----spiral-reduced, fig.align='center',fig.height=5,fig.width=12, echo=FALSE----
library(cowplot)
xx <- as.matrix(df_spiral[, 1:2]) %*% ee$vectors[, 1]
df_spiral2 <- tibble(x = xx, y = jit, z = tt)
gspbad <- ggplot(df_spiral2) +
  geom_point(aes(x = x, y = y, col = z)) +
  scale_colour_viridis_c() +
  coord_cartesian(c(-2.5, 2), c(-2, 2.5)) +
  labs(x = bquote(XV[1]), y = bquote(XV[2] %==% 0)) +
  theme(legend.position = "none")
plot_grid(gsp, gspbad)


## -------------------------------------------------------------------------------
#| echo: false
#| fig-width: 5
#| fig-height: 5
gsp


## ----get-kpca-------------------------------------------------------------------
#| code-fold: true
n <- nrow(df_spiral)
I_M <- (diag(n) - tcrossprod(rep(1, n)) / n)
kp <- (tcrossprod(as.matrix(df_spiral[, 1:2])) + 1)^2
Kp <- I_M %*% kp %*% I_M
Ep <- eigen(Kp, symmetric = TRUE)
polydf <- tibble(
  x = Ep$vectors[, 1] * Ep$values[1],
  y = jit,
  z = df_spiral$z
)
kg <- exp(-as.matrix(dist(df_spiral[, 1:2]))^2 / 1)
Kg <- I_M %*% kg %*% I_M
Eg <- eigen(Kg, symmetric = TRUE)
gaussdf <- tibble(
  x = Eg$vectors[, 1] * Eg$values[1],
  y = jit,
  z = df_spiral$z
)
dfkern <- bind_rows(df_spiral, df_spiral2, polydf, gaussdf)
dfkern$method <- rep(c("data", "pca", "kpoly (d = 2)", "kgauss (gamma = 1)"), each = n)


## ----plot-kpca, echo=FALSE, fig.align='center', fig.height=6, fig.width=10------
dfkern %>%
  ggplot(aes(x = x, y = y, colour = z)) +
  geom_point() +
  facet_wrap(~method, scales = "free_x", nrow = 2) +
  scale_colour_viridis_c() +
  theme(legend.position = "none") +
  ylab("x2") +
  xlab("x1")


## -------------------------------------------------------------------------------
music <- Stat406::popmusic_train
X <- music |> select(danceability:energy, loudness, speechiness:valence)
pca <- prcomp(X, scale = TRUE)
Z <- predict(pca)[, 1:2]
Zgrid <- expand.grid(
  Z1 = seq(min(Z[,1]), max(Z[,1]), len = 100L), 
  Z2 = seq(min(Z[,2]), max(Z[,2]), len = 100L)
)
out <- class::knn(Z, Zgrid, music$artist, k = 6)


## -------------------------------------------------------------------------------
#| echo: false
#| fig-width: 10
#| fig-height: 4
tibble(pred_class = out, Zgrid) |>
  ggplot(aes(Z1, Z2)) +
  geom_raster(aes(fill = pred_class), alpha = .3) +
  geom_point(
    aes(colour = artist),
    data = tibble(artist = music$artist, as_tibble(Z)) |> 
      rename(Z1 = PC1, Z2 = PC2)
  ) +
  scale_colour_viridis_d() +
  scale_fill_viridis_d()

