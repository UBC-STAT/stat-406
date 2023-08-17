## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----eval=FALSE--------------------------------------------------------------------------
## n = 200
## df = tibble(x = seq(.05, 1, length=n),
##  y = sin(1/x) + rnorm(n, 0, .1) ## Doppler function
## )
## testdata = matrix(seq(.05, 1, length.out = 1e3), ncol=1)
## library(neuralnet)
## nn_out = neuralnet(y~x, data=df, hidden=c(10,5,15), threshold = 0.01, rep=3)
## nn_preds = sapply(1:3, function(x) compute(nn_out, testdata, x)$net.result)
## yhat = rowMeans(nn_results) # average over the runs


## ----eval=FALSE, cache=TRUE, echo=FALSE--------------------------------------------------
## ## This code will reproduce the analysis, takes some time
## n = 200
## df = tibble(x = seq(.05, 1, length=n),
##  y = sin(1/x) + rnorm(n, 0, .1) ## Doppler function
## )
## testdata = matrix(seq(.05, 1, length.out = 1e3), ncol=1)
## library(neuralnet)
## library(splines)
## fstar = sin(1/testdata)
## fun <- function(k){
##   X = bs(df$x, k)
##   Xtest = bs(testdata, k)
##   yhat = predict(lm(df$y~.,data=X), newdata=Xtest)
##   mean((yhat-fstar)^2)
## }
## Ks = 1:15*10
## SplineErr = sapply(Ks, fun)
## 
## Jgrid = c(5,10,15)
## NNerr = double(length(Jgrid)^3)
## NNplot = character(length(Jgrid)^3)
## sweep = 0
## for(J1 in Jgrid){
##   for(J2 in Jgrid){
##     for(J3 in Jgrid){
##       sweep = sweep + 1
##       NNplot[sweep] = paste(J1,J2,J3,sep=' ')
##       nn_out = neuralnet(y~x, df, hidden=c(J1,J2,J3),
##                          threshold=0.01,rep=3)
##       nn_results = sapply(1:3, function(x)
##         compute(nn_out, testdata, x)$net.result)
##       # Run them through the neural network
##       Yhat = rowMeans(nn_results)
##       NNerr[sweep] = mean((Yhat - fstar)^2)
##     }
##   }
## }
## 
## bestK = Ks[which.min(SplineErr)]
## X = bs(df$x, bestK)
## Xtest = bs(testdata, bestK)
## bestspline = predict(lm(df$y~.,data=X),newdata=Xtest)
## besthidden = as.numeric(unlist(strsplit(NNplot[which.min(NNerr)],' ')))
## nn_out = neuralnet(y~x, df, hidden=besthidden, threshold=0.01,rep=3)
## nn_results = sapply(1:3, function(x)
##   compute(nn_out, testdata, x)$net.result)
##       # Run them through the neural network
## bestnn = rowMeans(nn_results)
## plotd = data.frame(x = testdata, spline = bestspline, nnet=bestnn,
##                    truth=fstar)


## ----fun-nnet-spline, echo=FALSE, fig.align='center', fig.width=10, fig.height=4---------
load("data-and-big-results/nnet-example.Rdata")
plotd %>%
  pivot_longer(-x) %>%
  ggplot(aes(x,value,color=name)) + geom_line() + 
  scale_color_manual(values=c(red, green, blue)) + theme_cowplot() +
  theme(legend.position = c(.75,.25), legend.title = element_blank()) +
  geom_point(data=df,mapping=aes(x,y),color='black', alpha=.2) 


## ----nnet-vs-spline-plots, echo=FALSE, fig.align='center',fig.height=6,fig.width=12------
doppler_nnet = data.frame(x=NNplot,err=NNerr)
spl = data.frame(x=Ks,err=SplineErr)
best = c(min(NNerr),min(SplineErr))
g1 <- ggplot(doppler_nnet, aes(x,err,group=1)) +  
  ggtitle('Neural Nets') + xlab('architecture') + theme_cowplot() + 
  theme(axis.text.x = element_text(angle = 90,vjust=.5)) + 
  geom_line(color=orange) + geom_hline(yintercept = best[1], color=red) +
  geom_hline(yintercept = best[2], color=green) 
g2 <- ggplot(spl, aes(x,err)) + ggtitle('Splines') + xlab('degrees of freedom') +
  geom_line(color=orange) + geom_hline(yintercept = best[1], color=red) +
  geom_hline(yintercept = best[2], color=green) + theme_cowplot()
plot_grid(g1,g2)

