## ----echo=FALSE, R.options=list(scipen=8)---------------------------------------
matrix(c(0, 10, 1000000, 2, 0, 50000, 30, 100, 0), nrow = 3)


## -------------------------------------------------------------------------------
#| code-line-numbers: "1-6|7|8-9"
#| output-location: fragment
n <- 250
dat <- tibble(
  x = seq(-5, 5, length.out = n),
  p = 1 / (1 + exp(-x)),
  y = rbinom(n, 1, p)
)
fit <- glm(y ~ x, family = binomial, data = dat)
dat$phat <- predict(fit, type = "response") # predicted probabilities
dat |>
  filter(phat > .15, phat < .25) |>
  summarize(target = .2, obs = mean(y))


## -------------------------------------------------------------------------------
binary_calibration_plot <- function(y, phat, nbreaks = 10) {
  dat <- tibble(y = y, phat = phat) |>
    mutate(bins = cut_number(phat, n = nbreaks))
  midpts <- quantile(dat$phat, seq(0, 1, length.out = nbreaks + 1), na.rm = TRUE)
  midpts <- midpts[-length(midpts)] + diff(midpts) / 2
  sum_dat <- dat |>
    group_by(bins) |>
    summarise(
      p = mean(y, na.rm = TRUE),
      se = sqrt(p * (1 - p) / n())
    ) |>
    arrange(p)
  sum_dat$x <- midpts

  ggplot(sum_dat, aes(x = x)) +
    geom_errorbar(aes(ymin = pmax(p - 1.96 * se, 0), ymax = pmin(p + 1.96 * se, 1))) +
    geom_point(aes(y = p), colour = blue) +
    geom_abline(slope = 1, intercept = 0, colour = orange) +
    ylab("observed frequency") +
    xlab("average predicted probability") +
    coord_cartesian(xlim = c(0, 1), ylim = c(0, 1)) +
    geom_rug(data = dat, aes(x = phat), sides = "b")
}


## -------------------------------------------------------------------------------
#| fig-width: 8
#| fig-height: 5
binary_calibration_plot(dat$y, dat$phat, 20L)


## ----echo=FALSE-----------------------------------------------------------------
#| fig-width: 8
#| fig-height: 5
binary_calibration_plot(rbinom(250, 1, 0.5), rbeta(250, 1.3, 1), 15L)


## -------------------------------------------------------------------------------
#| output-location: column-fragment
#| fig-width: 8
#| fig-height: 6
roc <- function(prediction, y) {
  op <- order(prediction, decreasing = TRUE)
  preds <- prediction[op]
  y <- y[op]
  noty <- 1 - y
  if (any(duplicated(preds))) {
    y <- rev(tapply(y, preds, sum))
    noty <- rev(tapply(noty, preds, sum))
  }
  tibble(
    FPR = cumsum(noty) / sum(noty),
    TPR = cumsum(y) / sum(y)
  )
}

ggplot(roc(dat$phat, dat$y), aes(FPR, TPR)) +
  geom_step(colour = blue, size = 2) +
  geom_abline(slope = 1, intercept = 0)

