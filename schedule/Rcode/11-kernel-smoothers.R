## ----load-lidar-----------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
#| fig-height: 5
library(cowplot)
data(arcuate, package = "Stat406")
set.seed(406406)
arcuate_unif <- arcuate |> slice_sample(n = 40) |> arrange(position)
pt <- 15
nn <-  3
seq_range <- function(x, n = 101) seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = n)
neibs <- sort.int(abs(arcuate_unif$position - arcuate_unif$position[pt]), index.return = TRUE)$ix[1:nn]
arcuate_unif$neighbours = seq_len(40) %in% neibs
g1 <- ggplot(arcuate_unif, aes(position, fa, colour = neighbours)) + 
  geom_point() +
  scale_colour_manual(values = c(blue, red)) + 
  geom_vline(xintercept = arcuate_unif$position[pt], colour = red) + 
  annotate("rect", fill = red, alpha = .25, ymin = -Inf, ymax = Inf,
           xmin = min(arcuate_unif$position[neibs]), 
           xmax = max(arcuate_unif$position[neibs])
  ) +
  theme(legend.position = "none")
g2 <- ggplot(arcuate_unif, aes(position, fa)) +
  geom_point(colour = blue) +
  geom_line(
    data = tibble(
      position = seq_range(arcuate_unif$position),
      fa = FNN::knn.reg(
        arcuate_unif$position, matrix(position, ncol = 1),
        y = arcuate_unif$fa
      )$pred
    ),
    colour = orange, linewidth = 2
  )
plot_grid(g1, g2, ncol = 2)


## ----small-lidar-again----------------------------------------------------------
#| echo: false
#| fig-width: 7
#| fig-height: 7
g2


## ----eval=FALSE, echo = TRUE----------------------------------------------------
## data(arcuate, package = "Stat406")
## library(FNN)
## arcuate_unif <- arcuate |>
##   slice_sample(n = 40) |>
##   arrange(position)
## 
## new_position <- seq(
##   min(arcuate_unif$position),
##   max(arcuate_unif$position),
##   length.out = 101
## )
## 
## knn3 <- knn.reg(
##   train = arcuate_unif$position,
##   test = matrix(arcuate_unif$position, ncol = 1),
##   y = arcuate_unif$fa,
##   k = 3
## )


## ----fig.height = 4, fig.align='center', fig.width=8, echo=FALSE,fig.height=4----
ggplot(arcuate_unif, aes(position, fa)) +
  geom_point(colour = blue) +
  geom_segment(aes(x = position[15], y = 0, xend = position[15], yend = fa[15]), colour = blue) +
  geom_segment(aes(x = position[25], y = 0, xend = position[25], yend = fa[25]), colour = green) +
  geom_rect(aes(xmin = position[15] - 15, xmax = position[15] + 15, ymin = 0, ymax = .1), fill = blue) +
  geom_rect(aes(xmin = position[25] - 15, xmax = position[25] + 15, ymin = 0, ymax = .1), fill = green)


## ----boxcar---------------------------------------------------------------------
#| code-fold: true
testpts <- seq(0, 200, length.out = 101)
dmat <- abs(outer(testpts, arcuate_unif$position, "-"))
S <- (dmat < 15)
S <- S / rowSums(S)
boxcar <- tibble(position = testpts, fa = S %*% arcuate_unif$fa)
ggplot(arcuate_unif, aes(position, fa)) +
  geom_point(colour = blue) +
  geom_line(data = boxcar, colour = orange)


## -------------------------------------------------------------------------------
#| code-fold: true
gaussian_kernel <- function(x) dnorm(x, mean = arcuate_unif$position[15], sd = 7.5) * 3
ggplot(arcuate_unif, aes(position, fa)) +
  geom_point(colour = blue) +
  geom_segment(aes(x = position[15], y = 0, xend = position[15], yend = fa[15]), colour = orange) +
  stat_function(fun = gaussian_kernel, geom = "area", fill = orange)


## -------------------------------------------------------------------------------
#| code-fold: true
gaussian_kernel <- function(x) dnorm(x, mean = arcuate_unif$position[15], sd = 15) * 3
ggplot(arcuate_unif, aes(position, fa)) +
  geom_point(colour = blue) +
  geom_segment(aes(x = position[15], y = 0, xend = position[15], yend = fa[15]), colour = orange) +
  stat_function(fun = gaussian_kernel, geom = "area", fill = orange)


## ----eval = FALSE---------------------------------------------------------------
## dmat <- as.matrix(dist(x))
## Sgauss <- function(sigma) {
##   gg <- dnorm(dmat, sd = sigma) # not an argument, uses the global dmat
##   sweep(gg, 1, rowSums(gg), "/") # make the rows sum to 1.
## }


## -------------------------------------------------------------------------------
#| code-fold: true
Sgauss <- function(sigma) {
  gg <-  dnorm(dmat, sd = sigma) # not an argument, uses the global dmat
  sweep(gg, 1, rowSums(gg),'/') # make the rows sum to 1.
}
boxcar$S15 = with(arcuate_unif, Sgauss(15) %*% fa)
boxcar$S08 = with(arcuate_unif, Sgauss(8) %*% fa)
boxcar$S30 = with(arcuate_unif, Sgauss(30) %*% fa)
bc = boxcar %>% select(position, S15, S08, S30) %>% 
  pivot_longer(-position, names_to = "Sigma")
ggplot(arcuate_unif, aes(position, fa)) + 
  geom_point(colour = blue) + 
  geom_line(data = bc, aes(position, value, colour = Sigma), linewidth = 1.5) +
  scale_colour_brewer(palette = "Set1")


## -------------------------------------------------------------------------------
epan <- function(x) 3/4 * (1 - x^2) * (abs(x) < 1)
ggplot(data.frame(x = c(-2, 2)), aes(x)) + stat_function(fun = epan, colour = green, linewidth = 2)


## -------------------------------------------------------------------------------
ar <- arcuate |> slice_sample(n = 200)

gcv <- function(y, S) {
  yhat <- S %*% y
  mean( (y - yhat)^2 / (1 - mean(diag(S)))^2 )
}

fake_loocv <- function(y, S) {
  yhat <- S %*% y
  mean( (y - yhat)^2 / (1 - diag(S))^2 )
}

dmat <- as.matrix(dist(ar$position))
sigmas <- 10^(seq(log10(300), log10(.3), length = 100))

gcvs <- map_dbl(sigmas, ~ gcv(ar$fa, Sgauss(.x)))
flcvs <- map_dbl(sigmas, ~ fake_loocv(ar$fa, Sgauss(.x)))
best_s <- sigmas[which.min(gcvs)]
other_s <- sigmas[which.min(flcvs)]

ar$smoothed <- Sgauss(best_s) %*% ar$fa
ar$other <- Sgauss(other_s) %*% ar$fa


## ----smoothed-lidar-------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
g3 <- ggplot(data.frame(sigma = sigmas, gcv = gcvs), aes(sigma, gcv)) +
  geom_point(colour = blue) +
  geom_vline(xintercept = best_s, colour = red) +
  scale_x_log10() +
  xlab(sprintf("Sigma, best is sig = %.2f", best_s))
g4 <- ggplot(ar, aes(position, fa)) +
  geom_point(colour = blue) +
  geom_line(aes(y = smoothed), colour = orange, linewidth = 2)
plot_grid(g3, g4, nrow = 1)


## ----eval=FALSE, echo=TRUE, error=TRUE------------------------------------------
## loess()
## ksmooth()
## KernSmooth::locpoly()
## mgcv::gam()
## np::npreg()

