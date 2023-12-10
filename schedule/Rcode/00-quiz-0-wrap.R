## ----load-quiz, include=FALSE---------------------------------------------------
quiz <- read_rds(here::here(
  "..", "..", "..", "WinterT1-2023", "gh-class-management", "lab0",
  "lab0-anon.rds"
))


## -------------------------------------------------------------------------------
#| echo: false
#| fig-height: 6
#| fig-width: 12
quiz |> 
  ggplot(aes(str_wrap(syllabus, 20))) + 
  geom_bar(fill = blue) + 
  scale_y_continuous(expand = expansion(c(0,0.05))) +
  xlab("") 


## -------------------------------------------------------------------------------
#| echo: false
#| fig-height: 6
#| fig-width: 12
quiz |> 
  ggplot(aes(str_wrap(r_coding, 20))) + 
  geom_bar(fill = blue) + 
  scale_y_continuous(expand = expansion(c(0, 0.05))) +
  xlab("")


## -------------------------------------------------------------------------------
library(MASS)
X <- matrix(c(5, 3, 1, -1), nrow = 2)
X
solve(X)
ginv(X)
X^(-1)


## -------------------------------------------------------------------------------
y <- X %*% c(2, -1) + rnorm(2)
coefficients(lm(y ~ X))
coef(lm(y ~ X))
solve(t(X) %*% X) %*% t(X) %*% y
solve(crossprod(X), crossprod(X, y))


## -------------------------------------------------------------------------------
#| error: true
X \ y # this is Matlab


## -------------------------------------------------------------------------------
#| echo: false
#| fig-height: 6
#| fig-width: 12
library(cowplot)
p1 <- quiz %>%
  ggplot(aes(str_wrap(pets, 30))) +
  geom_bar(fill = blue) +
  coord_flip() +
  scale_y_continuous(expand = expansion(c(0, 0.05))) +
  xlab("")
p2 <- quiz %>%
  ggplot(aes(str_wrap(plans, 20))) +
  geom_bar(fill = orange) +
  coord_flip() +
  scale_y_continuous(expand = expansion(c(0, 0.05))) +
  xlab("")
plot_grid(p1, p2)


## ----echo=FALSE, fig.height=4, fig.width=12, fig.align='center'-----------------
#| echo: false
#| fig-height: 4
#| fig-width: 12
quiz |>
  ggplot(aes(grade)) +
  geom_histogram(
    fill = orange, colour = "black", 
    breaks = c(0, 50, 54, 59, 63, 67, 71, 75, 79, 84, 89, 101)
  ) +
  scale_y_continuous(expand = expansion(c(0, 0.05)))


## -------------------------------------------------------------------------------
#| echo: false
acc <- read_rds(here::here(
  "..", "..", "..", "WinterT1-2022", "final-grades",
  "prediction-accuracy.rds"
)) |>
  rename(predicted = pfg, actual = fg)

ggplot(acc, aes(predicted, actual)) +
  geom_point(colour = orange) +
  geom_abline(slope = 1, intercept = 0) +
  coord_equal(xlim = c(0, 100), ylim = c(0, 100))


## -------------------------------------------------------------------------------
summary(lm(actual ~ predicted - 1, data = acc))

