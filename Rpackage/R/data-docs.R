

#' Properties of 340 leaves
#'
#' A dataset containing attributes of a pile of leaves
#'
#'
#' The variables are (roughly) described below. More details as well as the
#' actual images are available at the UCI ML repository.
#'
#' 1. Species - A number from 1 to 36 indicating which species the leaf represents
#' 2. Specimen Number - Numbered sequentially within species
#' 3. Eccentricity - Eccentricity of the ellipse with identical second moments to the image. This value ranges from 0 to 1.
#' 4. Aspect Ratio - Values close to 0 indicate an elongated shape.
#' 5. Elongation - The minimum is achieved for a circular region.
#' 6. Solidity - It measures how well the image fits a convex shape.
#' 7. Stochastic Convexity - This variable extends the usual notion of convexity in topological sense, using sampling to perform the calculation.
#' 8. Isoperimetric Factor - The maximum value of 1 is reached for a circular region. Curvy intertwined con- tours yield low values.
#' 9. Maximal Indentation Depth - How deep indentations are
#' 10. Lobedness - This feature characterizes how lobed a leaf is.
#' 11. Average Intensity - Average intensity is defined as the mean of the intensity image
#' 12. Average Contrast - Average contrast is the the standard deviation of the intensity im- age
#' 13. Smoothness - For a region of constant intensity, this takes the value 0 and approaches 1 as regions exhibit larger disparities in intensity values.
#' 14. Third moment - a measure of the intensity histogram’s skewness
#' 15. Uniformity - uniformity’s maximum value is reached when all intensity levels are equal.
#' 16. Entropy - A measure of intensity randomness.
#'
#'
#' @source <https://archive.ics.uci.edu/ml/datasets/Leaf>
"leaf"

#' Economic mobility dataset
#'
#' Data for discussing the probability of improving one's economic situation
#' across 741 Metropolitan Statistical Areas in the US.
#'
#' The variables are:
#'
#' |Variable | Description |
#' |---|---|
#' |Mobility| The probability that a child born in 1980–1982 into the lowest quintile (20%) of household income will be in the top quintile at age 30. Individuals are assigned to the community they grew up in, not the one they were in as adults.|
#' |Population| in 2000.|
#' |Urban| Is the community primarily urban or rural?|
#' |Black| percentage of individuals who marked black (and nothing else) on census forms.|
#' |Racial Segregation| a measure of residential segregation by race.|
#' |Income Segregation| Similarly but for income.|
#' |Segregation of poverty| Specifically a measure of residential segregation for those in the bottom quarter of the national income distribution.|
#' |Segregation of affluence| Residential segregation for those in the top quarter.|
#' |Commute| Fraction of workers with a commute of less than 15 minutes.|
#' |Mean income| Average income per capita in 2000.|
#' |Gini| A measure of income inequality, which would be 0 if all incomes were perfectly equal, and tends towards 100 as all the income is concentrated among the richest individuals (see Wikipedia, s.v. "Gini coefficient").|
#' |Share 1%| Share of the total income of a community going to its richest 1%.|
#' |Gini bottom 99%| Gini coefficient among the lower 99% of that community.|
#' |Fraction middle class| Fraction of parents whose income is between the national 25th and 75th percentiles.|
#' |Local tax rate| Fraction of all income going to local taxes.|
#' |Local government spending| per capita.|
#' |Progressivity| Measure of how much state income tax rates increase with income.|
#' |EITC| Measure of how much the state contributed to the Earned Income Tax Credit (a sort of negative income tax for very low-paid wage earners).|
#' |School expenditures| Average spending per pupil in public schools.|
#' |Student/teacher ratio| Number of students in public schools divided by number of teachers.|
#' |Test scores| Residuals from a linear regression of mean math and English test scores on household income per capita.|
#' |High school dropout rate| Residuals from a linear regression of the dropout rate on per-capita income.|
#' |Colleges per capita|
#' |College tuition| in-state, for full-time students|
#' |College graduation rate| Again, residuals from a linear regression of the actual graduation rate on household income per capita.|
#' |Labor force participation| Fraction of adults in the workforce.|
#' |Manufacturing| Fraction of workers in manufacturing.|
#' |Chinese imports| Growth rate in imports from China per worker between 1990 and 2000.|
#' |Teenage labor| fraction of those age 14–16 who were in the labor force.|
#' |Migration in| Migration into the community from elsewhere, as a fraction of 2000 population.|
#' |Migration out| Ditto for migration into other communities.|
#' |Foreign| fraction of residents born outside the US.|
#' |Social capital| Index combining voter turnout, participation in the census, and participation in community organizations.|
#' |Religious| Share of the population claiming to belong to an organized religious body.|
#' |Violent crime| Arrests per person per year for violent crimes.|
#' |Single motherhood| Number of single female households with children divided by the total number of households with children.|
#' |Divorced| Fraction of adults who are divorced.
#' |Married| Ditto.|
#' |Longitude| Geographic coordinate for the center of the community| |Latitude| Ditto|
#' |ID| A numerical code, identifying the community.|
#' |Name| the name of principal city or town.|
#' |State| the state of the principal city or town of the community.|
#'
#' @source
#' This data set was based on the paper "Where is the Land of Opportunity?
#' The Geography of Intergenerational Mobility in the United States" (Raj Chetty,
#' Nathaniel Hendren, Patrick Kline, Emmanuel Saez, QJE 2014), and its replication
#' files. Both the paper and the data sets are available from <https://opportunityinsights.org.>
#'
"mobility"


#' S301 Grade Distributions
#'
#' A dataset containing the grade distributions for each section of Indiana
#' University's 
#' STAT-S301 (Business statistics) between 2015-2019.
#' 
#' | Variable | Description |
#' | --- | --- |
#' |term | the semester and year of the course | 
#' |term_id |numeric code for the semester and year of the course |
#' | instructor | a unique number corresponding to the course instructor |
#' | n_students | number of students in the course |
#' | avg_grade | average final grade |
#' | avg_student_gpa | average gpa for enrolled students
#' 
#' 
#' The remaining columns contain the percentage of students who earned A-D or other,
#' as well as the count of students earning each of the allowed letter grades.
#'
#'
"s301gradedist"




#' Light detection and ranging
#'
#' The \code{lidar} data frame has 221 pairs from a LIght Detection And Ranging (LIDAR) experiment.
#'
#' @description 
#' This data frame contains the following columns:
#' 
#' `range` distance traveled before the light is reflected back to its source.
#' 
#' `logratio` logarithm of the ratio of received light from two laser sources.
#' 
#' @source Sigrist, M. (Ed.) (1994). \emph{Air Monitoring by Spectroscopic Techniques} (Chemical Analysis Series, vol. 197). New York: Wiley.
#' @source Originally downloaded from \url{http://matt-wand.utsacademics.info/webspr/lidar.txt}. Also available in the [HRW](https://cran.r-project.org/web/packages/HRW/) package.
#' 
#' @examples
#' data(lidar)
#' with(lidar, plot(range,logratio))
"lidar"


#' Great British bakeoff results
#'
#' Results for individual bakers across all GBBO series
#'
#' @format A data frame with 95 rows representing individual bakers and 24 variables:
#' \describe{
#'   \item{winners}{was the baker in the final episode?}
#'   \item{series}{an integer denoting UK series (1-8)}
#'   \item{baker_full}{a character string giving full name}
#'   \item{age}{an integer denoting age in years at first episode appeared}
#'   \item{occupation}{a character string giving occupation}
#'   \item{hometown}{a character string giving hometown}
#'   \item{percent_star}{the percentage of episodes achieving star baker}
#'   \item{percent_technical_wins}{percent of episodes the baker won the technical}
#'   \item{percent_technical_top3}{percent of times a given baker was in the top 3 (1st, 2nd, or 3rd) on the technical challenge}
#'   \item{percent_technical_bottom3}{percent of times a given baker was in the bottom 3 on the technical challenge}
#'   \item{technical_highest}{an integer denoting the best technical rank earned by a given baker across all episodes appeared (higher is better)}
#'   \item{technical_lowest}{an integer denoting the worst technical rank earned by a given baker across all episodes appeared (higher is better)}
#'   \item{technical_median}{an integer denoting the median technical rank earned by a given baker across all episodes appeared (higher is better)}
#'   \item{judge1}{the name of one of the judges}
#'   \item{judge2}{the name of the other judge}
#'   \item{viewers_7day}{number of viewers in millions within a 7-day window from airdate}
#'   \item{viewers_28day}{number of viewers in millions within a 28-day window from airdate}
#' }
#' 
#' @source This is a combination of two datasets in Allison Hill's [bakeoff](https://bakeoff.netlify.app) package.
"gbbakeoff"