## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----------------------------------------------------------------------------------------
niter = 10
gam = 0.1
x = double(niter)
x[1] = 23
grad <- function(x) 2*(x-6)
for(i in 2:niter) x[i] = x[i-1] - gam*grad(x[i-1])


## ----echo=FALSE, fig.height=4,fig.width=4,fig.align='center'-----------------------------
ggplot(data.frame(x=x, y=(x-6)^2)) + geom_path(aes(x,y)) + 
  geom_point(aes(x,y)) +
  theme_cowplot() + coord_cartesian(xlim=c(6-24,24),ylim=c(0,300)) +
  geom_vline(xintercept = 6, color=red,linetype="dotted") +
  geom_hline(yintercept = 0,color=red,linetype="dotted") +
  stat_function(data=data.frame(x=c(6-24,24)),aes(x), fun=function(x) (x-6)^2, color=blue, alpha=.4) +
  ylab(bquote(f(x)))


## ---- fig.height=6, fig.width=12, fig.align="center", echo=FALSE-------------------------
f <- function(x) (x-1)^2*(x>1) + log(1+exp(-2*x))
fp <- function(x) 2*(x-1)*(x>1) -2/(1+exp(2*x))
quad <- function(x, x0, gam=.1) f(x0) + fp(x0)*(x-x0) + 1/(2*gam)*(x-x0)^2
x = c(-1.75,-1,-.5)

ggplot(data.frame(x=c(-2,3)), aes(x)) + 
  stat_function(fun=f, color=blue) + 
  theme_cowplot() + 
  geom_point(data=data.frame(x=x,y=f(x)),aes(x,y),color=red) +
  stat_function(fun=quad, args = list(x0=-1.75), color=red) +
  stat_function(fun=quad, args = list(x0=-1), color=red) +
  stat_function(fun=quad, args = list(x0=-.5), color=red) +
  coord_cartesian(ylim=c(0,4)) + ggtitle(bquote(gamma==0.1))

