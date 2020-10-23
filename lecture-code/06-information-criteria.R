## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----------------------------------------------------------------------------------------
cv_nice <- function(mdl) mean((residuals(mdl)/(1-hatvalues(mdl)))^2)

