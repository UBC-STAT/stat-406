rmd_filename <- stringr::str_remove(knitr::current_input(),"\\.Rmd")
knitr::opts_chunk$set(
  fig.path = stringr::str_c("rmd_gfx/", rmd_filename, '/'),
  warning=FALSE, message=FALSE, dev="svg"
)
options(htmltools.dir.version = FALSE)
secondary = "#e98a15"
primary = "#2c365e"
tertiary = "#0a8754"
fourth_color = "#a8201a"

## for simplicity
purple = primary
blue = primary
orange = secondary
green = tertiary
red = fourth_color

library(tidyverse)
# library(cowplot)
library(fontawesome)
library(knitr)
theme_set(theme_bw(18))
# library(countdown)

pro = fa("thumbs-up", fill=green)
con = fa("bomb", fill=orange)

set.seed(12345)