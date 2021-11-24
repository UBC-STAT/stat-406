---
title: Schedule
layout: page
icon: "far fa-calendar-alt"
---

Required readings and lecture videos are listed below for each module.
Readings from [\[ISLR\]](https://www.statlearning.com) are always required while those from [\[ESL\]](https://web.stanford.edu/~hastie/ElemStatLearn/) are optional and supplemental. The exception is the coverage of Neural Networks in Module 4 (this material does not appear in \[ISLR\]). Required readings and videos must be completed before the mini quiz at the beginning of each module.


<div class="text-center">
<div class="btn-group" role="group">
  <a role="button" class="btn btn-secondary text-white" href="#0-introduction-and-review">0 Intro</a>
  <a role="button" class="btn btn-secondary text-white" href="#1-model-accuracy">1 Model Checks</a>
  <a role="button" class="btn btn-secondary text-white" href="#2-regularization-smoothing-and-trees">2 Regression</a>
  <a role="button" class="btn btn-secondary text-white" href="#3-classification">3 Classification</a>
  <a role="button" class="btn btn-secondary text-white" href="#4-modern-techniques">4 Modern</a>
  <a role="button" class="btn btn-secondary text-white" href="#5-unsupervised-learning">5 Unsupervised</a>
  <a role="button" class="btn btn-secondary text-white" href="#f-final-exam">F Final</a>
</div>
</div>


> All lecture slides as `.Rmd` files are available [here](https://github.com/UBC-STAT/stat-406/tree/main/_lecture-slides). 

> Handouts for some lectures (coding files, pdfs) are available [here](https://github.com/UBC-STAT/stat-406/tree/main/_lecture-slides/handouts).

## 0 Introduction and Review

Required reading below is meant to reengage brain cells which have no doubt forgotten all
the material that was covered in STAT 306 or CPSC 340. We don't presume that you remember all these details, but that, upon rereading, they at least sound familiar. If this all strikes you as completely foreign, this class may not be for you. 

Required reading  
: \[ISLR\] 2.1, 2.2, and Chapter 3 (this material is review)

Video lectures from last year
: Lectures 1 and 2

Optional reading
: \[ESL\] 2.4 and 2.6

Handouts
: Programming in `R` [`.Rmd`](handouts/00-programming.Rmd), [`.pdf`](handouts/00-programming.pdf)
: Using in RMarkdown [`.Rmd`](handouts/00-rmarkdown.Rmd), [`.pdf`](handouts/00-rmarkdown.pdf)


|Date      |Slides |Deadlines    |
|:---------|:-----------|:-----------|
|7 Sep 21  | |(no class, Imagine UBC) |
|9 Sep 21  |[Intro to class](00-intro-to-class.html), [Git](00-version-control.html) |Syllabus, Git, Github | |
|14 Sep 21 | [LM review](01-lm-review.html), [LM Example](02-lm-example.html)|   |
{: .table .table-striped}




## 1 Model Accuracy

Topics  
: Model selection; cross validation; information criteria; stepwise regression

Required reading  
: \[ISLR\] Ch 2.2 (not 2.2.3), 5.1 (not 5.1.5), 6.1, 6.4

Video lectures from last year
: Lectures 3 to 7 

Optional reading
: \[ESL\] 7.1-7.5, 7.10

|Date      |Slides |Deadlines    |
|:---------|:-----------|:-----------|
|16 Sep 21 |[Regression function](03-regression-function.html), [Bias and Variance](04-bias-variance.html)
|21 Sep 21 |[Risk estimation](05-estimating-test-mse.html), [Info Criteria](06-information-criteria.html)    | |
|23 Sep 21 | [Greedy selection](07-greedy-selection.html) |           |
|28 Sep 21 |         | HW1 due, PC 1 due |
{: .table .table-striped}




## 2 Regularization, smoothing, and trees

Topics  
: Ridge regression, lasso, and related; linear smoothers (splines, kernels); kNN

Required reading  
: \[ISLR\] Ch 6.2, 7.1-7.7.1, 8.1, 8.1.1, 8.1.3, 8.1.4

Video lectures from last year  
: Lectures 8-13

Optional reading
: \[ESL\] 3.4, 3.8, 5.4, 6.3

|Date      |Slides |Deadlines    |
|:---------|:---------|:-----|
|30 Sep 21 |(no class, National Day for Truth and Reconciliation) |
|5 Oct 21  |[Ridge](08-ridge-regression.html), [Lasso](09-l1-penalties.html)  |  |
|7 Oct 21  |[NP 1](10-basis-expansions.html), [NP 2](11-kernel-smoothers.html) |  |
|12 Oct 21 |[Why smoothing?](12-why-smooth.html)  |  |
|14 Oct 21 |[Other](13-gams-trees.html)          |  |
|19 Oct 21 |          | HW 2 due |
{: .table .table-striped}



## 3 Classification

Topics  
: logistic regression; LDA/QDA; naive bayes; trees

Required reading  
: \[ISLR\] Ch 2.2.3, 5.1.5, 4-4.5, 8.1.2

Video lectures from last year
: Lectures 14-17 and Gradient descent (best after lecture 15)

Optional reading
: \[ESL\] 4-4.4, 9.2, 13.3

|Date      |Slides |Deadlines    |
|:---------|:---------|:-----|
|21 Oct 21 |[Classification](14-classification-intro.html), [LDA and QDA](15-LDA-and-QDA.html) |          |
|26 Oct 21 |[Gradient descent](00-gradient-descent.html), [Logistic regression](16-logistic-regression.html) |
|28 Oct 21 |[Nonlinear](17-nonlinear-classifiers.html)  |  |
|2 Nov 21  |          |  |
{: .table .table-striped}



## 4 Modern techniques

Topics  
: bagging; boosting; random forests; neural networks

Required reading  
: \[ISLR\] 5.2, 8.2, 10.1, 10.2, 10.6, 10.7 \[ESL\] 11.1, 11.3, 11.4, 11.7

Video lectures  
: Lecture 18-23

Optional reading
: \[ESL\] 10.1-10.10 (skip 10.7), 11.1-11.7

|Date      |Slides |Deadlines    |
|:---------|:---------|:-----|
| 4 Nov 21   | [The bootstrap](18-the-bootstrap.html) | HW 3 due  |
| 9 Nov 21   |[Bagging and random forests](19-bagging-and-rf.html), [Boosting](20-boosting.html)| PC 2 due |
| 11 Nov 21  | (no class, Midterm Break) |
| 16 Nov 21  |[Intro to neural nets](21-nnets-intro.html), [Estimating neural nets](22-nnets-estimation.html)  |
| 18 Nov 21  |[Neural nets wrapup](23-nnets-other.html) |          |
| 23 Nov 21  |  | HW 4 due |
{: .table .table-striped}



## 5 Unsupervised learning

Topics  
: dimension reduction and clustering

Required reading  
: \[ISLR\] 12

Video lectures  
: Lectures 24-28

Optional reading
: \[ESL\] 8.5, 13.2, 14.3, 14.5.1, 14.8, 14.9


|Date      |Slides |Deadlines    |
|:---------|:-----------|:-----------|
|25 Nov 20 | [Intro to PCA](24-pca-intro.html), [Issues with PCA](25-pca-issues.html)  |
|30 Nov 20 | [PCA v KPCA](26-pca-v-kpca.html) |
|2 Dec 20  |[K means clustering](27-kmeans.html), [Hierarchical clustering](28-hclust.html) |         |
|7 Dec 20  | |HW 5 due, PC 3 due |
{: .table .table-striped}




## F Final exam

22 December 8:30-11am – in Henry Angus (ANGU) 098

* In person attendance is required (per Faculty of Science guidelines)
* You must bring your computer as the exam will be given through Canvas with "lockdown browser"
* Please [arrange to borrow](https://services.library.ubc.ca/computers-technology/technology-borrowing/) one from the library if you do not have your own
* There are plenty of outlets in the room
* You may bring 2 sheets of front/back 8.5x11 paper with any notes you want to use
* There will be no required coding, but I may show code or output and ask questions about it.
* It will be entirely multiple choice / True-False / matching, etc.
* Questions will be similar to Quizzes or Homework.

