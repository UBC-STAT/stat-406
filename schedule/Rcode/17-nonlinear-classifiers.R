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
dat1 <- generate_lda_2d(100, Sigma = .5 * diag(2)) |> mutate(y = as.factor(y))
logit_poly <- glm(y ~ x1 * x2 + I(x1^2) + I(x2^2), dat1, family = "binomial")
lda_poly <- lda(y ~ x1 * x2 + I(x1^2) + I(x2^2), dat1)


## ----plot-d1--------------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
#| fig-height: 5
library(cowplot)
gr <- expand_grid(x1 = seq(-2.5, 3, length.out = 100), x2 = seq(-2.5, 3, length.out = 100))
pts_logit <- predict(logit_poly, gr)
pts_lda <- predict(lda_poly, gr)
g0 <- ggplot(dat1, aes(x1, x2)) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = tibble(gr, disc = pts_logit), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_viridis_b(n.breaks = 6, alpha = .5, name = "log odds") +
  ggtitle("Polynomial logit") +
  theme(legend.position = "bottom", legend.key.width = unit(1.5, "cm"))
g1 <- ggplot(dat1, aes(x1, x2)) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = tibble(gr, disc = pts_lda$x), aes(x1, x2, fill = disc)) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_viridis_b(n.breaks = 6, alpha = .5, name = bquote(delta[1] - delta[0])) +
  ggtitle("Polynomial lda") +
  theme(legend.position = "bottom", legend.key.width = unit(1.5, "cm"))
plot_grid(g0, g1)


## ----bake-it, echo=FALSE--------------------------------------------------------
data("bakeoff_train", package = "Stat406")
bakeoff <- bakeoff_train[complete.cases(bakeoff_train), ]
library(tree)
library(maptree)


## ----glimpse-bakers, R.options = list(width = 50)-------------------------------
names(bakeoff)


## ----our-partition--------------------------------------------------------------
smalltree <- tree(
  winners ~ technical_median + percent_star,
  data = bakeoff
)


## ----plot-partition-------------------------------------------------------------
#| code-fold: true
#| fig-width: 6
#| fig-height: 6
par(mar = c(5, 5, 0, 0) + .1)
plot(bakeoff$technical_median, bakeoff$percent_star,
  pch = c("-", "+")[bakeoff$winners + 1], cex = 2, bty = "n", las = 1,
  ylab = "% star baker", xlab = "times above median in technical",
  col = orange, cex.axis = 2, cex.lab = 2
)
partition.tree(smalltree,
  add = TRUE, col = blue,
  ordvars = c("technical_median", "percent_star")
)


## -------------------------------------------------------------------------------
library(class)
knn3 <- knn(dat1[, -1], gr, dat1$y, k = 3)


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 8
#| fig-height: 4
gr$nn03 <- knn3
ggplot(dat1, aes(x1, x2)) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = tibble(gr, disc = knn3), aes(x1, x2, fill = disc), alpha = .5) +
  geom_point(aes(shape = as.factor(y)), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_manual(values = c(orange, blue), labels = c("0", "1")) +
  theme(
    legend.position = "bottom", legend.title = element_blank(),
    legend.key.width = unit(2, "cm")
  )


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 16
#| fig-height: 5
set.seed(406406406)
ks <- c(1, 2, 5, 10, 20)
nn <- map(ks, ~ as_tibble(knn(dat1[, -1], gr[, 1:2], dat1$y, .x)) |> 
  set_names(sprintf("k = %02s", .x))) |>
  list_cbind() |>
  bind_cols(gr)
pg <- pivot_longer(nn, starts_with("k ="), names_to = "k", values_to = "knn")

ggplot(pg, aes(x1, x2)) +
  geom_raster(aes(fill = knn), alpha = .6) +
  facet_wrap(~ k) +
  scale_fill_manual(values = c(orange, green), labels = c("0", "1")) +
  geom_point(data = dat1, mapping = aes(x1, x2, shape = as.factor(y)), size = 4) +
  theme_bw(base_size = 18) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  theme(
    legend.title = element_blank(),
    legend.key.height = unit(3, "cm")
  )


## -------------------------------------------------------------------------------
kmax <- 20
err <- map_dbl(1:kmax, ~ mean(knn.cv(dat1[, -1], dat1$y, k = .x) != dat1$y))


## -------------------------------------------------------------------------------
#| echo: false
ggplot(data.frame(k = 1:kmax, error = err), aes(k, error)) +
  geom_point(color = orange) +
  geom_line(color = orange)


## -------------------------------------------------------------------------------
#| code-fold: true
dev <- function(y, prob, prob_min = 1e-5) {
  y <- as.numeric(as.factor(y)) - 1 # 0/1 valued
  m <- mean(y)
  prob_max <- 1 - prob_min
  prob <- pmin(pmax(prob, prob_min), prob_max)
  lp <- (1 - y) * log(1 - prob) + y * log(prob)
  ly <- (1 - y) * log(1 - m) + y * log(m)
  2 * (ly - lp)
}
knn.cv_probs <- function(train, cl, k = 1) {
  o <- knn.cv(train, cl, k = k, prob = TRUE)
  p <- attr(o, "prob")
  o <- as.numeric(as.factor(o)) - 1
  p[o == 0] <- 1 - p[o == 0]
  p
}
dev_err <- map_dbl(1:kmax, ~ mean(dev(dat1$y, knn.cv_probs(dat1[, -1], dat1$y, k = .x))))


## -------------------------------------------------------------------------------
#| echo: false
ggplot(data.frame(k = 1:kmax, error = dev_err), aes(k, error)) +
  geom_point(color = orange) +
  geom_line(color = orange)


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-height: 6
#| fig-width: 6
kopt <- max(which(err == min(err)))
kopt <- kopt + 1 * (kopt %% 2 == 0)
gr$opt <- knn(dat1[, -1], gr[, 1:2], dat1$y, k = kopt)
tt <- table(knn(dat1[, -1], dat1[, -1], dat1$y, k = kopt), dat1$y, dnn = c("predicted", "truth"))
ggplot(dat1, aes(x1, x2)) +
  theme_bw(base_size = 24) +
  scale_shape_manual(values = c("0", "1"), guide = "none") +
  geom_raster(data = gr, aes(x1, x2, fill = opt), alpha = .6) +
  geom_point(aes(shape = y), size = 4) +
  coord_cartesian(c(-2.5, 3), c(-2.5, 3)) +
  scale_fill_manual(values = c(orange, green), labels = c("0", "1")) +
  theme(
    legend.position = "bottom", legend.title = element_blank(),
    legend.key.width = unit(2, "cm")
  )


## ----echo=FALSE-----------------------------------------------------------------
tt

