relu <- function(x) x * (x > 0)
relup <- function(x) x > 0

#' Do back propagation to find the gradient 
#' 
#' Finds the gradients for W for a fully connected Neural Network.
#' Should work for both regression/classification.
#'
#' @param X Matrix. Predictors in n x p (observed).
#' @param y Response. If classification, an n x M matrix where M is the number
#'   of classes and each column contains 0/1. If regression, a vector of 
#'   length n
#' @param W0 List. Each component is a matrix of appropriate size. The length
#'   of the list is the number of hidden layers + 1 for the output layer.
#' @param g_fun Function. The activation function.
#' @param gp_fun Function. Gradient of the activation function.
#'
#' @return A list of gradients of the same length as `W0`.
backprop <- function(X, y, W0, g_fun = relu, gp_fun = relup) {
  # Basic input checks
  stopifnot(is.matrix(X))
  n <- nrow(X)
  if (is.matrix(y) && n != nrow(y)) 
    stop("number of observations in X/y is different")
  if (is.vector(m) && n != length(y))
    stop("number of observations in X/y is different")
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
    phat <- rowSums(1 / (1 + exp(-Z[[L]])) * y)
    r <- - (1 - phat) # gradient of log loss
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