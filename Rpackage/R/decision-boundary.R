#' Plot decision boundary for a classifier with 2 predictors
#'
#' @param fitted_model a fitted classifier object, for example the result of `glm(...)`
#' @param y the original observed classes
#' @param x1 original first predictor
#' @param x2 original second predictor
#' @param predict_type default is `NULL`, many predict methods accept a `type`
#'   argument, if known, this can help to produce classifications
#' @param predict_fun if your classifier is different than one of the standard
#'   methods (see below) you can pass a custom function which accepts a single
#'   argument g (a new data dataframe with columns) and produces a vector
#'   of classes
#' @param resolution number of points along the two dimensions to produce classes
#' @param showgrid do we plot a grid of predictions
#' @param ... additional arguments passed to `plot()`
#'
#' @return If assigned to an object, returns the matrix of predicted classes
#' 
#' @details This function should work with only the mandatory arguments if the 
#'   classifier is produced via `glm()`, `MASS::lda()`, `MASS::qda()` or from either
#'   `multinom()` or `nnet()` in the `{nnet}` package. Other classifiers likely 
#'   require additional instructions. If the `predict` method produces integer 
#'   or factor labels as output, it should just "work".
#'
#' @export
#'
#' @examples
#' x1 = runif(100,-1,1)
#' x2 = runif(100,-1,1)
#' y = rbinom(100, 1, 1/(1+exp(-2*x1-3*x2)))
#' 
#' logit = glm(y~x1+x2, family="binomial")
#' disc = MASS::lda(y~x1+x2)
#' 
#' par(mfrow=c(1,2))
#' decision_boundary(logit, y, x1, x2)
#' decision_boundary(disc, y, x1, x2)
#' par(mfrow=c(1,1))
decision_boundary <- function(fitted_model, y, x1, x2, 
                         predict_type = NULL,
                         predict_fun = NULL,
                         resolution = 100, showgrid = TRUE, ...) {
  cl <- as.factor(y)
  k <- nlevels(cl)
  plot(x1, x2, col = as.integer(cl)+1L, pch = as.integer(cl)+1L, ...)
  # make grid
  r <- sapply(list(x1, x2), range, na.rm = TRUE)
  xs <- seq(r[1,1], r[2,1], length.out = resolution)
  ys <- seq(r[1,2], r[2,2], length.out = resolution)
  g <- cbind(rep(xs, each=resolution), rep(ys, time = resolution))
  colnames(g) <- attr(terms(fitted_model),"term.labels")
  g <- as.data.frame(g)
  ### guess how to get class labels from predict
  ### (unfortunately not very consistent between models)
  if(!is.null(predict_fun)){
    p = predict_fun(g)
  } else{ 
    if(is.null(predict_type)){
      p = switch( 
        class(fitted_model)[1],
        glm = factor(round(predict(fitted_model, newdata=g, type = "response"))),
        lda = predict(fitted_model,newdata=g)$class,
        qda = predict(fitted_model,newdata=g)$class,
        multinom = predict(fitted_model,newdata=g),
        nnet = predict(fitted_model,newdata=g),
        predict(fitted_model,newdata=g) # here we hope
        )
    } else {
      p <- predict(fitted_model, newdata=g, type = predict_type)
    }
  }
  if(showgrid) points(g[[1]], g[[2]], col = as.integer(p)+1L, pch = ".")
  
  z <- matrix(as.integer(p), nrow = resolution, byrow = TRUE)
  contour(xs, ys, z, add = TRUE, drawlabels = FALSE,
          lwd = 2, levels = (1:(k-1))+.5)
  invisible(z)
}
