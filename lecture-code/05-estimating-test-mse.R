## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ---- fig.align='center',echo=FALSE,fig.height=6, fig.width=10---------------------------
par(mar=c(0,0,0,0))
plot(NA, NA, ylim=c(0,5), xlim=c(0,10), bty='n', yaxt='n', xaxt='n')
rect(0,.1+c(0,2,3,4),10,.9+c(0,2,3,4), col=blue, density=10)
rect(c(0,1,2,9),rev(.1+c(0,2,3,4)),c(1,2,3,10),rev(.9+c(0,2,3,4)),col=red, density=10)
points(c(5,5,5),1+1:3/4,pch=19)
text(.5+c(0,1,2,9),.5+c(4,3,2,0),c("1","2","3","K"), cex=3, col=red)
text(6,4.5,'Training data',cex=3, col=blue)
text(2,1.5,'Testing data',cex=3,col=red)


## ---- eval=FALSE-------------------------------------------------------------------------
## kfold_cv <- function(data, estimator, predictor, kfolds = 5, responsename="y") {
##   n <- nrow(data)
##   fold.labels <- sample(rep(1:kfolds, length.out = n))
##   mses <- double(kfolds)
##   for (fold in 1:kfolds) {
##     test.rows <- which(fold.labels == fold)
##     train <- data[-test.rows, ]
##     test <- data[test.rows, ]
##     current_model <- estimator(..., data = train)
##     predictions <- predictor(current.model, ..., newdata = test)
##     test_responses <- test[, responsename]
##     test_errors <- test_responses - predictions
##     mses[fold] <- mean(test_errors^2)
##   }
##   mean(mses)
## }


## ----------------------------------------------------------------------------------------
cv_nice <- function(mdl) mean((residuals(mdl)/(1-hatvalues(mdl)))^2)

