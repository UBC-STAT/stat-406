## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------
source("rmd_config.R")
knitr::opts_chunk$set(echo = FALSE, 
                      fig.align = 'center', fig.width = 10, 
                      fig.height = 5)


## ---- fig.height=5,fig.width=5,fig.align='center'----------------------------------------
x1=rnorm(40); x2=rnorm(40)
x1[1:20] = x1[1:20]+1
x2[1:20] = x2[1:20]-.5
heatmaply::heatmaply(as.matrix(dist(cbind(x1,x2))))


## ---- fig.height=3,fig.width=3-----------------------------------------------------------
set.seed(1)
x1 = runif(7)
x1[1:3] = x1[1:3] + 1
x2 = runif(7,0,2)
tiny = tibble(x1=x1,x2=x2) %>% arrange(x2)
tiny$true = factor(c(2,2,2,1,1,1,1))
g <- ggplot(tiny, aes(x=x1,y=x2)) + geom_point(aes(color=true), size=3) + 
  theme_cowplot() + theme(legend.position='none') + 
  scale_color_manual(values=c(orange,blue))
g + geom_text(label=1:7,nudge_x =.1,nudge_y = .1)


## ---- fig.height=4-----------------------------------------------------------------------
seg = function(a,b){
  o = bind_cols(tiny[a,1:2],tiny[b,1:2])
  names(o) = c('x','y','xend','yend')
  o
}
g + geom_segment(aes(x=x,y=y,xend=xend,yend=yend),data = seg(3,4)) +
  geom_text(label=1:7,nudge_x =.02,nudge_y = .1)


## ---- fig.height=4-----------------------------------------------------------------------
g + geom_segment(aes(x=x,y=y,xend=xend,yend=yend),data = seg(2,5))+
  geom_text(label=1:7,nudge_x =.02,nudge_y = .1)


## ---- fig.height=4-----------------------------------------------------------------------
g + geom_segment(aes(x=x,y=y,xend=xend,yend=yend),
                 data = seg(rep(1:3,times=4),rep(4:7,each=3))) +
  geom_text(label=1:7,nudge_x =.02,nudge_y = .1)


## ---- fig.height=4-----------------------------------------------------------------------
tf = tiny %>% group_by(true) %>% summarize(mx = mean(x1), my = mean(x2)) 
tff = bind_cols(tf[1,2:3],tf[2,2:3])
names(tff) = c('x','y','xend','yend')
g + geom_segment(aes(x=x,y=y,xend=xend,yend=yend),data = tff) + 
  geom_point(data=tf, aes(x=mx,y=my,color=true), shape=1,size=5) +
  geom_text(label=1:7,nudge_x =.02,nudge_y = .1)


## ---- fig.height=4-----------------------------------------------------------------------
tt = seq(0,2*pi,len=50)
tt2 = seq(0,2*pi,len=75)
c1 = data.frame(x=cos(tt),y=sin(tt),grp=1)
c2 = data.frame(x=1.5*cos(tt2),y=1.5*sin(tt2),grp=2)
circles = bind_rows(c1,c2)
di = dist(circles[,1:2])
hc = hclust(di, method="centroid")
g1 = ggplot(circles,aes(x=x,y=y,color=as.factor(grp))) + geom_point() + 
  theme_cowplot() + scale_color_manual(values=c(orange,blue)) +
  ylab('x2')+xlab('x1')+
  theme(legend.position = 'none')


## ---- fig.width=3,fig.height=3-----------------------------------------------------------
g1


## ---- fig.width=4, fig.height=4----------------------------------------------------------
plot(hc)


## ----fig.height=4, fig.width=4-----------------------------------------------------------
g1

