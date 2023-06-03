library(knitr)
library(tidyverse)

setwd("~/Documents/stat-406-instructor/lecture-slides/Rcode/")
file_names = list.files("..", pattern = "\\.Rmd$")

for (name in file_names){
  knitr::purl(str_c("../", name))
}

