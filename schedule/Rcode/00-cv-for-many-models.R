## -------------------------------------------------------------------------------
data("mobility", package = "Stat406")


## ----stuff-i-need---------------------------------------------------------------
kfold_cv <- function(data, estimator, predictor, error_fun, kfolds = 5) {
  fold_labels <- sample(rep(seq_len(kfolds), length.out = nrow(data)))
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

loo_cv <- function(dat) {
  mdl <- lm(Mobility ~ ., data = dat)
  mean( abs(residuals(mdl)) / abs(1 - hatvalues(mdl)) ) # MAE version
}


## -------------------------------------------------------------------------------
# prepare our data
# note that mob has only continuous predictors, otherwise could be trouble
mob <- mobility[complete.cases(mobility), ] |> select(-ID, -State, -Name)
# avoid doing this same operation a bunch
xmat <- function(dat) dat |> select(!Mobility) |> as.matrix()

# set up our model functions
library(glmnet)
mod1 <- function(dat, ...) cv.glmnet(xmat(dat), dat$Mobility, type.measure = "mae", ...)
mod2 <- function(dat, ...) cv.glmnet(xmat(dat), dat$Mobility, alpha = 0, type.measure = "mae", ...)
mod3 <- function(dat, ...) glmnet(xmat(dat), dat$Mobility, lambda = 0, ...) # just does lm()
mod4 <- function(dat, ...) cv.glmnet(xmat(dat), dat$Mobility, relax = TRUE, gamma = 1, type.measure = "mae", ...)

# this will still "work" on mod3, because there's only 1 s
predictor <- function(mod, dat) drop(predict(mod, newx = xmat(dat), s = "lambda.min"))

# chose mean absolute error just 'cause
error_fun <- function(testdata) mean(abs(testdata$Mobility - testdata$.preds))


## -------------------------------------------------------------------------------
all_model_funs <- lst(mod1, mod2, mod3, mod4)
all_fits <- map(all_model_funs, .f = exec, dat = mob)

# unfortunately, does different splits for each method, so we use 10, 
# it would be better to use the _SAME_ splits
ten_fold_cv <- map_dbl(all_model_funs, ~ kfold_cv(mob, .x, predictor, error_fun, 10)) 

in_sample_cv <- c(
  mod1 = min(all_fits[[1]]$cvm),
  mod2 = min(all_fits[[2]]$cvm),
  mod3 = loo_cv(mob),
  mod4 = min(all_fits[[4]]$cvm)
)

tib <- bind_rows(in_sample_cv, ten_fold_cv)
tib$method = c("in_sample", "out_of_sample")
tib

