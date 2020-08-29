
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Labs and Data for UBC Stat 406

<!-- badges: start -->

<!-- badges: end -->

The goal of `UBCstat406labs` is to be a one-stop install for all the
packages, tutorials, and custom code used in UBC’s Stat 406 course.

## Installation

You can install the current version from [GitHub](https://github.com/)
with:

``` r
# install.packages("remotes")
remotes::install_github("ubc-stat/stat-406/Rpackage", dependencies = TRUE)
```

## Example

This is a basic example which shows you currently available labs:

``` r
library(UBCstat406labs)
show_labs()
#> Available tutorials:
#> * UBCstat406labs
#>   - bootstrapping           : "Bootstrapping"
#>   - correlated-predictors   : "Correlated predictors"
#>   - curse-of-dimensionality : "The curse..."
#>   - economicmobility        : "Predicting economic mobility"
#>   - ftest                   : "F-test for Linear Regression"
#>   - gradientascent          : "Gradient Ascent: Logistic Regression"
#>   - gradientdescent         : "Gradient Descent"
#>   - irisqda                 : "Quadratic Discriminant Analysis "
#>   - knn                     : "K-Nearest Neighbors"
#>   - laplacianeigenmaps      : "Laplacian Eigenmaps"
#>   - leaping-marbles         : "Leaping marbles"
#>   - logtransformations      : "Log Transformations on Linear Regression"
#>   - rsquared                : "R-squared and garbage predictors"
#>   - selectioncriterion      : "Comparing AIC, BIC, and CV"
#>   - treesandleaves          : "Trees and Leaves"
#>   - weightedleastsquares    : "Weighted Least Squares"
```

To run a particular lab:

``` r
run_lab("rsquared")
```
