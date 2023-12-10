## ----plotting-functions---------------------------------------------------------
#| code-fold: true
#| fig-width: 6
#| fig-height: 6
library(mvtnorm)
norm_ball <- function(q = 1, len = 1000) {
  tg <- seq(0, 2 * pi, length = len)
  out <- tibble(x = cos(tg), b = (1 - abs(x)^q)^(1 / q), bm = -b) |>
    pivot_longer(-x, values_to = "y")
  out$lab <- paste0('"||" * beta * "||"', "[", signif(q, 2), "]")
  return(out)
}

ellipse_data <- function(
  n = 75, xlim = c(-2, 3), ylim = c(-2, 3),
  mean = c(1, 1), Sigma = matrix(c(1, 0, 0, .5), 2)) {
  expand_grid(
    x = seq(xlim[1], xlim[2], length.out = n),
    y = seq(ylim[1], ylim[2], length.out = n)) |>
    rowwise() |>
    mutate(z = dmvnorm(c(x, y), mean, Sigma))
}

lballmax <- function(ed, q = 1, tol = 1e-6, niter = 20) {
  ed <- filter(ed, x > 0, y > 0)
  feasible <- (ed$x^q + ed$y^q)^(1 / q) <= 1
  best <- ed[feasible, ]
  best[which.max(best$z), ]
}


nb <- norm_ball(2)
ed <- ellipse_data()
bols <- data.frame(x = 1, y = 1)
bhat <- lballmax(ed, 2)
ggplot(nb, aes(x, y)) +
  xlim(-2, 2) +
  ylim(-2, 2) +
  geom_path(colour = red) +
  geom_contour(mapping = aes(z = z), colour = blue, data = ed, bins = 7) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  geom_point(data = bols) +
  coord_equal() +
  geom_label(
    data = bols,
    mapping = aes(label = bquote("hat(beta)[ols]")),
    parse = TRUE, 
    nudge_x = .3, nudge_y = .3
  ) +
  geom_point(data = bhat) +
  xlab(bquote(beta[1])) +
  ylab(bquote(beta[2])) +
  theme_bw(base_size = 24) +
  geom_label(
    data = bhat,
    mapping = aes(label = bquote("hat(beta)[s]^R")),
    parse = TRUE,
    nudge_x = -.4, nudge_y = -.4
  )


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 16
#| fig-height: 9
#| dev: png
b <- c(1, 1)
n <- 1000
lams <- c(1, 5, 10)
ols_loss <- function(b1, b2) colMeans((y - X %*% rbind(b1, b2))^2) / 2
pen <- function(b1, b2, lambda = 1) lambda * (b1^2 + b2^2) / 2
gr <- expand_grid(
  b1 = seq(b[1] - 0.5, b[1] + 0.5, length.out = 100),
  b2 = seq(b[2] - 0.5, b[2] + 0.5, length.out = 100)
)

X <- mvtnorm::rmvnorm(n, c(0, 0), sigma = matrix(c(1, .3, .3, .5), nrow = 2))
y <- drop(X %*% b + rnorm(n))

bols <- coef(lm(y ~ X - 1))
bridge <- coef(MASS::lm.ridge(y ~ X - 1, lambda = lams * sqrt(n)))

penalties <- lams |>
  set_names(~ paste("lam =", .)) |>
  map(~ pen(gr$b1, gr$b2, .x)) |>
  as_tibble()
gr <- gr |>
  mutate(loss = ols_loss(b1, b2)) |>
  bind_cols(penalties)

g1 <- ggplot(gr, aes(b1, b2)) +
  geom_raster(aes(fill = loss)) +
  scale_fill_viridis_c(direction = -1) +
  geom_point(data = data.frame(b1 = b[1], b2 = b[2])) +
  theme(legend.position = "bottom") +
  guides(fill = guide_colourbar(barwidth = 20, barheight = 0.5))

g2 <- gr |>
    pivot_longer(starts_with("lam")) |>
    mutate(name = factor(name, levels = paste("lam =", lams))) |>
  ggplot(aes(b1, b2)) +
  geom_raster(aes(fill = value)) +
  scale_fill_viridis_c(direction = -1, name = "penalty") +
  facet_wrap(~name, ncol = 1) +
  geom_point(data = data.frame(b1 = b[1], b2 = b[2])) +
  theme(legend.position = "bottom") +
  guides(fill = guide_colourbar(barwidth = 10, barheight = 0.5))

g3 <- gr |> 
  mutate(across(starts_with("lam"), ~ loss + .x)) |>
  pivot_longer(starts_with("lam")) |>
  mutate(name = factor(name, levels = paste("lam =", lams))) |>
  ggplot(aes(b1, b2)) +
  geom_raster(aes(fill = value)) +
  scale_fill_viridis_c(direction = -1, name = "loss + pen") +
  facet_wrap(~name, ncol = 1) +
  geom_point(data = data.frame(b1 = b[1], b2 = b[2])) +
  theme(legend.position = "bottom") +
  guides(fill = guide_colourbar(barwidth = 10, barheight = 0.5))

cowplot::plot_grid(g1, g2, g3, rel_widths = c(2, 1, 1), nrow = 1)


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 8
#| fig-height: 5
#| dev: png
gr |> 
  mutate(z = ols_loss(b1, b2) + max(lams) * pen(b1, b2)) |>
  ggplot(aes(b1, b2)) +
  geom_raster(aes(fill = z)) +
  scale_fill_viridis_c(direction = -1) +
  geom_point(data = tibble(
    b1 = c(bols[1], bridge[,1]),
    b2 = c(bols[2], bridge[,2]),
    estimate = factor(c("ols", paste0("ridge = ", lams)), 
                      levels = c("ols", paste0("ridge = ", lams)))
  ),
  aes(shape = estimate), size = 3) +
  geom_point(data = data.frame(b1 = b[1], b2 = b[2]), colour = orange, size = 4)


## ----load-prostate--------------------------------------------------------------
data(prostate, package = "ElemStatLearn")
prostate |> as_tibble()


## ----process-prostate, echo=TRUE, dev="svg", message=FALSE,warning=FALSE, fig.height = 4, fig.width=8, fig.align='center'----
Y <- prostate$lpsa
X <- model.matrix(~ ., data = prostate |> dplyr::select(-train, -lpsa))
library(glmnet)
ridge <- glmnet(x = X, y = Y, alpha = 0, lambda.min.ratio = .00001)


## -------------------------------------------------------------------------------
#| fig-width: 8
#| fig-height: 6
plot(ridge, xvar = "lambda", lwd = 3)

