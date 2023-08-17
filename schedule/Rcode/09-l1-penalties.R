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


## ----convexity,echo=FALSE, dev="svg", fig.height=6,fig.width=11,fig.align="center"-------
nbs = list()
nbs[[1]] = normBall(0,1)
qs = c(.5,.75,1,1.5,2)
for(ii in 2:6) nbs[[ii]] = normBall(qs[ii-1])
nbs = bind_rows(nbs)
nbs$lab = factor(nbs$lab, levels = unique(nbs$lab))
seg = data.frame(lab=levels(nbs$lab)[1],
                 x0=c(-1,0),x1=c(1,0),y0=c(0,-1),y1=c(0,1))
levels(seg$lab) = levels(nbs$lab)
ggplot(nbs, aes(x,y)) + geom_path(size=1.2) + 
  facet_wrap(~lab,labeller = label_parsed) + 
  geom_segment(data=seg,aes(x=x0,xend=x1,y=y0,yend=y1),size=1.2) + 
  coord_equal() + geom_vline(xintercept = 0,size=.5) + 
  geom_hline(yintercept = 0,size=.5) +
  theme_cowplot() + xlab("") + ylab("")


## ---- echo=FALSE, warning=FALSE, dev="svg", fig.height=4,fig.width=4,fig.align="center"----
nb = normBall(1)
ed = ellipseData()
bols = data.frame(x=1,y=1)
bhat = lballmax(ed, 1)
ggplot(nb,aes(x,y)) + xlim(-2,2) + ylim(-2,2) + geom_path(color=red) + 
  geom_contour(mapping=aes(z=z), color=blue, data=ed, bins=7) +
  geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + 
  geom_point(data=bols) + coord_equal() +
  geom_label(data=bols, mapping=aes(label=bquote('hat(beta)[ols]')), parse=TRUE,
             nudge_x = .3, nudge_y = .3) +
  geom_point(data=bhat) + xlab(expression(beta[1])) + ylab(expression(beta[2])) + 
  geom_label(data=bhat, mapping=aes(label=bquote('hat(beta)[s]^L')), parse=TRUE,
             nudge_x = -.4, nudge_y = -.4) +
  theme_cowplot()


## ----ridge-v-lasso,echo=FALSE,dev="svg",fig.align="center", fig.width=11, fig.height=6----
library(lars)
library(glmnet)
prostate = as_tibble(
  read.table(
    "http://www.web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data", 
    header = TRUE))
X = prostate %>% dplyr::select(-train,-lpsa) %>% as.matrix()
Y = prostate$lpsa
n = length(Y)
p = ncol(X)
lasso = glmnet(x=X,y=Y)
ridge = glmnet(x=X,y=Y,alpha=0)
df = data.frame(as.matrix(t(ridge$beta)))
df1 = data.frame(as.matrix(t(lasso$beta)))
df$l1norm = colSums(abs(ridge$beta))
df1$l1norm = colSums(abs(lasso$beta))
df$method = 'ridge'
df1$method = 'lasso'
bind_rows(df,df1) %>%
  pivot_longer(names_to='predictor',values_to ='coefficient',
               cols=-c(l1norm,method)) %>%
  ggplot(aes(x=l1norm, y=coefficient, color=predictor)) + geom_path() + 
  facet_wrap(~method,scales = 'free_x') + 
  geom_hline(color="black",linetype="dotted",yintercept = 0) +
  scale_color_brewer(palette = 'Set1') + theme_cowplot() 


## ---- fig.width=8, fig.height=4, fig.align="center", dev="svg"---------------------------
lasso = glmnet(X,Y)
lars.out = lars(X,Y)
par(mfrow=c(1,2))
plot(lasso)
plot(lars.out,main='')


## ----------------------------------------------------------------------------------------
# 1. Estimate cv and model at once
# no formula version
lasso.glmnet = cv.glmnet(X,Y) 
# NEVER use glmnet() itself
# 2. Plot the coefficient path
# 3. Choose lambda using CV
# 4. If the dashed lines are at the 
# boundaries, redo with better lambda
best.lam = lasso.glmnet$lambda.min 
# the value, not the location 
# (or use lasso$lambda.1se)
# 5. Return the coefs/predictions 
# for the best model
coefs.glmnet = coefficients(
  lasso.glmnet, s = best.lam)
preds.glmnet = predict(
  lasso.glmnet, newx = X, s = best.lam) 
# must supply `newx`


## ---- dev="svg", fig.align="center",fig.width=3, fig.height=6,echo=FALSE-----------------
par(mfrow=c(2,1), mar=c(5,3,3,0))
plot(lasso.glmnet$glmnet.fit) # the glmnet.fit == glmnet(X,Y)
# 3. Choose lambda using CV
plot(lasso.glmnet) #a different plot method for the cv fit


## ---- fig.width=11,fig.align="center",dev="svg",fig.height=4-----------------------------
ridge.glmnet = cv.glmnet(X,Y,alpha=0,lambda.min.ratio=1e-10) # added to get a minimum
par(mfrow=c(1,4))
plot(ridge.glmnet)
plot(lasso.glmnet)
plot(ridge.glmnet$glmnet.fit, main='Ridge (glmnet)')
abline(v=sum(abs(coef(ridge.glmnet))))
plot(lasso.glmnet$glmnet.fit, main='Lasso (glmnet)')
abline(v=sum(abs(coef(lasso.glmnet))))

