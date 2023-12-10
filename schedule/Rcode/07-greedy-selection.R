## -------------------------------------------------------------------------------
dat <- tibble(
  x1 = rnorm(100), 
  x2 = rnorm(100),
  y = 3 + x1 - 5 * x2 + sin(x1 * x2 / (2 * pi)) + rnorm(100, sd = 5)
)


## -------------------------------------------------------------------------------
forms <- list("y ~ x1 + x2", "y ~ x1 * x2", "y ~ x2 + sin(x1*x2)") |> 
  map(as.formula)
fits <- map(forms, ~ lm(.x, data = dat))
map(fits, ~ tibble(
  R2 = summary(.x)$r.sq,
  training_error = mean(residuals(.x)^2),
  loocv = mean( (residuals(.x) / (1 - hatvalues(.x)))^2 ),
  AIC = AIC(.x),
  BIC = BIC(.x)
)) |> list_rbind()


## ----data-setup-----------------------------------------------------------------
set.seed(123)
n <- 406
df <- tibble( # like data.frame, but columns can be functions of preceding
  x1 = rnorm(n),
  x2 = rnorm(n, mean = 2, sd = 1),
  x3 = rexp(n, rate = 1),
  x4 = x2 + rnorm(n, sd = .1), # correlated with x2
  x5 = x1 + rnorm(n, sd = .1), # correlated with x1
  x6 = x1 - x2 + rnorm(n, sd = .1), # correlated with x2 and x1 (and others)
  x7 = x1 + x3 + rnorm(n, sd = .1), # correlated with x1 and x3 (and others)
  y = x1 * 3 + x2 / 3 + rnorm(n, sd = 2.2) # function of x1 and x2 only
)


## ----full-model-----------------------------------------------------------------
full <- lm(y ~ ., data = df)
summary(full)


## ----true-model-----------------------------------------------------------------
truth <- lm(y ~ x1 + x2, data = df)
summary(truth)


## ----try-them-all---------------------------------------------------------------
library(leaps)
trythemall <- regsubsets(y ~ ., data = df)
summary(trythemall)


## ----more-all-subsets1----------------------------------------------------------
#| output-location: column
#| fig-height: 6
#| fig-width: 8
tibble(
  BIC = summary(trythemall)$bic, 
  Cp = summary(trythemall)$cp,
  size = 1:7
) |>
  pivot_longer(-size) |>
  ggplot(aes(size, value, colour = name)) + 
  geom_point() + 
  geom_line() + 
  facet_wrap(~name, scales = "free_y") + 
  ylab("") +
  scale_colour_manual(
    values = c(blue, orange), 
    guide = "none"
  )


## ----step-forward---------------------------------------------------------------
stepup <- regsubsets(y ~ ., data = df, method = "forward")
summary(stepup)


## ----more-step-forward----------------------------------------------------------
#| output-location: column
#| fig-height: 6
#| fig-width: 8
tibble(
  BIC = summary(stepup)$bic,
  Cp = summary(stepup)$cp,
  size = 1:7
) |>
  pivot_longer(-size) |>
  ggplot(aes(size, value, colour = name)) +
  geom_point() +
  geom_line() +
  facet_wrap(~name, scales = "free_y") +
  ylab("") +
  scale_colour_manual(
    values = c(blue, orange),
    guide = "none"
  )


## ----step-backward--------------------------------------------------------------
stepdown <- regsubsets(y ~ ., data = df, method = "backward")
summary(stepdown)


## ----more-step-backward---------------------------------------------------------
#| output-location: column
#| fig-height: 6
#| fig-width: 8
tibble(
  BIC = summary(stepdown)$bic,
  Cp = summary(stepdown)$cp,
  size = 1:7
) |>
  pivot_longer(-size) |>
  ggplot(aes(size, value, colour = name)) +
  geom_point() +
  geom_line() +
  facet_wrap(~name, scales = "free_y") +
  ylab("") +
  scale_colour_manual(
    values = c(blue, orange), 
    guide = "none"
  )


## ----predict-regsubsets---------------------------------------------------------
#| code-line-numbers: "|2"
predict.regsubsets <- function(object, newdata, risk_estimate = c("cp", "bic"), ...) {
  risk_estimate <- match.arg(risk_estimate)
  chosen <- coef(object, which.min(summary(object)[[risk_estimate]]))
  predictors <- names(chosen)
  if (object$intercept) predictors <- predictors[-1]
  X <- newdata[, predictors]
  if (object$intercept) X <- cbind2(1, X)
  drop(as.matrix(X) %*% chosen)
}


## ----replication-exercise-------------------------------------------------------
simulate_and_estimate_them_all <- function(n = 406) {
  N <- 2 * n # generate 2x the amount of data (half train, half test)
  df <- tibble( # generate data
    x1 = rnorm(N), 
    x2 = rnorm(N, mean = 2), 
    x3 = rexp(N),
    x4 = x2 + rnorm(N, sd = .1), 
    x5 = x1 + rnorm(N, sd = .1),
    x6 = x1 - x2 + rnorm(N, sd = .1), 
    x7 = x1 + x3 + rnorm(N, sd = .1),
    y = x1 * 3 + x2 / 3 + rnorm(N, sd = 2.2)
  )
  train <- df[1:n, ] # half the data for training
  test <- df[(n + 1):N, ] # half the data for evaluation
  
  oracle <- lm(y ~ x1 + x2 - 1, data = train) # knowing the right model, not the coefs
  full <- lm(y ~ ., data = train)
  stepup <- regsubsets(y ~ ., data = train, method = "forward")
  stepdown <- regsubsets(y ~ ., data = train, method = "backward")
  
  tibble(
    y = test$y,
    oracle = predict(oracle, newdata = test),
    full = predict(full, newdata = test),
    stepup = predict(stepup, newdata = test),
    stepdown = predict(stepdown, newdata = test),
    truth = drop(as.matrix(test[, c("x1", "x2")]) %*% c(3, 1/3))
  )
}

set.seed(12345)
our_sim <- map(1:50, ~ simulate_and_estimate_them_all(406)) |>
  list_rbind(names_to = "sim")


## ----synth-results--------------------------------------------------------------
#| output-location: column
#| fig-height: 6
#| fig-width: 6
our_sim |> 
  group_by(sim) %>%
  summarise(
    across(oracle:truth, ~ mean((y - .)^2)), 
    .groups = "drop"
  ) %>%
  transmute(across(oracle:stepdown, ~ . / truth - 1)) |> 
  pivot_longer(
    everything(), 
    names_to = "method", 
    values_to = "mse"
  ) |> 
  ggplot(aes(method, mse, fill = method)) +
  geom_boxplot(notch = TRUE) +
  geom_hline(yintercept = 0, linewidth = 2) +
  scale_fill_viridis_d() +
  theme(legend.position = "none") +
  scale_y_continuous(
    labels = scales::label_percent()
  ) +
  ylab("% increase in mse relative\n to the truth")

