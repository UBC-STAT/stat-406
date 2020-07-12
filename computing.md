---
layout: page
title: Computing
icon: "fab fa-r-project"
---

During each "Lab" period, we will work through some coding exercises and answer 
both conceptual and computational questions in groups. This requires some software.

In order to participate in this class, we will require the use of R, and encourage
the use of RStudio. Both are free, and you likely already have both. If not, see below.
These instructions are taken from [UBC's MDS site](https://ubc-mds.github.io/resources_pages/installation_instructions/), thanks!

### R and Rstudio on macOS

Go to <https://cran.r-project.org/bin/macosx/> and download the latest version of R for Mac (Should look something like this: R-4.0.1.pkg). Open the file and follow the installer instructions.

After installation, in Terminal type the following to ask for the version:
```
R --version
```

you should see something like this if you were successful:
```
R version 4.0.0 (2020-04-24) -- "Arbor Day"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-apple-darwin17.0 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
https://www.gnu.org/licenses/.
```

Choose and download the Mac version of RStudio from <https://www.rstudio.com/products/rstudio/download/#download>. Open the file and follow the installer instructions.

To see if you were successful, try opening RStudio by clicking on its icon (from Finder, Applications or Launchpad).

### R and Rstudio on Windows

Go to <https://cran.r-project.org/bin/windows/base/> and download the latest version of R for Windows (Should look something like this: Download R 4.0.1 for Windows). Open the file and follow the installer instructions.

Chose and download the Windows version of RStudio from <https://www.rstudio.com/products/rstudio/download/#download>. Open the file and follow the installer instructions.

To see if you were successful, try opening RStudio by clicking on its icon. 

## R packages

We have tried to make it easy to get all the packages you'll need at once. To do this,
we have written an R package specifically for this course. By installing it, you will
then have all the tutorials that we will use during Lab sessions. It depends on all the packages
that get used in \[ISLR\], so it should install all of those as well. 

However, this package is not on CRAN. So you need the `{remotes}` package. The following sequence should
install everything you need all at once. Simply start Rstudio and copy the following into the console.

```
if(!require("remotes")) install.packages("remotes")
remotes::install_github("ubc-stat/stat-406/stat406labs", depend=TRUE)
```
