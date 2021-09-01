rmd_filename <- stringr::str_remove(knitr::current_input(),"\\.Rmd")
knitr::opts_chunk$set(
  fig.path = stringr::str_c("rmd_gfx/", rmd_filename, '/'),
  warning=FALSE, message=FALSE, dev="svg"
)
options(htmltools.dir.version = FALSE)
blue = "#654ea3"
orange = "#F9AC2F"
green = "#0076A5"
red = "#DB0B5B"
library(tidyverse)
library(cowplot)
library(fontawesome)
library(knitr)
# library(countdown)

pro = fa("thumbs-up", fill=green)
con = fa("bomb", fill=red)

set.seed(12345)