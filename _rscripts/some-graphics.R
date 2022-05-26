n = 250
set.seed(20220610)
x = sort(runif(n, -2*pi, 2*pi))
fx <- function(x) .75*sin(x) + x/(2*pi)
y = fx(x) + rnorm(n, sd=.35)
blue="#00A7E1"
red="#ff3100"
orange="#ff8300"
green="#00af64"
purple = "#654ea3"
meadow = "#598234"
moss = "#aebd38"
waterfall = "#68829e"
thunder_cloud = "#505160"

library(ggplot2)

ggplot(data.frame(x=x,y=y), aes(x, y)) +
  geom_point(color=thunder_cloud,alpha=.5, shape = 16) +
  theme_void() +
  stat_function(fun=fx, color=moss, size=2) +
  geom_smooth(se=FALSE, span=.075, color=meadow) +
  #geom_smooth(se=FALSE, span=.15, color=orange) +
  geom_smooth(se=FALSE, span=.75, color=waterfall)
ggsave(here::here("assets","img","smooths.jpg"), width=9, height=4.5)
