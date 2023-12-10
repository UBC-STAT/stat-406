## -------------------------------------------------------------------------------
#| code-fold: true
#| fig-height: 5
#| fig-width: 8
ggplot() +
  xlim(-2, 2) +
  geom_function(fun = ~log(1+.x^2), colour = 'purple', linewidth = 2) +
  geom_function(fun = ~.x^2, colour = tertiary, linewidth = 2) +
  geom_function(fun = ~abs(.x), colour = primary, linewidth = 2) +
  geom_line(
    data = tibble(x = seq(-2, 2, length.out = 100), y = as.numeric(x != 0)), 
    aes(x, y), colour = orange, linewidth = 2) +
  geom_point(data = tibble(x = 0, y = 0), aes(x, y), 
             colour = orange, pch = 16, size = 3) +
  ylab(bquote("\u2113" * (y - mu))) + xlab(bquote(y - mu))

