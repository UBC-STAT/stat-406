## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----plotting-functions, echo=FALSE------------------------------------------------------
library(mvtnorm)
normBall <- function(q=1, len=1000){
  tg = seq(0,2*pi, length=len)
  out = data.frame(x = cos(tg)) %>%
    mutate(b=(1-abs(x)^q)^(1/q), bm=-b) %>%
    gather(key='lab', value='y',-x)
  out$lab = paste0('"||" * beta * "||"', '[',signif(q,2),']')
  return(out)
}

ellipseData <- function(n=100,xlim=c(-2,3),ylim=c(-2,3), 
                        mean=c(1,1), Sigma=matrix(c(1,0,0,.5),2)){
  df = expand.grid(x=seq(xlim[1],xlim[2],length.out = n),
                   y=seq(ylim[1],ylim[2],length.out = n))
  df$z = dmvnorm(df, mean, Sigma)
  df
}
lballmax <- function(ed,q=1,tol=1e-6){
  ed = filter(ed, x>0,y>0)
  for(i in 1:20){
    ff = abs((ed$x^q+ed$y^q)^(1/q)-1)<tol
    if(sum(ff)>0) break
    tol = 2*tol
  }
  best = ed[ff,]
  best[which.max(best$z),]
}


## ----echo=FALSE, dev="svg", warning=FALSE, fig.align="center",fig.height=5,fig.width=5----
nb = normBall(2)
ed = ellipseData()
bols = data.frame(x=1,y=1)
bhat = lballmax(ed, 2)
ggplot(nb,aes(x,y)) + xlim(-2,2) + ylim(-2,2) + geom_path(color=red) + 
  geom_contour(mapping=aes(z=z), color=blue, data=ed, bins=7) +
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + 
  geom_point(data=bols) + coord_equal() +
  geom_label(data=bols, mapping=aes(label=bquote('hat(beta)[ols]')), parse=TRUE,
             nudge_x = .3, nudge_y = .3) +
  geom_point(data=bhat) + xlab(expression(beta[1])) + ylab(expression(beta[2])) + 
  geom_label(data=bhat, mapping=aes(label=bquote('hat(beta)[s]^R')), parse=TRUE,
             nudge_x = -.4, nudge_y = -.4) + theme_cowplot()


## ----load-prostate-----------------------------------------------------------------------
prostate = as_tibble(
  read.table(
    "http://www.web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data", 
    header = TRUE))
prostate


## ----process-prostate, echo=FALSE, dev="svg", message=FALSE,warning=FALSE,fig.height=5,fig.width=8,fig.align="center"----
Y = prostate$lpsa
X = prostate %>% select(-train,-lpsa) %>% as.matrix()
n = length(Y)
p = ncol(X)

library(glmnet)
ridge = glmnet(x=X,y=Y,alpha=0,lambda.min.ratio = .00001)
df = data.frame(as.matrix(t(ridge$beta)))
df$lambda = ridge$lambda
gather(df, key='predictor',value='coefficient',-lambda) %>%
  ggplot(aes(x=lambda,y=coefficient,color=predictor)) + geom_path() + 
  scale_x_log10() + xlab("log(lambda)") +
  scale_color_brewer(palette = 'Set1') + theme_cowplot() +
  geom_hline(yintercept = 0,color="black",linetype="dotted")

