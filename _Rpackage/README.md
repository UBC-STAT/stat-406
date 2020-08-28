
<!-- README.md is generated from README.Rmd. Please edit that file -->

# UBCstat406labs

<!-- badges: start -->

<!-- badges: end -->

The goal of UBCstat406labs is to be a one-stop install for all the
packages, tutorials, and custom code used in UBC’s Stat 406 course.

## Installation

You can install the current version from [GitHub](https://github.com/)
with:

``` r
# install.packages("devtools")
devtools::install_github("dajmcdon/ubc-stat406-labs")
```

## Example

This is a basic example which shows you how to run a tutorial:

``` r
library(UBCstat406labs)
learnr::run_tutorial("rsquared","UBCstat406labs")
```

Currently available tutorials are:

``` r
learnr::available_tutorials("UBCstat406labs")
#> Available tutorials:
#> * UBCstat406labs
#>   - bootstrapping         : "Bootstrapping"
#>   - correlated-predictors : "Correlated predictors"
#>   - economicmobility      : "Predicting economic mobility"
#>   - ftest                 : "F-test for Linear Regression"
#>   - gradientascent        : "Gradient Ascent: Logistic Regression"
#>   - gradientdescent       : "Gradient Descent"
#>   - irisqda               : "Quadratic Discriminant Analysis "
#>   - knn                   : "K-Nearest Neighbors"
#>   - laplacianeigenmaps    : "Laplacian Eigenmaps"
#>   - logtransformations    : "Log Transformations on Linear Regression"
#>   - rsquared              : "R-squared and garbage predictors"
#>   - selectioncriterion    : "Comparing AIC, BIC, and CV"
#>   - treesandleaves        : "Trees and Leaves"
#>   - weightedleastsquares  : "Weighted Least Squares"
```
