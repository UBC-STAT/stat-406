library(truncnorm)
library(tidyverse)
simulate_marks <- function(n_assignments = 5, n_students = 120, 
                           means = c(6,7,8,8,9),
                           sds = rep(2, n_assignments)) {
  matrix(
    rtruncnorm(n_assignments * n_students, 0, 10, rep(means, each = n_students),
               rep(sds, each = n_students)),
    ncol = n_assignments)
}

X <- simulate_marks()
X %>%
  as_tibble() %>%
  pivot_longer(everything()) %>%
  ggplot(aes(value, color = name)) + geom_density() + theme_bw() + 
  scale_color_viridis_d()


drop_lowest <- function(X) {
  apply(X, 1, function(x) {
    x[which.min(x)] = NA
    mean(x, na.rm = TRUE)
  })
}

drop_random <- function(X, w = rep(1/ncol(X), ncol(X))) {
  apply(X, 1, function(x) {
    x[sample.int(length(x), 1, prob = w)] = NA
    mean(x, na.rm = TRUE)
  })
}

marks <- tibble(complete = apply(X, 1, mean), drop_lowest = drop_lowest(X),
                drop_random = drop_random(X),
                drop_early = drop_random(X, w = c(.4, .3, .1,.1, .1)))
marks %>%
  pivot_longer(everything()) %>%
  ggplot(aes(value, color = name)) + geom_density() + theme_bw() + 
  scale_color_viridis_d()

early_droppers <- function(X, w = rep(1/ncol(X), ncol(X))) {
  dropped <- sample.int(ncol(X), nrow(X), replace = TRUE, prob = w)
  Z <- X
  Z[cbind(1:nrow(X), dropped)] <- NA
  tibble(avg = rowMeans(Z, TRUE), dropped = as.factor(dropped))
}

early_droppers(X, c(.4, .3, .1, .1, .1)) %>%
  ggplot(aes(avg, color = dropped)) + geom_density() + theme_bw() +
  scale_color_viridis_d()

dropped <- early_droppers(X, c(.4, .3, .1, .1, .1))$dropped

Z <- X
Z[cbind(1:nrow(X), dropped)] <- NA



imputer <- function(gmat, meth = lm, maxit = 30, tol = 1e-6) {
  # Loop over columns until converged
  #  1. Set y = nonmissing, X = completed columns
  #  2. regress y on X using meth()
  #  3. predict missing y with completed X, and fill in missing y
  miss <- is.na(gmat)
  start_vals <- colMeans(gmat, na.rm = TRUE)
  cols_miss <- which(miss) %/% nrow(gmat) + 1
  init <- gmat[miss]
  init <- start_vals[cols_miss]
  filled <- gmat
  filled[miss] <- init
  for (iter in 1:maxit) {
    for (j in 1:ncol(gmat)) {
      y <- filled[!miss[,j],j]
      X <- filled[!miss[,j], -j]
      Xpred <- filled[miss[,j], -j]
      fit <- meth(y~X)
      filled[miss[,j], j] <- pmin(
        pmax(drop(cbind(1, Xpred) %*% coef(fit)), 0), 10)
    }
    new <- filled[miss]
    if (mean(abs(new - init) < tol)) break
    init <- new
  }
  print(iter)
  filled
}

newZ <- imputer(Z)

obs_marks <- tibble(avg = rowMeans(Z, na.rm = TRUE), dropped = dropped)
imputed_marks <- tibble(avg = drop_lowest(newZ), dropped = dropped)

obs_marks %>% group_by(dropped) %>% summarise(mean(avg))
imputed_marks %>% group_by(dropped) %>% summarise(mean(avg))
