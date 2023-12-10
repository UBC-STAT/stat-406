## -------------------------------------------------------------------------------
mu = 1; n = 5; sig = 1


## -------------------------------------------------------------------------------
#| echo: false
#| fig-width: 8
#| fig-height: 4
biasSqA <- function(a, mu = 1) (a - 1)^2 * mu
varA <- function(a, n = 1) a^2 / n
risk <- function(a, mu = 1, n = 1, sig = 1) biasSqA(a, mu) + varA(a, n) + sig^2
meanrisk <- function(a, n = 1, sig = 1) sig^2 + 1 / n
aopt <- function(mu = 1, n = 1) mu^2 / (mu^2 + 1 / n)
ggplot(data.frame(a = c(0, 1), y = c(0, 2)), aes(a, y)) +
  stat_function(fun = ~biasSqA(.x), aes(color = "squared bias")) +
  stat_function(fun = ~varA(.x), aes(color = "variance"), args = list(n = n)) +
  stat_function(fun = ~risk(.x, mu, n, sig), aes(color = "risk")) +
  ylab(bquote(R[n](a))) +
  stat_function(fun = ~meanrisk(.x, n, sig), aes(color = "risk of mean")) +
  geom_vline(xintercept = aopt(mu, n), color = "black") +
  scale_color_manual(
    guide = "legend",
    values = c("squared bias" = red, "variance" = blue, "risk" = green, 
               "risk of mean" = orange, "best a" = "black"
    )
  ) +
  theme(legend.title = element_blank())


## -------------------------------------------------------------------------------
#| fig-height: 6
#| fig-width: 8
#| code-fold: true
cols = c(blue, red, green, orange)
par(mfrow = c(2, 2), bty = "n", ann = FALSE, xaxt = "n", yaxt = "n", 
    family = "serif", mar = c(0, 0, 0, 0), oma = c(0, 2, 2, 0))
library(mvtnorm)
mv <- matrix(c(0, 0, 0, 0, -.5, -.5, -.5, -.5), 4, byrow = TRUE)
va <- matrix(c(.02, .02, .1, .1, .02, .02, .1, .1), 4, byrow = TRUE)

for (i in 1:4) {
  plot(0, 0, ylim = c(-2, 2), xlim = c(-2, 2), pch = 19, cex = 42, 
       col = blue, ann = FALSE, pty = "s")
  points(0, 0, pch = 19, cex = 30, col = "white")
  points(0, 0, pch = 19, cex = 18, col = green)
  points(0, 0, pch = 19, cex = 6, col = orange)
  points(rmvnorm(20, mean = mv[i, ], sigma = diag(va[i, ])), cex = 1, pch = 19)
  switch(i,
    "1" = {
      mtext("low variance", 3, cex = 2)
      mtext("low bias", 2, cex = 2)
    },
    "2" = mtext("high variance", 3, cex = 2),
    "3" = mtext("high bias", 2, cex = 2)
  )
}

