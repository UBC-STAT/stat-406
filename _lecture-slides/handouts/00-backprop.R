relu <- function(x) x * (x > 0)
relup <- function(x) x > 0

initialize_backprop <- function(n_hidden, p, M, sd = .1) {
  z <- c(p, n_hidden, M)
  W <- list()
  for (i in seq_along(z[-1])) 
    W[[i]] <- matrix(rnorm(z[i+1]*z[i], sd = sd), nrow = z[i])
  W
}


backprop <- function(X, y, W0, g_fun = relu, gp_fun = relup) {
  # check inputs
  stopifnot(is.matrix(X))
  stopifnot((n <- nrow(X)) == length(y))
  if (!is.list(W0)) W0 <- list(W0)
  L <- length(W0)
  
  # Feed forward
  Z <- list()
  A <- list()
  Ap <- list()
  A[[1]] <- X
  for (l in 1:L) {
    Z[[l]] <- A[[l]] %*% W0[[l]]
    if (l < L) {
      A[[l+1]] = g_fun(Z[[l]])
      Ap[[l]] = gp_fun(Z[[l]])
    }
  }
  
  # Did we do classification? (Assume y is 1-hot encoded)
  if (ncol(Z[[L]]) > 1) {
    phat <- 1 / (1 + exp(-Z[[L]])) * y
    r <- phat * (1 - phat) # gradient of log loss
  } else r <- - (y - drop(Z[[L + 1]])) # gradient of 0.5*(y-yhat)^2
  
  # Back propogate (calculate the gradients of the whole thing)
  dW <- list()
  dW[[L]] <- crossprod(A[[L]], r)
  Gamma <- r
  for (l in rev(seq_along(Ap))) {
    Gamma <- tcrossprod(Gamma, W0[[l+1]]) * Ap[[l]]
    dW[[l]] <- crossprod(A[[l]], Gamma )
  }
  
  names(dW) = c(paste0("dW",1:L))
  dW
}