## -------------------------------------------------------------------------------
#| eval: false
## n <- 200
## df <- tibble(
##   x = seq(.05, 1, length = n),
##   y = sin(1 / x) + rnorm(n, 0, .1) # Doppler function
## )
## testdata <- matrix(seq(.05, 1, length.out = 1e3), ncol = 1)
## library(neuralnet)
## nn_out <- neuralnet(y ~ x, data = df, hidden = c(10, 5, 15), threshold = 0.01, rep = 3)
## nn_preds <- map(1:3, ~ compute(nn_out, testdata, .x)$net.result)
## yhat <- nn_preds |> bind_cols() |> rowMeans() # average over the runs


## -------------------------------------------------------------------------------
#| eval: false
#| code-fold: true
## # This code will reproduce the analysis, takes some time
## set.seed(406406406)
## n <- 200
## df <- tibble(
##   x = seq(.05, 1, length = n),
##   y = sin(1 / x) + rnorm(n, 0, .1) # Doppler function
## )
## testx <- matrix(seq(.05, 1, length.out = 1e3), ncol = 1)
## library(neuralnet)
## library(splines)
## fstar <- sin(1 / testx)
## spline_test_err <- function(k) {
##   fit <- lm(y ~ bs(x, df = k), data = df)
##   yhat <- predict(fit, newdata = tibble(x = testx))
##   mean((yhat - fstar)^2)
## }
## Ks <- 1:15 * 10
## SplineErr <- map_dbl(Ks, ~ spline_test_err(.x))
## 
## Jgrid <- c(5, 10, 15)
## NNerr <- double(length(Jgrid)^3)
## NNplot <- character(length(Jgrid)^3)
## sweep <- 0
## for (J1 in Jgrid) {
##   for (J2 in Jgrid) {
##     for (J3 in Jgrid) {
##       sweep <- sweep + 1
##       NNplot[sweep] <- paste(J1, J2, J3, sep = " ")
##       nn_out <- neuralnet(y ~ x, df,
##         hidden = c(J1, J2, J3),
##         threshold = 0.01, rep = 3
##       )
##       nn_results <- sapply(1:3, function(x) {
##         compute(nn_out, testx, x)$net.result
##       })
##       # Run them through the neural network
##       Yhat <- rowMeans(nn_results)
##       NNerr[sweep] <- mean((Yhat - fstar)^2)
##     }
##   }
## }
## 
## bestK <- Ks[which.min(SplineErr)]
## bestspline <- predict(lm(y ~ bs(x, bestK), data = df), newdata = tibble(x = testx))
## besthidden <- as.numeric(unlist(strsplit(NNplot[which.min(NNerr)], " ")))
## nn_out <- neuralnet(y ~ x, df, hidden = besthidden, threshold = 0.01, rep = 3)
## nn_results <- sapply(1:3, function(x) compute(nn_out, testdata, x)$net.result)
## # Run them through the neural network
## bestnn <- rowMeans(nn_results)
## plotd <- data.frame(
##   x = testdata, spline = bestspline, nnet = bestnn, truth = fstar
## )
## save.image(file = "data/nnet-example.Rdata")


## ----fun-nnet-spline, echo=FALSE, fig.align='center', fig.width=10, fig.height=4----
load("data/nnet-example.Rdata")
plotd |>
  pivot_longer(-x) |>
  ggplot(aes(x, value, color = name)) +
  geom_line(linewidth = 1.5) +
  ylab("y") +
  scale_color_manual(values = c(red, orange, blue)) +
  theme(legend.title = element_blank()) +
  geom_point(
    data = df, mapping = aes(x, y),
    color = "black", alpha = .4, shape = 16
  )


## ----nnet-vs-spline-plots, echo=FALSE, fig.align='center',fig.height=6,fig.width=12----
library(cowplot)
doppler_nnet <- data.frame(x = NNplot, err = NNerr)
spl <- data.frame(x = Ks, err = SplineErr)
best <- c(min(NNerr), min(SplineErr))
rel <- function(x) abs(x) / .01
g1 <- ggplot(doppler_nnet, aes(x, rel(err), group = 1)) +
  ggtitle("Neural Nets") +
  xlab("architecture") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5)) +
  geom_line(color = orange, linewidth = 1.5) +
  ylab("Increase in error over f*") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_hline(yintercept = rel(best[1]), color = red, linewidth = 1.5) +
  geom_hline(yintercept = rel(best[2]), color = green, linewidth = 1.5)
g2 <- ggplot(spl, aes(x, rel(err))) +
  ggtitle("Splines") +
  xlab("degrees of freedom") +
  geom_line(color = orange, linewidth = 1.5) +
  ylab("Increase in error over f*") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_hline(yintercept = rel(best[1]), color = red, linewidth = 1.5) +
  geom_hline(yintercept = rel(best[2]), color = green, linewidth = 1.5)
plot_grid(g1, g2)

