## ----echo=FALSE, fig.align='center', fig.width=10, fig.height=5-----------------
df <- tibble(
  x1 = rep(rnorm(20, sd = 1), 3),
  x2 = rep(rnorm(20, sd = .2), 3),
  lab = rep(c("data", "x2 only", "x1 only"), each = 20)
)
df[21:40, 1] <- 0
df[41:60, 2] <- 0
ggplot(df, aes(x1, x2, color = lab)) +
  geom_point() +
  coord_cartesian(c(-2, 2), c(-2, 2)) +
  scale_color_manual(values = c(blue, orange, green)) +
  facet_wrap(~lab) +
  theme(legend.title = element_blank(), legend.position = "none")


## ----echo=FALSE, fig.align='center', fig.width=10, fig.height=4-----------------
# library(UBCstat406labs)
theta <- -pi / 4
R <- matrix(c(cos(theta), sin(theta), -sin(theta), cos(theta)), 2)
X <- as.matrix(df[1:20, 1:2]) %*% R
df2 <- data.frame(
  x1 = rep(X[, 1], 3),
  x2 = rep(X[, 2], 3),
  lab = rep(c("data", "x2 only", "x1 only"), each = 20)
)
df2[21:40, 1] <- 0
df2[41:60, 2] <- 0
ggplot(df2, aes(x1, x2, color = lab)) +
  geom_point() +
  scale_color_manual(values = c(blue, orange, green)) +
  coord_cartesian(c(-2, 2), c(-2, 2)) +
  facet_wrap(~lab) +
  theme(legend.title = element_blank(), legend.position = "none")


## ----echo=FALSE, fig.align='center',fig.width=10,fig.height=4-------------------
df3 <- bind_rows(df, df2)
df3$version <- rep(c("original", "rotated"), each = 60)
df3 %>%
  ggplot(aes(x1, x2, color = lab)) +
  geom_point() +
  scale_color_manual(values = c(blue, orange, green)) +
  coord_cartesian(c(-2, 2), c(-2, 2)) +
  facet_grid(~version) +
  theme(legend.title = element_blank(), legend.position = "bottom")


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
#| fig-height: 4
s <- svd(X)
tib <- rbind(X, s$u %*% diag(s$d), s$u %*% diag(c(s$d[1], 0)))
tib <- tibble(
  x1 = tib[, 1], x2 = tib[, 2],
  name = rep(1:3, each = 20)
)
plotter <- function(set = 1, main = "original") {
  tib |>
    filter(name == set) |>
    ggplot(aes(x1, x2)) +
    geom_point(colour = blue) +
    coord_cartesian(c(-2, 2), c(-2, 2)) +
    theme(legend.title = element_blank(), legend.position = "bottom") +
    ggtitle(main)
}
cowplot::plot_grid(
  plotter() + labs(x = bquote(x[1]), y = bquote(x[2])),
  plotter(2, "rotated") +
    labs(x = bquote((UD)[1] == (XV)[1]), y = bquote((UD)[2] == (XV)[2])),
  plotter(3, "rotated and projected") +
    labs(x = bquote(U[1] ~ D[1] == (XV)[1]), y = bquote(U[2] ~ D[2] %==% 0)),
  nrow = 1
)


## ----pca-music------------------------------------------------------------------
music <- Stat406::popmusic_train
str(music)
X <- music |> select(danceability:energy, loudness, speechiness:valence)
pca <- prcomp(X, scale = TRUE) ## DON'T USE princomp()


## ----pca-music-plot-------------------------------------------------------------
proj_pca <- predict(pca)[,1:2] |>
  as_tibble() |>
  mutate(artist = music$artist)


## -------------------------------------------------------------------------------
#| echo: false
#| fig-width: 10
#| fig-height: 4
g1 <- ggplot(proj_pca, aes(PC1, PC2, color = artist)) +
  geom_point() +
  theme(legend.position = "none") +
  scale_color_viridis_d()
g2 <- ggplot(
  tibble(var_explained = pca$sdev^2 / sum(pca$sdev^2), M = 1:ncol(X)),
  aes(M, var_explained)
) +
  geom_point(color = orange) +
  scale_x_continuous(breaks = 1:10) +
  geom_segment(aes(xend = M, yend = 0), color = blue)
cowplot::plot_grid(g1, g2)


## -------------------------------------------------------------------------------
pca$rotation[, 1:2]
pca$sdev
pca$sdev^2 / sum(pca$sdev^2)


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
#| fig-height: 5
pca$rotation[, 1:2] |>
  as_tibble() |>
  mutate(feature = names(X)) |>
  pivot_longer(-feature) |>
  ggplot(aes(value, feature, fill = feature)) +
  facet_wrap(~name) +
  geom_col() +
  theme(legend.position = "none", axis.title = element_blank()) +
  scale_fill_brewer(palette = "Dark2") +
  geom_vline(xintercept = 0)

