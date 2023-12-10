## -------------------------------------------------------------------------------
data("mobility", package = "Stat406")
mobility


## -------------------------------------------------------------------------------
set.seed(20220914)
mob <- mobility[complete.cases(mobility), ]
n <- nrow(mob)
mob <- mob |> select(-Name, -ID, -State)
set <- sample.int(n, floor(n * .75), FALSE)
train <- mob[set, ]
test <- mob[setdiff(1:n, set), ]
full <- lm(Mobility ~ ., data = train)


## -------------------------------------------------------------------------------
summary(full)


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 3.5
par(mar = c(5, 3, 0, 0))
plot(full, 1)


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 3.5
plot(full, 2)


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 3.5
stuff <- tibble(
  residuals = residuals(full), 
  fitted = fitted(full),
  stdresiduals = rstandard(full)
)
ggplot(stuff, aes(fitted, residuals)) +
  geom_point(colour = "salmon") +
  geom_smooth(
    se = FALSE, 
    colour = "steelblue", 
    linewidth = 2) +
  ggtitle("Residuals vs Fitted")


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 3.5
ggplot(stuff, aes(sample = stdresiduals)) +
  geom_qq(colour = "purple", size = 2) +
  geom_qq_line(colour = "peachpuff", linewidth = 2) +
  labs(
    x = "Theoretical quantiles", 
    y = "Standardized residuals",
    title = "Normal Q-Q")


## -------------------------------------------------------------------------------
reduced <- lm(
  Mobility ~ Commute + Gini_99 + Test_scores + HS_dropout +
    Manufacturing + Migration_in + Religious + Single_mothers, 
  data = train)

summary(reduced)$coefficients |> as_tibble()

reduced |> broom::glance() |> print(width = 120)


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 3.5
plot(reduced, 1)


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 3.5
plot(reduced, 2)


## -------------------------------------------------------------------------------
map( # smaller AIC is better
  list(full = full, reduced = reduced), 
  ~ c(aic = AIC(.x), rsq = summary(.x)$r.sq))


## -------------------------------------------------------------------------------
mses <- function(preds, obs) {
  round(mean((obs - preds)^2), 5)
}
c(
  full = mses(
    predict(full, newdata = test), 
    test$Mobility),
  reduced = mses(
    predict(reduced, newdata = test), 
    test$Mobility)
)


## -------------------------------------------------------------------------------
#| fig-height: 4
#| fig-width: 8
#| code-fold: true
test$full <- predict(full, newdata = test)
test$reduced <- predict(reduced, newdata = test)
test |> 
  select(Mobility, full, reduced) |>
  pivot_longer(-Mobility) |>
  ggplot(aes(Mobility, value)) + 
  geom_point(color = "orange") + 
  facet_wrap(~name, 2) +
  xlab('observed mobility') + 
  ylab('predicted mobility') +
  geom_abline(slope = 1, intercept = 0, col = "darkblue")

