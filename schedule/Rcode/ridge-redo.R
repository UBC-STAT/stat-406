b <- rnorm(2)
gr <- expand_grid(
  b1 = seq(-2, 2, length.out = 100),
  b2 = seq(-2, 2, length.out = 100)
)

X <- mvtnorm::rmvnorm(100, c(0, 0), sigma = matrix(c(1, .3, .3, .5), nrow = 2))
y <- drop(X %*% b + rnorm(100))
bols <- coef(lm(y ~ X - 1))
ols_loss <- function(b1, b2) colMeans((y - X %*% rbind(b1, b2))^2) / 2
pen <- function(b1, b2, lambda = 0.5) lambda * (b1^2 + b2^2) / 2
gr <- gr |>
  mutate(
    loss = ols_loss(b1, b2),

ggplot(gr %>% mutate(
  z = ols_loss(b1, b2),
                     ), aes(b1, b2)) +
  geom_raster(aes(fill = z)) +
  scale_fill_viridis_c(direction = -1) +
  geom_point(data = data.frame(b1 = b[1], b2 = b[2]))

ggplot(gr %>% mutate(z = pen(b1, b2)), aes(b1, b2)) +
  geom_raster(aes(fill = z)) +
  scale_fill_viridis_c(direction = -1) +
  geom_point(data = data.frame(b1 = b[1], b2 = b[2]))

library(MASS)
bridge <- coef(lm.ridge(y ~ X - 1, lambda = 1))

ggplot(gr %>% mutate(z = ols_loss(b1, b2) + pen(b1, b2)), aes(b1, b2)) +
  geom_raster(aes(fill = z)) +
  scale_fill_viridis_c(direction = -1) +
  geom_point(data = data.frame(b1 = c(b[1], bhat[1]), b2 = c(b[2], bhat[2]),
                               col = c("ols", "ridge")), aes(shape = col))



