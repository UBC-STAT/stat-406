---
layout: page
title: "Project requirements"
icon: "fas fa-tools"
---

## Overview

The premise of this project is  simple. You are to pick a real data set for which you believe there are interesting questions to answer. Alternatively, you will try to create/find a dataset that you can use to answer some question your group cares about. You will then use appropriate statistical learning approaches, covered in this course or others, to answer the questions to the extent possible.

You will submit three written components.

- Project checkpoint 0: due __Tuesday, 28 September__
- Project checkpoint 1: due __Tuesday, 28 September__
- Project checkpoint 2: due __Tuesday, 9 November__
- Project checkpoint 3: due __Tuesday, 7 December__

## Some sources for data

* [Statistics Canada](https://github.com/mountainMath/cansim) An R package that loads various data
* `{covidcast}` an R package with access to a massive amount of US COVID-19 data (see the [API docs](https://cmu-delphi.github.io/delphi-epidata/api/covidcast.html))
* [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday) Many strange but possibly interest data sets.
* [Vox Media](https://www.vox.com) Github [Repo](https://github.com/voxmedia/data-projects)
* [FiveThirtyEight](http://www.fivethirtyeight.com) Github [Repo](https://github.com/fivethirtyeight/data)
* [NPR visualizations](http://blog.apps.npr.org) Github [Organization](https://github.com/nprapps)
* Do you have a favorite blog/news site/data-driven website? They probably have a Github repo that is public. Try searching for it. (Those above are some of my favorites)
* [Kaggle](https://www.kaggle.com/datasets)
* Higgs Boson [Data](https://www.kaggle.com/c/higgs-boson/data) (from Kaggle, but worth it's own link)
* [Zillow](https://www.zillow.com/research/data/)
* [18 interesting places to find data](https://www.dataquest.io/blog/free-datasets-for-projects/)
* [A list of 100+ datasets](http://rs.io/100-interesting-data-sets-for-statistics/)
* Hockey data from [War on Ice](https://github.com/war-on-ice)


## Checkpoint 0

Before the due date of checkpoint 1, you must let the TAs know (via Slack, use @the-tas) who is in your group. This way they can create a repo for you to collaborate and submit your work.

## Project checkpoint 1 

(5 points / 100 total)

This is a maximum 1-page long synopsis of your intentions. It should contain the following information: 

1. project title 
2. team members
3. description of the data (include the number of observations, number of predictors, what the different predictors are, etc.)
4. precise description of the question(s) you are trying to answer 
5. a few sentences describing why this question/dataset is interesting to you
6. reading list (papers you may need to read)

You can use bullet points for each of these items if you like.

## Project checkpoint 2

(30 points / 100 total)

This should build on the previous submission.

Your report must consist of the following sections.

0. Project title and list of teammates
1. A few sentences describing why this project is interesting to you (approx 1 paragraph).
2. __Introduction:__ A description of how the data came about and what things you may be investigating. What is the data? What are you trying to do? How did you get the data? Why should anyone care about any of this? Etc., etc. (approx 0.5--1 page)  
This section will appear in your final report as well, possibly
expanded to foreshadow the results you have by that point
discovered, so spend some time to make it good, and your effort will
not be wasted.
3. __Exploratory data analysis:__ Begin to examine your data. Make many graphics. 
    * This is exploratory. Even basic
    conclusions are useful. 
    * Go overboard. Make far more plots than you will keep
    * I strongly urge you to divide and conquer. Have different
    group members investigate different things. Recombine to discuss
    your results and iterate.
    * Do not leave this until the last minute. I guarantee you
    will receive poor scores. This will take sustained, consistent
    effort. Start NOW.

    This section should occupy the remainder of your report.

Total page length: maximum 3 pages (not including graphics). Be sure to describe your graphics
carefully both in the text and with nice labels. Plots with no description are not useful.
Anything exceptionally interesting will be
rewarded. Ugly plots, uninterpretable analysis, etc. will be
penalized.

### PC 2 Rubric



__Words__ (6 / 6) The text is laid out cleanly, with clear divisions
and transitions between sections and sub-sections. The writing itself
is well-organized, free of grammatical and other mechanical errors,
divided into complete sentences logically grouped into paragraphs and
sections, and easy to follow from the presumed level of knowledge. 

__Numbers__ (1 / 1) All numerical results or summaries are reported to
suitable precision, and with appropriate measures of uncertainty
attached when applicable. 

__Pictures__ (7 / 7) Figures and tables are easy to read, with
informative captions, axis labels and legends, and are placed near the
relevant pieces of text or referred to with convenient labels. 

__Code__ (4 / 4) The code is formatted and organized so that it is easy
for others to read and understand. It is indented, commented, and uses
meaningful names. It only includes computations which are actually
needed to answer the analytical questions, and avoids redundancy. Code
borrowed from the notes, from books, or from resources found online is
explicitly acknowledged and sourced in the comments. Functions or
procedures not directly taken from the notes have accompanying tests
which check whether the code does what it is supposed to. The text of
the report is free of intrusive blocks of code. With regards to R Markdown,
all calculations are actually done in the file as it knits, and only
relevant results are shown.

__Exploratory data analysis__ (12 / 12) Variables are examined individually and
bivariately. Features/observations are discussed with appropriate
figure or tables. The relevance of the EDA to the questions and
potential models is clearly explained.




## Project checkpoint 3

(65 / 100 total)

Each group should submit one report of no more than 5 pages of text, 7 with graphics. It must consist of the following
sections. (Page numbers are approximate.)

1. __Introduction__ (1 page) Write three to four paragraphs introducing the research
  problem and describing the specific research hypothesis. Cite any information
  sources in parentheses or foot- or end- notes.
2. __EDA__ (about 1 pages) This section should incorporate some
  material from the 
  Midterm report (with any changes suggested in the marking thereof) as
  well as any new analyses which seem desirable as you have made
  further progress. Only the most relevant analyses should be included
  by now. You _may_ put the rest in an Appendix (but you probably shouldn't). 
3. __Results and analysis__ (about 3 pages) Address 
  the specific question(s) of interest with methods of your choice (these can graphical, numerical, 
  or statistical models). 
  Be sure to justify the choices you make, and explain why your calculations lead to the 
  results that you discuss. Models without careful justification, figures presenting irrelevant material,
  or large tables of uninterpreted numbers will be treated harshly.
4. __Discussions/results__ (1 page) What are your conclusions?  Identify a few key
  findings, and discuss, with reference to the supporting evidence.  Can you
  come up with explanations for the patterns you have found?  Suggestions or
  recommendations for future work?  How could your analysis be improved?  

Again, be sure to describe your graphics carefully. Plots with no description are useless.
As before, anything exceptionally useful will be
rewarded. Ugly plots, uninterpretable analysis, etc. will be
penalized.

### PC 3 rubric



__Words__ (8 / 8) The text is laid out cleanly, with clear divisions and
transitions between sections and sub-sections.  The writing itself is
well-organized, free of grammatical and other mechanical errors, divided into
complete sentences logically grouped into paragraphs and sections, and easy to
follow from the presumed level of knowledge.

__Numbers__ (1 / 1) All numerical results or summaries are reported to
suitable precision, and with appropriate measures of uncertainty attached when
applicable.

__Pictures__ (7 / 7) Figures and tables are easy to read, with informative
captions, axis labels and legends, and are placed near the relevant pieces of
text.

__Code__ (4 / 4) The code is formatted and organized so that it is easy
for others to read and understand.  It is indented, commented, and uses
meaningful names.  It only includes computations which are actually needed to
answer the analytical questions, and avoids redundancy.  Code borrowed from the
notes, from books, or from resources found online is explicitly acknowledged
and sourced in the comments.  Functions or procedures not directly taken from
the notes have accompanying tests which check whether the code does what it is
supposed to. The text of the report is free of intrusive blocks of code.  If
you use R Markdown, all calculations are actually done in the file as it knits,
and only relevant results are shown. 

__Exploratory Data Analysis__ (12 / 12) Variables are examined individually and
bivariately. Features/observations are discussed with appropriate
figure or tables. The relevance of the EDA to the questions and
potential models is clearly explained.

__Results and analysis__ (25 / 25) The statistical summaries
are clearly related to, or possibly derive from, the substantive questions of interest.  Any
assumptions are checked by means of appropriate diagnostic plots or
formal tests. Limitations from un-fixable problems are
clearly noted. The actual estimation
of parameters, predictions, or other calculations are technically correct.  All calculations
based on estimates are clearly explained, and also technically correct.  All
estimates or derived quantities are accompanied with appropriate measures of
uncertainty. 

__Conclusions__ (8 / 8) The substantive questions are answered as
precisely as the data and the model allow.  The chain of reasoning from
estimation results about models, or derived quantities, to substantive
conclusions is both clear and convincing.  Contingent answers ("if $X$, then
$Y$, but if $Z$, then $W$") are likewise described as warranted by the
and data.  If uncertainties in the data mean the answers to some
questions must be imprecise, this too is reflected in the conclusions.




