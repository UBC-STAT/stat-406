## -------------------------------------------------------------------------------
#| message: false
library(mgcv)
set.seed(12345)
n <- 500
simple <- tibble(
  x1 = runif(n, 0, 2*pi),
  x2 = runif(n),
  y = 5 + 2 * sin(x1) + 8 * sqrt(x2) + rnorm(n, sd = .25)
)

pivot_longer(simple, -y, names_to = "predictor", values_to = "x") |>
  ggplot(aes(x, y)) +
  geom_point(col = blue) +
  facet_wrap(~predictor, scales = "free_x")


## ----gam-mod--------------------------------------------------------------------
#| fig-width: 8
ex_smooth <- gam(y ~ s(x1) + s(x2), data = simple)
# s(z) means "smooth" z, uses spline basis for each with ridge penalty, GCV
plot(ex_smooth, pages = 1, scale = 0, shade = TRUE, 
     resid = TRUE, se = 2, las = 1)
head(coef(ex_smooth))
ex_smooth$gcv.ubre


## -------------------------------------------------------------------------------
#| fig-width: 8
ex_smooth2 <- gam(y ~ s(x1, x2), data = simple)
plot(ex_smooth2,
  scheme = 2, scale = 0, shade = TRUE,
  resid = TRUE, se = 2, las = 1
)


## ----small-tree-prelim, echo=FALSE----------------------------------------------
data("mobility", package = "Stat406")
library(tree)
library(maptree)
mob <- mobility[complete.cases(mobility), ] %>% dplyr::select(-ID, -Name)
set.seed(12345)
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0))


## -------------------------------------------------------------------------------
#| fig-width: 8
bigtree <- tree(Mobility ~ ., data = mob)
smalltree <- prune.tree(bigtree, k = .09)
draw.tree(smalltree, digits = 2)


## ----partition-view-------------------------------------------------------------
#| fig-width: 8
mob$preds <- predict(smalltree)
par(mfrow = c(1, 2), mar = c(5, 3, 0, 0))
draw.tree(smalltree, digits = 2)
cols <- viridisLite::viridis(20, direction = -1)[cut(log(mob$Mobility), 20)]
plot(mob$Black, mob$Commute,
  pch = 19, cex = .4, bty = "n", las = 1, col = cols,
  ylab = "Commute time", xlab = "% Black"
)
partition.tree(smalltree, add = TRUE, ordvars = c("Black", "Commute"))


## ----big-tree-------------------------------------------------------------------
#| fig-width: 8
#| fig-height: 5
draw.tree(bigtree, digits = 2)

