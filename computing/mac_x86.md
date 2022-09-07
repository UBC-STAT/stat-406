---
layout: page
title: MacOS x86
icon: "fab fa-apple"
---



## Installation notes

If you have already installed Git, LaTeX, or any of the R packages,
you should be OK. However, if you have difficulty with Homework or Labs,
we may ask you to uninstall and try again.

In order to be able to support you effectively and minimize setup issues and software
conflicts, we suggest you install the required software as specified below.

In all the sections below,
if you are presented with the choice to download either a 64-bit (also called x64)
or a 32-bit (also called x86) version of the application **always** choose the 64-bit version.

## Terminal

By "Terminal" below we mean the command line program called "Terminal". Note that this is also available
**Inside RStudio**. Either works. To easily pull up the Terminal (outside RStudio), Type `Cmd + Space` 
then begin typing "Terminal" and press `Return`.

## GitHub

In Stat 406 we will use the publicly available [GitHub.com](https://github.com/).
If you do not already have an account, please sign up for one at [GitHub.com](https://github.com/)

Sign up for a free account at [GitHub.com](https://github.com/) if you don't have one already.

## Git

We will be using the command line version of Git as well as Git through RStudio.
Some of the Git commands we will use are only available since Git 2.23,
so if your Git is older than this version,
we ask you to update it using the Xcode command line tools (not all of Xcode), which includes Git.

Open Terminal and type the following command to install Xcode command line tools:

```bash
xcode-select --install
```

After installation, in terminal type the following to ask for the version:

```bash
git --version
```

you should see something like this (does not have to be the exact same version) if you were successful:

```
git version 2.32.1 (Apple Git-133)
```

> **Note:** If you run into trouble, please see the Install Git
> Mac OS section from [Happy Git and GitHub for the useR](http://happygitwithr.com/install-git.html#mac-os)
> for additional help or strategies for Git installation.


### Configuring Git user info

Next, we need to configure Git by telling it your name and email.
To do this, type the following into the terminal
(replacing Jane Doe and janedoe@example.com, with your name and email that
you used to sign up for GitHub, respectively):

```bash
git config --global user.name "Jane Doe"
git config --global user.email janedoe@example.com
```

> **Note:** To ensure that you haven't made a typo in any of the above,
> you can view your global Git configurations by either opening the
> configuration file in a text editor (e.g. via the command `nano ~/.gitconfig`)
> or by typing `git config --list --global`).

If you have never used Git before, we recommend also setting the default editor:

```bash
git config --global core.editor nano
```

If you prefer VScode (and know how to set it up) or something else, feel free.

# R, XQuartz, and RStudio

R is the only language that we will be using in this course.
We will generally (always?) use R in RStudio.

### R

Go to [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
and download the latest version of R for Mac. Open the file and follow the installer instructions.

After installation, open a new terminal window and type the following:

```bash
R --version
```

You should see something like this if you were successful:

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

> **Note:** Although it is possible to install R through conda, we highly recommend not doing so.
> In case you have already installed R using conda you can remove it by executing `conda uninstall r-base`.


### XQuartz

Some R packages rely on the dependency XQuartz which no longer ships with the Mac OS,
thus we need to install it separately.
Download it from here: [https://www.xquartz.org/](https://www.xquartz.org/)
and follow the installation instructions.

### RStudio

Download the macOS Desktop version (not Pro) of RStudio Preview from
[https://rstudio.com/products/rstudio/download/preview/](https://rstudio.com/products/rstudio/download/preview/).
Open the file and follow the installer instructions.


### Installing R packages

Next, install the key R packages needed for the course by opening up RStudio and
typing the following into the R console inside RStudio:

```R
install.packages("remotes")
remotes::install_github("ubc-stat/stat-406-rpackage")
```

With luck, that will install everything you need.

## LaTeX

It is possible you already have this installed.

First try the following check in RStudio

```r
Stat406::test_latex_installation()
```

If you see Green checkmarks, then you're good.

Even if it fails, follow the instructions, and try it again.

If it stall fails, proceed with the instructions

<hr>

We will install the lightest possible version of LaTeX and its necessary
packages as possible so that we can render Jupyter notebooks and R Markdown documents to html and PDF.
If you have previously installed LaTeX, please uninstall it before proceeding with these instructions.

First, run the following command to make sure that `/usr/local/bin` is writable:

```bash
sudo chown -R $(whoami):admin /usr/local/bin
```

> **Note:** You might be asked to enter your password during installation.
Now open RStudio and run the following commands to install the `tinytex` package and setup `tinytex`:

```R
tinytex::install_tinytex()
```

You can check that the installation is working by opening a terminal and asking for the version of latex:

```bash
latex --version
```

You should see something like this if you were successful:

```
pdfTeX 3.141592653-2.6-1.40.23 (TeX Live 2022/dev)
kpathsea version 6.3.4/dev
Copyright 2021 Han The Thanh (pdfTeX) et al.
There is NO warranty.  Redistribution of this software is
covered by the terms of both the pdfTeX copyright and
the Lesser GNU General Public License.
For more information about these matters, see the file
named COPYING and the pdfTeX source.
Primary author of pdfTeX: Han The Thanh (pdfTeX) et al.
Compiled with libpng 1.6.37; using libpng 1.6.37
Compiled with zlib 1.2.11; using zlib 1.2.11
Compiled with xpdf version 4.03
```

## Post-installation notes

You have completed the installation instructions, well done 🙌!

## Attributions

The [DSCI 310 Teaching Team](https://ubc-dsci.github.io/dsci-310-student/computer-setup.html), notably,  Anmol Jawandha, Tomas Beuzen, Rodolfo Lourenzutti, Joel Ostblom, Arman Seyed-Ahmadi, Florencia D’Andrea, and Tiffany Timbers.