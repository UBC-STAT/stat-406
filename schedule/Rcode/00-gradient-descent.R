## -------------------------------------------------------------------------------
niter <- 10
gam <- 0.1
x <- double(niter)
x[1] <- 23
grad <- function(x) 2 * (x - 6)
for (i in 2:niter) x[i] <- x[i - 1] - gam * grad(x[i - 1])


## ----echo=FALSE-----------------------------------------------------------------
#| fig-width: 5
#| fig-height: 8
ggplot(data.frame(x = x, y = (x - 6)^2)) +
  geom_path(aes(x, y)) +
  geom_point(aes(x, y)) +
  coord_cartesian(xlim = c(6 - 24, 24), ylim = c(0, 300)) +
  geom_vline(xintercept = 6, colour = red, linetype = "dotted") +
  geom_hline(yintercept = 0, colour = red, linetype = "dotted") +
  stat_function(data = data.frame(x = c(6 - 24, 24)), aes(x), 
                fun = function(x) (x - 6)^2, colour = blue, alpha = .4) +
  ylab(bquote(f(x)))


## -------------------------------------------------------------------------------
#| echo: false
f <- function(x) (x - 1)^2 * (x > 1) + log(1 + exp(-2 * x))
fp <- function(x) 2 * (x - 1) * (x > 1) - 2 / (1 + exp(2 * x))
quad <- function(x, x0, gam = .1) f(x0) + fp(x0) * (x - x0) + 1 / (2 * gam) * (x - x0)^2
x <- c(-1.75, -1, -.5)

ggplot(data.frame(x = c(-2, 3)), aes(x)) +
  stat_function(fun = f, colour = blue) +
  geom_point(data = data.frame(x = x, y = f(x)), aes(x, y), colour = red) +
  stat_function(fun = quad, args = list(x0 = -1.75), colour = red) +
  stat_function(fun = quad, args = list(x0 = -1), colour = red) +
  stat_function(fun = quad, args = list(x0 = -.5), colour = red) +
  coord_cartesian(ylim = c(0, 4)) +
  ggtitle("gamma = 0.1")


## -------------------------------------------------------------------------------
#| echo: false
ggplot(data.frame(x = c(-2, 3)), aes(x)) +
  stat_function(fun = f, colour = blue) +
  geom_point(data = data.frame(x = x, y = f(x)), aes(x, y), colour = red) +
  stat_function(fun = quad, args = list(x0 = -1.75, gam = .25), colour = red) +
  stat_function(fun = quad, args = list(x0 = -1, gam = .25), colour = red) +
  stat_function(fun = quad, args = list(x0 = -.5, gam = .25), colour = red) +
  coord_cartesian(ylim = c(0, 4)) +
  ggtitle("gamma = 0.25")


## ----message=FALSE, echo=TRUE---------------------------------------------------
x <- matrix(0, 40, 2); x[1, ] <- c(1, 1)
grad <- function(x) c(2, 1) * x


## ----message=FALSE, echo=FALSE--------------------------------------------------
#| fig-width: 8
#| fig-height: 4
df <- expand.grid(b1 = seq(-1, 1, length.out = 100), b2 = seq(-1, 1, length.out = 100))
df <- df %>% mutate(f = b1^2 + b2^2 / 2)
g <- ggplot(df, aes(b1, b2)) +
  geom_raster(aes(fill = log10(f))) +
  scale_fill_viridis_c() +
  xlab("x1") +
  ylab("x2") +
  coord_cartesian(expand = FALSE, ylim = c(-1, 1), xlim = c(-1, 1))
g


## ----message=FALSE, echo=TRUE---------------------------------------------------
gamma <- .1
for (k in 2:40) x[k, ] <- x[k - 1, ] - gamma * grad(x[k - 1, ])


## ----echo=FALSE-----------------------------------------------------------------
#| fig-width: 8
#| fig-height: 4
b <- tibble(b1 = x[, 1], b2 = x[, 2])
g + geom_path(data = b, aes(b1, b2)) +
  geom_point(data = b, aes(b1, b2), size = 2)


## ----message=FALSE, echo=FALSE--------------------------------------------------
x <- matrix(0, 40, 2)
x[1, ] <- c(1, 1)


## ----echo=TRUE------------------------------------------------------------------
gamma <- .9 # bigger gamma
for (k in 2:40) x[k, ] <- x[k - 1, ] - gamma * grad(x[k - 1, ])


## ----echo=FALSE-----------------------------------------------------------------
#| fig-width: 8
#| fig-height: 4
b <- tibble(b1 = x[, 1], b2 = x[, 2])
g + geom_path(data = b, aes(b1, b2)) +
  geom_point(data = b, aes(b1, b2), size = 2)


## ----message=FALSE, echo=FALSE, fig.align='center'------------------------------
x <- matrix(0, 40, 2)
x[1, ] <- c(1, 1)


## ----echo=TRUE------------------------------------------------------------------
gamma <- .9 # big, but decrease it on schedule
for (k in 2:40) x[k, ] <- x[k - 1, ] - gamma * .9^k * grad(x[k - 1, ])


## ----echo=FALSE-----------------------------------------------------------------
#| fig-width: 8
#| fig-height: 4
b <- tibble(b1 = x[, 1], b2 = x[, 2])
g + geom_path(data = b, aes(b1, b2)) + geom_point(data = b, aes(b1, b2), size = 2)


## ----message=FALSE, echo=FALSE, fig.align='center'------------------------------
x <- matrix(0, 40, 2)
x[1, ] <- c(1, 1)


## ----echo=TRUE------------------------------------------------------------------
gamma <- .5 # theoretically optimal
for (k in 2:40) x[k, ] <- x[k - 1, ] - gamma * grad(x[k - 1, ])


## ----echo=FALSE-----------------------------------------------------------------
#| fig-width: 8
#| fig-height: 4
b <- tibble(b1 = x[, 1], b2 = x[, 2])
g + geom_path(data = b, aes(b1, b2)) + geom_point(data = b, aes(b1, b2), size = 2)


## ----generate-data--------------------------------------------------------------
#| output-location: column
#| fig-width: 6
#| fig-height: 4
n <- 100
a <- 2
x <- runif(n, -5, 5)
logit <- function(x) 1 / (1 + exp(-x))
p <- logit(a * x)
y <- rbinom(n, 1, p)
df <- tibble(x, y)
ggplot(df, aes(x, y)) +
  geom_point(colour = "cornflowerblue") +
  stat_function(fun = ~ logit(a * .x))


## ----amlecorrect----------------------------------------------------------------
#| code-line-numbers: "1,10-11|2-3|4-9|"
amle <- function(x, y, a0, gam = 0.5, jmax = 50, eps = 1e-6) {
  a <- double(jmax) # place to hold stuff (always preallocate space)
  a[1] <- a0 # starting value
  for (j in 2:jmax) { # avoid possibly infinite while loops
    px <- logit(a[j - 1] * x)
    grad <- mean(-x * (y - px))
    a[j] <- a[j - 1] - gam * grad
    if (abs(grad) < eps || abs(a[j] - a[j - 1]) < eps) break
  }
  a[1:j]
}


## ----ourmle1--------------------------------------------------------------------
round(too_big <- amle(x, y, 5, 50), 3)
round(too_small <- amle(x, y, 5, 1), 3)
round(just_right <- amle(x, y, 5, 10), 3)


## -------------------------------------------------------------------------------
#| output-location: column
#| fig-width: 6
#| fig-height: 8
negll <- function(a) {
  -a * mean(x * y) -
    rowMeans(log(1 / (1 + exp(outer(a, x)))))
}
blah <- list_rbind(
  map(
    rlang::dots_list(
      too_big, too_small, just_right, .named = TRUE
    ), 
    as_tibble),
  names_to = "gamma"
) |> mutate(negll = negll(value))
ggplot(blah, aes(value, negll)) +
  geom_point(aes(colour = gamma)) +
  facet_wrap(~gamma, ncol = 1) +
  stat_function(fun = negll, xlim = c(-2.5, 5)) +
  scale_y_log10() + 
  xlab("a") + 
  ylab("negative log likelihood") +
  geom_vline(xintercept = tail(just_right, 1)) +
  scale_colour_brewer(palette = "Set1") +
  theme(legend.position = "none")


## -------------------------------------------------------------------------------
summary(glm(y ~ x - 1, family = "binomial"))

