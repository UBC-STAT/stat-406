## -------------------------------------------------------------------------------
library(mvtnorm)
set.seed(406406406)
X1 <- rmvnorm(50, c(-1, 2), sigma = matrix(c(1, .5, .5, 1), 2))
X2 <- rmvnorm(40, c(2, -1), sigma = matrix(c(1.5, .5, .5, 1.5), 2))
X3 <- rmvnorm(40, c(4, 4))


## ----plotting-dumb-clusts, echo=FALSE, fig.align="center", fig.width=10,fig.height=5----
clust_raw <- rbind(X1, X2, X3)
clust <- tibble(
  x1 = clust_raw[, 1], x2 = clust_raw[, 2],
  true = as.factor(rep(1:3, times = c(50, 40, 40)))
)
clust |> ggplot(aes(x = x1, y = x2, color = true)) +
  geom_point(size = 2) +
  scale_colour_manual(values = c(blue, orange, green)) +
  theme(legend.position = "none")


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
#| fig-height: 4
K <- 2:40
N <- nrow(clust_raw)
all_clusters <- map(K, ~ kmeans(clust_raw, .x, nstart = 20))
all_assignments <- map_dfc(all_clusters, "cluster")
names(all_assignments) <- paste0("K = ", K)
summaries <- map_dfr(all_clusters, `[`, c("tot.withinss", "betweenss")) |>
  rename(W = tot.withinss, B = betweenss) |>
  mutate(
    K = K,
    `W / (N - K)` = W / (N - K),
    `B / K` = B / (K - 1), 
    `CH index` = `B / K` / `W / (N - K)`
  )
summaries |>
  pivot_longer(-K) |>
  ggplot(aes(K, value)) +
  geom_line(color = blue, linewidth = 2) +
  ylab("") +
  coord_cartesian(c(1, 20)) +
  facet_wrap(~name, ncol = 3, scales = "free_y")


## ----echo=FALSE,fig.align='center',fig.width=10,fig.height=6--------------------
small_assignments <- all_assignments[, c(1, 2, 3, 4, 9, 14, 19, 29)]
nums <- as.character(1:30)
bind_cols(small_assignments, clust) |>
  mutate(across(starts_with("K = "), factor)) |>
  pivot_longer(-starts_with("x")) |>
  mutate(value = fct_relevel(
    value, "1", "30", "29", "28", "27", "26", "10",
    "5", "25", "24", "23", "22", "21", "9",
    "3", "20", "19", "18", "17", "16", "8",
    "4", "15", "14", "13", "12", "11", "7",
    "2", "6"
  )) |>
  ggplot(aes(x1, x2, color = value)) +
  geom_point() +
  facet_wrap(~ factor(
    name, 
    levels = c("true", paste0("K = ", c(2:5, 10, 15, 20, 30)))
  )) +
  theme(legend.position = "none") +
  scale_color_viridis_d()


## ----echo = TRUE, message = FALSE-----------------------------------------------
km <- kmeans(clust_raw, 3, nstart = 20)
names(km)
centers <- as_tibble(km$centers, .name_repair = "unique")


## ----echo=FALSE, fig.align='center',fig.width=10,fig.height=3-------------------
names(centers) <- c("x1", "x2")
bind_cols(clust, est = factor(km$cluster)) |>
  ggplot(aes(x1, x2)) +
  geom_point(aes(color = est), size = 2) +
  geom_point(data = centers, size = 10, pch = "😀") +
  theme(legend.position = "none") +
  scale_color_manual(values = c(blue, orange, green))

