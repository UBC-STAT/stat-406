## -------------------------------------------------------------------------------
#| code-fold: true
library(kableExtra)
library(randomForest)
mob <- Stat406::mobility |>
  mutate(mobile = as.factor(Mobility > .1)) |>
  select(-ID, -Name, -Mobility, -State) |>
  drop_na()
n <- nrow(mob)
trainidx <- sample.int(n, floor(n * .75))
testidx <- setdiff(1:n, trainidx)
train <- mob[trainidx, ]
test <- mob[testidx, ]
rf <- randomForest(mobile ~ ., data = train)
bag <- randomForest(mobile ~ ., data = train, mtry = ncol(mob) - 1)
preds <- tibble(truth = test$mobile, rf = predict(rf, test), bag = predict(bag, test))


## -------------------------------------------------------------------------------
#| output-location: column-fragment
#| fig-width: 6
#| fig-height: 6
#| code-line-numbers: "1-6|7-12|17|"
library(gbm)
train_boost <- train |>
  mutate(mobile = as.integer(mobile) - 1)
# needs {0, 1} responses
test_boost <- test |>
  mutate(mobile = as.integer(mobile) - 1)
adab <- gbm(
  mobile ~ .,
  data = train_boost,
  n.trees = 500,
  distribution = "adaboost"
)
preds$adab <- as.numeric(
  predict(adab, test_boost) > 0
)
par(mar = c(5, 11, 0, 1))
s <- summary(adab, las = 1)


## ----loss-funs------------------------------------------------------------------
#| echo: false
#| fig-width: 9
#| fig-height: 4
losses <- tibble(
  x = seq(-2, 2, length.out = 100),
  `Misclassification (0-1)` = as.numeric(x < 0),
  Exponential = exp(-x),
  `Binomial deviance` = log2(1 + exp(-x)),
  `Squared error` = (x - 1)^2,
  `Support vector` = pmax((1 - x), 0)
)
losses |>
  pivot_longer(-x) |>
  ggplot(aes(x, y = value, color = name)) +
  geom_line(size = 1.5) +
  coord_cartesian(ylim = c(0, 3)) +
  theme(legend.title = element_blank()) +
  scale_color_viridis_d() +
  ylab("Loss") +
  xlab(bquote(y ~ f(x) ~ (Margin)))


## ----gbm------------------------------------------------------------------------
grad_boost <- gbm(mobile ~ ., data = train_boost, n.trees = 500, distribution = "bernoulli")


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 10
#| fig-height: 5
library(cowplot)
boost_preds <- tibble(
  adaboost = predict(adab, test_boost),
  gbm = predict(grad_boost, test_boost),
  truth = test$mobile
)
g1 <- ggplot(boost_preds, aes(adaboost, gbm, color = as.factor(truth))) +
  geom_text(aes(label = as.integer(truth) - 1)) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  xlab("adaboost margin") +
  ylab("gbm margin") +
  theme(legend.position = "none") +
  scale_color_manual(values = c("orange", "blue")) +
  annotate("text",
    x = -4, y = 5, color = red,
    label = paste(
      "gbm error\n",
      round(with(boost_preds, mean((gbm > 0) != truth)), 2)
    )
  ) +
  annotate("text",
    x = 4, y = -5, color = red,
    label = paste("adaboost error\n", round(with(boost_preds, mean((adaboost > 0) != truth)), 2))
  )
boost_oob <- tibble(
  adaboost = adab$oobag.improve, gbm = grad_boost$oobag.improve,
  ntrees = 1:500
)
g2 <- boost_oob %>%
  pivot_longer(-ntrees, values_to = "OOB_Error") %>%
  ggplot(aes(x = ntrees, y = OOB_Error, color = name)) +
  geom_line() +
  scale_color_manual(values = c(orange, blue)) +
  theme(legend.title = element_blank())
plot_grid(g1, g2, rel_widths = c(.4, .6))

