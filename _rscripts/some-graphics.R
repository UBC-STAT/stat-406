n = 250
set.seed(20220610)
x = sort(runif(n, -2*pi, 2*pi))
fx <- function(x) .75*sin(x) + x/(2*pi)
y = fx(x) + rnorm(n, sd=.35)

primary <- "#2c365e"
secondary <- "#e98a15"
tertiary = "#0a8754"
fourth_color = "#DBCBD8"


library(ggplot2)

ggplot(data.frame(x = x, y = y), aes(x, y)) +
  geom_point(color=fourth_color, alpha=.5, shape = 16) +
  theme_void() +
  stat_function(fun=fx, color=secondary, size=2) +
  geom_smooth(se=FALSE, span=.075, color=primary) +
  #geom_smooth(se=FALSE, span=.15, color=orange) +
  geom_smooth(se=FALSE, span=.75, color=tertiary)
ggsave(here::here("assets", "img", "smooths.svg"), width = 9, height = 4.5)
