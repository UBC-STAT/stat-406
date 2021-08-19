---
layout: page
title: Computing
icon: "fab fa-r-project"
---

In order to participate in this class, we will require the use of R, and encourage
the use of RStudio. Both are free, and you likely already have both. If not, see below.
These instructions are taken from [UBC's MDS site](https://ubc-mds.github.io/resources_pages/installation_instructions/), thanks!

## Installing R and Rstudio

### On macOS

Go to <https://cran.r-project.org/bin/macosx/> and download the latest version of R for Mac (Should look something like this: R-4.1.0.pkg). Open the file and follow the installer instructions.

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

### On Windows

Go to <https://cran.r-project.org/bin/windows/base/> and download the latest version of R for Windows (Should look something like this: Download R 4.1.0 for Windows). Open the file and follow the installer instructions.

Chose and download the Windows version of RStudio from <https://www.rstudio.com/products/rstudio/download/#download>. Open the file and follow the installer instructions.

To see if you were successful, try opening RStudio by clicking on its icon. 


## Git and Github

### Installation

In many cases, you likely already have it installed. See the book [Happy Git with R](https://happygitwithr.com/install-git.html) for help.

### Homework/Readings workflow

**Command line version**  
1. (Optional, but useful. Pull in any remote changes.) `git pull`
1. Create a new branch `git branch -b <name-of-branch>`
1. Work on your documents and save frequently.
1. Stage your changes `git add <name-of-document1>` repeat for each changed document. `git add .` stages all changed documents.
1. Commit your changes `git commit -m "some message that is meaningful"` 
1. Repeat 2-4 as necessary.
1. Push to Github `git push`.
1. When done, go to Github and open a PR.
1. Switch back to `main` to avoid future headaches. `git checkout main`.

**Rstudio version** (uses the Git tab. Usually near Environment/History in the upper right)  
1. (Optional, but useful. Pull in remote changes.) Click <i class="fas fa-arrow-down" style="color:blue"></i>.
1. Create a new branch by clicking the think that looks kinda like <i class="fas fa-code-branch" style="color:purple"></i>.
1. Work on your documents and save frequently.
1. Stage your changes by clicking the check boxes.
1. Commit your changes by clicking `Commit**. 
1. Repeat 2-4 as necessary.
1. Push to Github <i class="fas fa-arrow-up" style="color:green"></i>
1. When done, go to Github and open a PR.
1. Use the dropdown menu to go back to `main` and avoid future headaches.

### Fixing common problems

**master/main**
"master" has some pretty painful connotations for some people. So as part of an effort to remove racist names from code, the default branch is now "main" on new versions of Git. But old versions still have "master". Below, I'll use "main", but if you see "master" on what you're doing, that's the one to use.


**Start from main**  
Branches should be created from the `main` branch, not the one you used for the last assignment.  
`git checkout main`  
This switches to `main`. Then pull and start the new assignment following the workflow above.

**You forgot to work on a new branch**  
Ugh, you did 5 points of worksheets before realizing you forgot to create a new branch. Don't stress. There are some things below to try. But if you're confused ASK. We've had practice with this, and soon you will too!  

If you started from `main` and haven't made any commits:  
`git branch -b <new-branch-name>`  
This keeps everything you did and puts you on a new branch. No problem. Commit and proceed as usual.

If you are on `main` and made some commits:  
```
git branch <new-branch-name>
git log
```
The first line makes a new branch with all the stuff you've done. Then we look at the log. Locate the most recent commit before you started working. It's a long string like
`ac2a8365ce0fa220c11e658c98212020fa2ba7d1`. Then,
```
git reset ac2a8 --hard
```
This rolls `main` back to that commit. You don't need the whole string, just the first few characters. Finally
```
git checkout <new-branch-name>
```
and continue working.

If you started from `<some-branch>`  
This one is harder, and I would suggest getting in touch with the TAs. Here's the procedure.
```
git commit -am "uhoh, I need to be on a different branch"
git branch <new-branch-name>
```
Commit your work, then create a new branch and switch to it. It's got all your stuff.
```
git log
```
Locate the most recent commit before you started working. It's a long string like `ac2a8365ce0fa220c11e658c98212020fa2ba7d1`. Then,
```
git rebase --onto master ac2a8 <new-branch-name>
git checkout <new-branch-name>
```
This makes the new branch look like the `master` but without the differences from master that are on `ac2a8`. It's pretty cool. And should work.
