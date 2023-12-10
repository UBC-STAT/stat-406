## -------------------------------------------------------------------------------
#| code-fold: true
set.seed(12345)
x <- 1:99 / 100
y <- rbinom(99, 1, 
            .25 + .5 * (x > .3 & x < .5) + 
              .6 * (x > .7))
dmat <- as.matrix(dist(x))
ksm <- function(sigma) {
  gg <-  dnorm(dmat, sd = sigma) 
  sweep(gg, 1, rowSums(gg), '/') %*% y
}
fstar <- ksm(.04)
gg <- tibble(x = x, fstar = fstar, y = y) %>%
  ggplot(aes(x)) +
  geom_point(aes(y = y), color = blue) +
  geom_line(aes(y = fstar), color = orange, size = 2) +
  coord_cartesian(ylim = c(0,1), xlim = c(0,1)) +
  annotate("label", x = .75, y = .65, label = "f_star", size = 5)
gg


## -------------------------------------------------------------------------------
#| code-fold: true
gg + geom_hline(yintercept = .5, color = green)


## -------------------------------------------------------------------------------
#| code-fold: true
tib <- tibble(x = x, fstar = fstar, y = y)
ggplot(tib) +
  geom_vline(data = filter(tib, fstar > 0.5), aes(xintercept = x), alpha = .5, color = green) +
  annotate("label", x = .75, y = .65, label = "f_star", size = 5) + 
  geom_point(aes(x = x, y = y), color = blue) +
  geom_line(aes(x = x, y = fstar), color = orange, size = 2) +
  coord_cartesian(ylim = c(0,1), xlim = c(0,1))


## ----eval=FALSE-----------------------------------------------------------------
## ghat <- round(predict(lm(y ~ ., data = trainingdata)))

