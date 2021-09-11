---
layout: page
title: "Project requirements"
icon: "fas fa-tools"
---

## Overview

The premise of this project is  simple. You are to pick a real data set for which you believe there are interesting questions to answer. Alternatively, you will try to create/find a dataset that you can use to answer some question your group cares about. You will then use appropriate statistical learning approaches, covered in this course or others, to answer the questions to the extent possible.

You will submit three written components.

- Project checkpoint 0: due __Monday, 27 September__
- Project checkpoint 1: due __Tuesday, 28 September__
- Project checkpoint 2: due __Tuesday, 9 November__
- Project checkpoint 3: due __Tuesday, 7 December__

You may complete the project individually, but it is recommended that you form a group of up to 4 people. If you are looking for a group, join the #group-projects channel and post there.


## Some sources for data

* [`{CanSim}`](https://github.com/mountainMath/cansim) An R package that loads various data from Statistics Canada (see also there for much more)
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


## Project checkpoint 0

(0 points)

By the due date, one member of your group must create a private repository. If it is not done by the deadline, there is no guarantee that you will be able to submit Checkpoint 1.

* Click the Green "New" button.
* Under "Repository template", select "Stat-406-101-2021W/project-template"
* Your repository name must be of the form `project-<somename>`.
* Make your repository "Private".
* Once you make it, go to Settings > Collaborators & Teams. Under "Teams", add "The TAs" and give them "Write" permission. Under "Collaborators" add your teammates and give them "Write" permission.
*


## Project checkpoint 1 

(5 points / 100 total)

This is a synopsis of your intentions. It should contain the following information: 

1. project title 
2. team members
3. description of the data (include the number of observations, number of predictors, what the different predictors are, etc.)
4. precise description of the question(s) you are trying to answer 
5. a few sentences describing why this question/dataset is interesting to you
6. reading list (papers you may need to read)
7. A team contract. It should contain 4 areas: Participation, Communication, Meetings, Conduct. For each area, write 1-2 sentences beginning with "We agree to ..." and including any rules to which your team collectively agrees (e.g. "We agree to make 1 commit per week." or "We agree to meet in the library every other Friday.")



For your submission, 

1. Edit the `README` in your team's repo.
1. Put the above points in the file in text. You can use bullet points for each of these items if you like.
1. We will download your repo on the due date and grade from there. Mainly for completion. The TA will create a branch with any comments and do a PR against `master`. You can then decide how to handle the suggestions.

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

Submission is an R markdown file and a compiled pdf. The document title should be "report.Rmd". Total page length: maximum 3 pages (not including graphics). Be sure to describe your graphics
carefully both in the text and with nice labels. Plots with no description are not useful.
Anything exceptionally interesting will be
rewarded. Ugly plots, uninterpretable analysis, etc. will be
penalized.

Again, we will pull your repo on the due date. If you fail to name your file properly, or fail to compile, we won't know what to mark. So be sure that this happens on time.




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




## Peer evaluation and sand bagging

* As part of the final submission we will also do a peer evaluation. Hopefully, everyone will contribute. However, in the case that there are issues, we reserve the right to lower your (individual) score. As the term goes on, please reach out to us if there are issues (people not adhering to the contract). Note also, we have a full commit record and can see who is responsible for what components. Poor team performance will not be tolerated and groups with challenges may be split up at our discretion.

## Don't do this

While searching for interesting data to use for Module 5, I came across this analysis: https://towardsdatascience.com/machine-learning-on-the-rocks-f49f75219c02

This has the hallmarks of something that could be interesting (a fun data set, organized nicely along the lines above, good formatting, appropriate length). But the statistical analysis is not very good at all. There is too much story telling (first we make a data frame then we look at box plots). But especially, it makes empty claims. For example: 
> Clustering reveals a clearer indication of what whiskey types foster the rating (and sales, as well). See how the new Clusters distinguish themselves, as compared to the categories of previous analysis.

There's no discussion as to **how** it does this. Nor does it really appear to be true in the figures.

Avoid this type of mealy-mouthed analysis. It will not result in good marks.
