---
layout: page
title: Computing
icon: "fab fa-r-project"
---

In order to participate in this class, we will require the use of R, and encourage
the use of RStudio. Both are free, and you likely already have both. 

You also need Git, Github and Slack.

Below are instructions for installation. These are edited and simplified from the [DSCI 310 Setup Instructions](https://ubc-dsci.github.io/dsci-310-student/computer-setup.html). If you took DSCI 310 last year, you may be good to go, with the exception of the [R package](https://ubc-stat.github.io/stat-406-rpackage/).

## Laptop requirements

 - Runs one of the following operating systems: Ubuntu 20.04, macOS (version 11.4.x or higher), Windows 10 (version 2004, 20H2, 21H1 or higher).
    - When installing Ubuntu, checking the box "Install third party..." will (among other things) install proprietary drivers, which can be helpful for wifi and graphics cards.
- Can connect to networks via a wireless connection for on campus work
- Has at least 30 GB disk space available
- Has at least 4 GB of RAM
- Uses a 64-bit CPU
- Is at most 6 years old (4 years old or newer is recommended)
- Uses English as the default language. Using other languages is possible, but we have found that it often causes problems in the homework. We've done our best to fix them, but we may ask you to change it if you are having trouble.
- Student user has full administrative access to the computer.

## Software installation instructions

Please click the appropriate link below to view the installation instructions for your operating system:

- [macOS x86](install_stack/mac_x86.html) or [macOS arm](install_stack/mac_arm.html) 
- [Ubuntu](install_stack/ubuntu.html)
- [Windows](install_stack/windows.html)



## Git and Github

### Homework/Readings workflow

**Command line version**  
1. (Optional, but useful. Pull in any remote changes.) `git pull`
1. Create a new branch `git branch -b <name-of-branch>`
1. Work on your documents and save frequently.
1. Stage your changes `git add <name-of-document1>` repeat for each changed document. `git add .` stages all changed documents.
1. Commit your changes `git commit -m "some message that is meaningful"` 
1. Repeat 3-5 as necessary.
1. Push to Github `git push`. It may suggest a longer form of this command, obey.
1. When done, go to Github and open a PR. Request review from the TAs.
1. Switch back to `main` to avoid future headaches. `git checkout main`.

**Rstudio version** (uses the Git tab. Usually near Environment/History in the upper right)  
1. Make sure you are on `main`. Pull in remote changes. Click <i class="fas fa-arrow-down" style="color:blue"></i>.
1. Create a new branch by clicking the think that looks kinda like <i class="fas fa-code-branch" style="color:purple"></i>.
1. Work on your documents and save frequently.
1. Stage your changes by clicking the check boxes.
1. Commit your changes by clicking **Commit**. 
1. Repeat 3-5 as necessary.
1. Push to Github <i class="fas fa-arrow-up" style="color:green"></i>
1. When done, go to Github and open a PR. Request review from the TAs.
1. Use the dropdown menu to go back to `main` and avoid future headaches.

### Fixing common problems

**master/main**  
"master" has some pretty painful connotations. So as part of an effort to remove racist names from code, the default branch is now "main" on new versions of GitHub. But old versions (like the UBC version) still have "master". Below, I'll use "main", but if you see "master" on what you're doing, that's the one to use.


**Start from main**  
Branches should be created from the `main` branch, not the one you used for the last assignment.  
```
git checkout main
```
This switches to `main`. Then pull and start the new assignment following the workflow above. (In Rstudio, use the dropdown menu.)

**You forgot to work on a new branch**  
Ugh, you did 5 points of worksheets before realizing you forgot to create a new branch. Don't stress. There are some things below to try. But if you're confused ASK. We've had practice with this, and soon you will too!  

_(1) If you started from `main` and haven't made any commits (but you SAVED!!):_  
```
git branch -b <new-branch-name>
```
This keeps everything you have and puts you on a new branch. No problem. Commit and proceed as usual.

_(2) If you are on `main` and made some commits:_
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

_(3) If you started work on `<some-old-branch>` for work you already submitted:_  
This one is harder, and I would suggest getting in touch with the TAs. Here's the procedure.
```
git commit -am "uhoh, I need to be on a different branch"
git branch <new-branch-name>
```
Commit your work with a dumb message, then create a new branch. It's got all your stuff.
```
git log
```
Locate the most recent commit before you started working. It's a long string like `ac2a8365ce0fa220c11e658c98212020fa2ba7d1`. Then,
```
git rebase --onto main ac2a8 <new-branch-name>
git checkout <new-branch-name>
```
This makes the new branch look like `main` but without the differences from `main` that are on `ac2a8` and WITH all the work you did after `ac2a8`. It's pretty cool. And should work. Finally, we switch to our new branch.
