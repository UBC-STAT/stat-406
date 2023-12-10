## -------------------------------------------------------------------------------
cv_nice <- function(mdl) mean((residuals(mdl) / (1 - hatvalues(mdl)))^2)

