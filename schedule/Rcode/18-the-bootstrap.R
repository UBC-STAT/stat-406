## -------------------------------------------------------------------------------
#| code-fold: true
r <- rexp(50, 1 / 5)
ggplot(tibble(r = r), aes(r)) + 
  stat_ecdf(colour = orange) +
  geom_vline(xintercept = quantile(r, probs = c(.05, .95))) +
  geom_hline(yintercept = c(.05, .95), linetype = "dashed") +
  annotate(
    "label", x = c(5, 12), y = c(.25, .75), 
    label = c("hat(F)[boot](.05)", "hat(F)[boot](.95)"), 
    parse = TRUE
  )


## -------------------------------------------------------------------------------
#| code-fold: true
ggplot(data.frame(x = c(0, 12)), aes(x)) +
  stat_function(fun = function(x) dexp(x, 1 / 5), color = orange) +
  geom_vline(xintercept = 5, color = blue) + # mean
  geom_vline(xintercept = qexp(.5, 1 / 5), color = red) + # median
  annotate("label",
    x = c(2.5, 5.5, 10), y = c(.15, .15, .05),
    label = c("median", "bar(x)", "pdf"), parse = TRUE,
    color = c(red, blue, orange), size = 6
  )


## ----echo=FALSE-----------------------------------------------------------------
n <- 500


## -------------------------------------------------------------------------------
set.seed(406406406)
x <- rexp(n, 1 / 5)
(med <- median(x)) # sample median
B <- 100
alpha <- 0.05
Fhat <- map_dbl(1:B, ~ median(sample(x, replace = TRUE))) # repeat B times, "empirical distribution"
CI <- 2 * med - quantile(Fhat, probs = c(1 - alpha / 2, alpha / 2))


## -------------------------------------------------------------------------------
#| code-fold: true
ggplot(data.frame(Fhat), aes(Fhat)) +
  geom_density(color = orange) +
  geom_vline(xintercept = CI, color = orange, linetype = 2) +
  geom_vline(xintercept = med, col = blue) +
  geom_vline(xintercept = qexp(.5, 1 / 5), col = red) +
  annotate("label",
    x = c(3.15, 3.5, 3.75), y = c(.5, .5, 1),
    color = c(orange, red, blue),
    label = c("widehat(F)", "true~median", "widehat(median)"),
    parse = TRUE
  ) +
  xlab("x") +
  geom_rug(aes(2 * med - Fhat))


## ----echo=FALSE-----------------------------------------------------------------
library(MASS)
fatcats <- cats
fatcats$Hwt <- fitted(lm(Hwt ~ Bwt + 0, data = cats)) + rt(nrow(fatcats), 2)
fatcats <- fatcats %>% mutate(Hwt = pmin(pmax(Hwt, 3), 900 * Bwt))


## -------------------------------------------------------------------------------
#| fig-height: 5
#| fig-width: 6
ggplot(fatcats, aes(Bwt, Hwt)) +
  geom_point(color = blue) +
  xlab("Cat body weight (Kg)") +
  ylab("Cat heart weight (g)")


## -------------------------------------------------------------------------------
cats.lm <- lm(Hwt ~ 0 + Bwt, data = fatcats)
summary(cats.lm)
confint(cats.lm)


## -------------------------------------------------------------------------------
#| fig-height: 5
#| fig-width: 6
qqnorm(residuals(cats.lm), pch = 16, col = blue)
qqline(residuals(cats.lm), col = orange, lwd = 2)


## -------------------------------------------------------------------------------
B <- 500
alpha <- .05
bhats <- map_dbl(1:B, ~ {
  newcats <- fatcats |>
    slice_sample(prop = 1, replace = TRUE)
  coef(lm(Hwt ~ 0 + Bwt, data = newcats))
})

2 * coef(cats.lm) - # Bootstrap CI
  quantile(bhats, probs = c(1 - alpha / 2, alpha / 2))
confint(cats.lm) # Original CI


## -------------------------------------------------------------------------------
B <- 500
alpha <- .05
bhats <- map_dbl(1:B, ~ {
  newcats <- fatcats |>
    slice_sample(prop = 1, replace = TRUE)
  coef(lm(Hwt ~ 0 + Bwt, data = newcats))
})

2 * coef(cats.lm) - # NP Bootstrap CI
  quantile(bhats, probs = c(1 - alpha / 2, alpha / 2))
confint(cats.lm) # Original CI


## -------------------------------------------------------------------------------
B <- 500
bhats <- double(B)
cats.lm <- lm(Hwt ~ 0 + Bwt, data = fatcats)
r <- residuals(cats.lm)
bhats <- map_dbl(1:B, ~ {
  newcats <- fatcats |> mutate(
    Hwt = predict(cats.lm) +
      sample(r, n(), replace = TRUE)
  )
  coef(lm(Hwt ~ 0 + Bwt, data = newcats))
})

2 * coef(cats.lm) - # Parametric Bootstrap CI
  quantile(bhats, probs = c(1 - alpha / 2, alpha / 2))

