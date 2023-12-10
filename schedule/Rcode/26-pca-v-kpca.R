## -------------------------------------------------------------------------------
X <- Stat406::mobility |>
  select(Black:Married) |>
  as.matrix()
not_missing <- complete.cases(X)
X <- scale(X[not_missing, ], center = TRUE, scale = TRUE)
colors <- Stat406::mobility$Mobility[not_missing]
M <- 2 # embedding dimension
P <- diag(nrow(X)) - 1 / nrow(X)


## -------------------------------------------------------------------------------
s <- svd(X) # use svd
pca_loadings <- s$v[, 1:M]
pca_scores <- X %*% pca_loadings


## ----echo=TRUE, eval=FALSE------------------------------------------------------
## s <- eigen(t(X) %*% X) # V D^2 V'
## pca_loadings <- s$vectors[, 1:M]
## pca_scores <- X %*% pca_loadings


## ----echo=TRUE, eval=FALSE------------------------------------------------------
## s <- eigen(X %*% t(X)) # U D^2 U'
## D <- sqrt(diag(s$values[1:M]))
## U <- s$vectors[, 1:M]
## pca_scores <- U %*% D
## pca_loadings <- (1 / D) %*% t(U) %*% X


## -------------------------------------------------------------------------------
d <- 2
K <- P %*% (1 + X %*% t(X))^d %*% P # polynomial
e <- eigen(K) # U D^2 U'
# (different from the PCA one, K /= XX')
U <- e$vectors[, 1:M]
D <- diag(sqrt(e$values[1:M]))
kpca_poly <- U %*% D


## -------------------------------------------------------------------------------
K <- P %*% tanh(1 + X %*% t(X)) %*% P # sigmoid kernel
e <- eigen(K) # U D^2 U'
# (different from the PCA one, K /= XX')
U <- e$vectors[, 1:M]
D <- diag(sqrt(e$values[1:M]))
kpca_sigmoid <- U %*% D


## ----echo=FALSE, fig.align="center", fig.width=10, fig.height=6-----------------
pca <- tibble(score1 = pca_scores[, 1], score2 = pca_scores[, 2], colors = colors)
kpca_poly <- tibble(score1 = kpca_poly[, 1], score2 = kpca_poly[, 2], colors = colors)
kpca_sigmoid <- tibble(score1 = kpca_sigmoid[, 1], score2 = kpca_sigmoid[, 2], colors = colors)
bind_rows(pca = pca, kpca_poly = kpca_poly, kpca_sigmoid = kpca_sigmoid, .id = "method") |>
  ggplot(aes(score1, score2, color = colors)) +
  facet_wrap(~ method, scales = "free") +
  theme(legend.position = "bottom") +
  guides(color = guide_colorbar(barwidth = unit(.5, "npc"))) +
  scale_color_viridis_c(name = "Mobility") +
  geom_point()


## -------------------------------------------------------------------------------
head(round(pca_loadings, 2), 10)


## ----echo=TRUE, eval=FALSE------------------------------------------------------
## p <- ncol(X)
## width <- p * (p - 1) / 2 + p # = 630
## Z <- matrix(NA, nrow(X), width)
## k <- 0
## for (i in 1:p) {
##   for (j in i:p) {
##     k <- k + 1
##     Z[, k] <- X[, i] * X[, j]
##   }
## }
## wideX <- scale(cbind(X, Z))
## s <- RSpectra::svds(wideX, 2) # the whole svd would be super slow
## fkpca_scores <- s$u %*% diag(s$d)


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 6.5
#| fig-height: 6
elephant <- function(eye = TRUE) {
  tib <- tibble(
    tt = -100:500 / 100,
    y = -(12 * cos(3 * tt) - 14 * cos(5 * tt) + 50 * sin(tt) + 18 * sin(2 * tt)),
    x = -30 * sin(tt) + 8 * sin(2 * tt) - 10 * sin(3 * tt) - 60 * cos(tt)
  )
  if (eye) tib <- add_row(tib, y = 20, x = 20)
  tib
}
ele <- elephant(FALSE)
noisy_ele <- ele |>
  mutate(y = y + rnorm(n(), 0, 5), x = x + rnorm(n(), 0, 5))
ggplot(noisy_ele, aes(x, y, colour = tt)) +
  geom_point() +
  scale_color_viridis_c() +
  theme(legend.position = "none") +
  geom_path(data = ele, colour = "black", linewidth = 2)

