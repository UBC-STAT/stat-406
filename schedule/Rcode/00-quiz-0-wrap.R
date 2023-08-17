## ----setup, include=FALSE----------------------------------------------------------------
source("rmd_config.R")
quiz = readr::read_csv("../grade-processing/quiz0-for-R.csv")


## ---- echo=FALSE, fig.height=6, fig.align='center'---------------------------------------
quiz %>% ggplot(aes(str_wrap(syllabus,20))) + geom_bar(fill=blue) + 
  xlab("") + theme_cowplot()


## ---- echo=FALSE, fig.height=6, fig.width=12, fig.align='center'-------------------------
quiz %>% ggplot(aes(str_wrap(R,20))) + geom_bar(fill=blue) + 
  xlab("") + theme_cowplot()
library(MASS)


## ----------------------------------------------------------------------------------------
X = matrix(c(5,3,1,-1), nrow=2)
X
solve(X)
ginv(X)
X^(-1)


## ----------------------------------------------------------------------------------------
y = X %*% c(2,-1) + rnorm(2)
coefficients(lm(y~X))
coef(lm(y~X))
solve(t(X) %*% X) %*% t(X) %*% y
# X \ y this it Matlab


## ---- echo=FALSE, fig.height=6, fig.width=12, fig.align='center'-------------------------
p1 = quiz %>% 
  ggplot(aes(str_wrap(pets,30))) + geom_bar(fill=blue) + 
  coord_flip() + 
  xlab("") + theme_cowplot()
p2 = quiz %>% 
  ggplot(aes(str_wrap(plans,20))) + geom_bar(fill=orange) + 
  coord_flip() + 
  xlab("") + theme_cowplot()
plot_grid(p1,p2)


## ---- echo=FALSE, fig.height=6, fig.width=12, fig.align='center'-------------------------
s406 = as.factor(rep(c("50-54%","55-59%","60-63%","64-67%","68-71%","72-75%","76-79%","80-84%","85-89%","90-100%"), times=c(3,1,3,9,5,13,10,11,20,27)))
preds = cut(quiz$grade[!is.na(quiz$grade)], 
            c(0,50,54,59,63,67,71,75,79,84,89,101),
            c("<50%","50-54%","55-59%","60-63%","64-67%","68-71%","72-75%","76-79%","80-84%","85-89%","90-100%"))
data.frame(name=rep(c("2018 distribution", "your predictions"), 
                    times=c(length(s406),length(preds))), 
           value=fct_c(s406,preds)) %>%
  mutate(value = fct_relevel(value, "<50%")) %>%
  ggplot(aes(value, fill=name)) + geom_bar(position = position_dodge()) +
  scale_fill_manual(values=c(blue,orange)) + theme_cowplot()


