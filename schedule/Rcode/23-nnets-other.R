## -------------------------------------------------------------------------------
#| echo: false
#| fig-align: center
tweetrmd::tweet_embed("https://twitter.com/daniela_witten/status/1292293102103748609")


## ----echo=FALSE, eval=TRUE------------------------------------------------------
tweetrmd::tweet_embed("https://twitter.com/daniela_witten/status/1292293104855158784", hide_thread = "t")


## ----fig.width=6, fig.height=4, fig.align='center'------------------------------
library(splines)
set.seed(20221102)
n <- 20
df <- tibble(
  x = seq(-1.5 * pi, 1.5 * pi, length.out = n),
  y = sin(x) + runif(n, -0.5, 0.5)
)
g <- ggplot(df, aes(x, y)) + geom_point() + stat_function(fun = sin) + ylim(c(-2, 2))
g + stat_smooth(method = lm, formula = y ~ bs(x, df = 4), se = FALSE, color = green) + # too smooth
  stat_smooth(method = lm, formula = y ~ bs(x, df = 8), se = FALSE, color = orange) # looks good


## ----fig.width=6, fig.height=4, fig.align='center'------------------------------
xn <- seq(-1.5 * pi, 1.5 * pi, length.out = 1000)
# Spline by hand
X <- bs(df$x, df = 20, intercept = TRUE)
Xn <- bs(xn, df = 20, intercept = TRUE)
S <- svd(X)
yhat <- Xn %*% S$v %*% diag(1/S$d) %*% crossprod(S$u, df$y)
g + geom_line(data = tibble(x=xn, y=yhat), colour = orange) +
  ggtitle("20 degrees of freedom")


## ----fig.width=6, fig.height=4, fig.align='center'------------------------------
xn <- seq(-1.5 * pi, 1.5 * pi, length.out = 1000)
# Spline by hand
X <- bs(df$x, df = 40, intercept = TRUE)
Xn <- bs(xn, df = 40, intercept = TRUE)
S <- svd(X)
yhat <- Xn %*% S$v %*% diag(1/S$d) %*% crossprod(S$u, df$y)
g + geom_line(data = tibble(x = xn, y = yhat), colour = orange) +
  ggtitle("40 degrees of freedom")


## -------------------------------------------------------------------------------
#| code-line-numbers: "1|3-12|13-16|"
doffs <- 4:50
mse <- function(x, y) mean((x - y)^2)
get_errs <- function(doff) {
  X <- bs(df$x, df = doff, intercept = TRUE)
  Xn <- bs(xn, df = doff, intercept = TRUE)
  S <- svd(X)
  yh <- S$u %*% crossprod(S$u, df$y)
  bhat <- S$v %*% diag(1 / S$d) %*% crossprod(S$u, df$y)
  yhat <- Xn %*% S$v %*% diag(1 / S$d) %*% crossprod(S$u, df$y)
  nb <- sqrt(sum(bhat^2))
  tibble(train = mse(df$y, yh), test = mse(yhat, sin(xn)), norm = nb)
}
errs <- map(doffs, get_errs) |>
  list_rbind() |> 
  mutate(`degrees of freedom` = doffs) |> 
  pivot_longer(train:test, values_to = "error")


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 9
#| fig-height: 5
ggplot(errs, aes(`degrees of freedom`, error, color = name)) +
  geom_line(linewidth = 2) + 
  coord_cartesian(ylim = c(0, .12)) +
  scale_x_log10() + 
  scale_colour_manual(values = c(blue, orange), name = "") +
  geom_vline(xintercept = 20)


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 9
#| fig-height: 5
best_test <- errs |> filter(name == "test")
min_norm <- best_test$norm[which.min(best_test$error)]
ggplot(best_test, aes(norm, error)) +
  geom_line(colour = blue, size = 2) + ylab("test error") +
  geom_vline(xintercept = min_norm, colour = orange) +
  scale_y_log10() + scale_x_log10() + geom_vline(xintercept = 20)


## ----message=FALSE--------------------------------------------------------------
library(glmnet)
out <- cv.glmnet(X, df$y, nfolds = n) # leave one out


## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-width: 9
#| fig-height: 2.5
with(
  out, 
  tibble(lambda = lambda, df = nzero, cv = cvm, cvup = cvup, cvlo = cvlo )
) |> 
  filter(df > 0) |>
  pivot_longer(lambda:df) |> 
  ggplot(aes(x = value)) +
  geom_errorbar(aes(ymax = cvup, ymin = cvlo)) +
  geom_point(aes(y = cv), colour = orange) +
  facet_wrap(~ name, strip.position = "bottom", scales = "free_x") +
  scale_y_log10() +
  scale_x_log10() + theme(axis.title.x = element_blank())

