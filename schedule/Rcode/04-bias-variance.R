## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")


## ----------------------------------------------------------------------------------------
mu=1; n=5; sig2=1


## ---- fig.align='center',echo=FALSE,dev="svg",fig.width=8,fig.height=4-------------------
biasSqA <- function(a, mu=1) (a-1)^2 * mu
varA <- function(a, n=1) a^2/n
risk <- function(a, mu=1, n=1, sig2=1) biasSqA(a, mu) + varA(a, n) +  sig2
meanrisk <- function(a, n=1, sig2=1) sig2+1/n
aopt <- function(mu=1, n=1) mu^2/(mu^2+1/n)
ggplot(data.frame(x=c(0,1),y=c(0,2)), aes(x,y)) + 
  stat_function(fun=biasSqA, aes(color="squared bias"))+
  stat_function(fun=varA, aes(color="variance"), args = list(n=n))+
  stat_function(fun=risk, aes(color="risk"), args = list(mu=mu,n=n,sig2=sig2)) + 
  theme_cowplot() + ylab("R(a)") + xlab("a") +
  stat_function(fun=meanrisk, aes(color="risk of mean"), args=list(n=n,sig2=sig2)) + 
  geom_vline(xintercept = aopt(mu,n),color="black") +
  scale_color_manual(guide="legend",
    values = c("squared bias"=red, "variance"=blue,
               "risk"=green, "risk of mean"= orange,
               "best a"="black")
    ) +
  theme(legend.title = element_blank())


## ----fig.align='center',fig.height=6, fig.width=8, dpi=300, echo=FALSE, message=FALSE----
cols = c(blue, red, green, orange)

par(mfrow=c(2,2),bty='n',ann=FALSE,xaxt='n',yaxt='n',family='serif',mar=c(0,0,0,0),oma=c(0,2,2,0))
require(mvtnorm)
mv = matrix(c(0,0,0,0,-.5,-.5,-.5,-.5),4,byrow=T)
va = matrix(c(.02,.02,.1,.1,.02,.02,.1,.1),4,byrow=T)

for(i in 1:4){
  plot(0,0,ylim=c(-2,2),xlim=c(-2,2),pch=19,cex=42,col=blue,ann=FALSE,pty='s')
  points(0,0,pch=19,cex=30,col='white')
  points(0,0,pch=19,cex=18,col=green)
  points(0,0,pch=19,cex=6,col=orange)
  points(rmvnorm(20,mean=mv[i,],sigma=diag(va[i,])), cex=1, pch=19)
  switch(i, 
         '1'= {
           mtext('low variance',3,cex=2)
           mtext('low bias',2,cex=2)
         },
         '2'= mtext('high variance',3,cex=2),
         '3' = mtext('high bias',2,cex=2)
  )
}

