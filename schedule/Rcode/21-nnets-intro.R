## ----sigmoid, echo=FALSE, fig.align='center', fig.height=5, fig.width=10--------
activations <- tibble(
  x = seq(-2, 2, length.out = 100),
  identity = x,
  step = -1 * (x <= 0) + 1 * (x > 0),
  logistic = 2 / (1 + exp(-x)) - 1,
  tanh = tanh(x),
  ReLU = 0 * (x <= 0) + x * (x > 0)
)
activations %>%
  pivot_longer(-x) |> 
  ggplot(aes(x, y = value, color = name)) +
  geom_line(size = 2) +
  # coord_cartesian(ylim=c(0,3)) +
  theme(legend.title = element_blank(), legend.position = c(.85, .25)) +
  scale_color_viridis_d() +
  ylab(bquote(g(u))) +
  xlab("u")

