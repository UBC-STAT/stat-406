n = 250
set.seed(20200610)
x = sort(runif(n, -2*pi, 2*pi))
fx <- function(x) .75*sin(x) + x/(2*pi)
y = fx(x) + rnorm(n, sd=.35)
blue="#00A7E1"
red="#ff3100"
orange="#ff8300"
green="#00af64"
purple = "#654ea3"


library(ggplot2)

ggplot(data.frame(x=x,y=y)) +
  geom_point(aes(x,y),color="grey",alpha=.75, shape = 16) +
  theme_void() +
  stat_function(fun=fx, color=green, size=2) +
  geom_smooth(aes(x,y), se=FALSE, span=.075, color=purple) +
  #geom_smooth(aes(x,y), se=FALSE, span=.15, color=orange) +
  geom_smooth(aes(x,y), se=FALSE, span=.75, color=orange)
ggsave(here::here("assets","img","smooths.jpg"), width=9, height=4.5)
