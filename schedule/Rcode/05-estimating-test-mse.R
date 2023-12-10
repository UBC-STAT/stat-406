## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-height: 8
#| fig-width: 8
ans <- anscombe |>
  pivot_longer(everything(), names_to = c(".value", "set"), 
               names_pattern = "(.)(.)")
ggplot(ans, aes(x, y)) + 
  geom_point(colour = orange, size = 3) + 
  geom_smooth(method = "lm", se = FALSE, color = blue, linewidth = 2) +
  facet_wrap(~set, labeller = label_both)


## -------------------------------------------------------------------------------
ans %>% 
  group_by(set) |> 
  summarise(
    R2 = summary(lm(y ~ x))$r.sq, 
    train_error = mean((y - predict(lm(y ~ x)))^2)
  ) |>
  kableExtra::kable(digits = 2)


## -------------------------------------------------------------------------------
n <- 100
p <- 10
q <- 0:30
x <- matrix(rnorm(n * (p + max(q))), nrow = n)
y <- x[, 1:p] %*% c(5:1, 1:5) + rnorm(n, 0, 10)

regress_on_junk <- function(q) {
  x <- x[, 1:(p + q)]
  mod <- lm(y ~ x)
  tibble(R2 = summary(mod)$r.sq,  train_error = mean((y - predict(mod))^2))
}


## -------------------------------------------------------------------------------
#| code-fold: true
map(q, regress_on_junk) |> 
  list_rbind() |>
  mutate(q = q) |>
  pivot_longer(-q) |>
  ggplot(aes(q, value, colour = name)) +
  geom_line(linewidth = 2) + xlab("train_error") +
  scale_colour_manual(values = c(blue, orange), guide = "none") +
  facet_wrap(~ name, scales = "free_y")


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-height: 6
#| fig-width: 10
par(mar = c(0, 0, 0, 0))
plot(NA, NA, ylim = c(0, 5), xlim = c(0, 10), bty = "n", yaxt = "n", xaxt = "n")
rect(0, .1 + c(0, 2, 3, 4), 10, .9 + c(0, 2, 3, 4), col = blue, density = 10)
rect(c(0, 1, 2, 9), rev(.1 + c(0, 2, 3, 4)), c(1, 2, 3, 10), 
     rev(.9 + c(0, 2, 3, 4)), col = red, density = 10)
points(c(5, 5, 5), 1 + 1:3 / 4, pch = 19)
text(.5 + c(0, 1, 2, 9), .5 + c(4, 3, 2, 0), c("1", "2", "3", "K"), cex = 3, 
     col = red)
text(6, 4.5, "Training data", cex = 3, col = blue)
text(2, 1.5, "Validation data", cex = 3, col = red)


## -------------------------------------------------------------------------------
#| code-line-numbers: "11-13|14-16|"
#' @param data The full data set
#' @param estimator Function. Has 1 argument (some data) and fits a model. 
#' @param predictor Function. Has 2 args (the fitted model, the_newdata) and produces predictions
#' @param error_fun Function. Has one arg: the test data, with fits added.
#' @param kfolds Integer. The number of folds.
kfold_cv <- function(data, estimator, predictor, error_fun, kfolds = 5) {
  n <- nrow(data)
  fold_labels <- sample(rep(1:kfolds, length.out = n))
  errors <- double(kfolds)
  for (fold in seq_len(kfolds)) {
    test_rows <- fold_labels == fold
    train <- data[!test_rows, ]
    test <- data[test_rows, ]
    current_model <- estimator(train)
    test$.preds <- predictor(current_model, test)
    errors[fold] <- error_fun(test)
  }
  mean(errors)
}


## -------------------------------------------------------------------------------
#| code-line-numbers: "2-4|"
somedata <- data.frame(z = rnorm(100), x1 = rnorm(100), x2 = rnorm(100))
est <- function(dataset) lm(z ~ ., data = dataset)
pred <- function(mod, dataset) predict(mod, newdata = dataset)
error_fun <- function(testdata) mutate(testdata, errs = (z - .preds)^2) |> pull(errs) |> mean()
kfold_cv(somedata, est, pred, error_fun, 5)


## -------------------------------------------------------------------------------
cv_nice <- function(mdl) mean( (residuals(mdl) / (1 - hatvalues(mdl)))^2 )


## -------------------------------------------------------------------------------
cv_nice <- function(mdl) mean( (residuals(mdl) / (1 - hatvalues(mdl)))^2 )

