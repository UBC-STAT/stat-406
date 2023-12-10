## -------------------------------------------------------------------------------
x <- c(1, 3, 4)
x[1]
x[-1]
rev(x)
c(x, x)


## -------------------------------------------------------------------------------
x <- matrix(1:25, nrow = 5, ncol = 5)
x[1,]
x[,-1]
x[c(1,3),  2:3]


## -------------------------------------------------------------------------------
(l <- list(
  a = letters[1:2], 
  b = 1:4, 
  c = list(a = 1)))
l$a
l$c$a
l["b"] # compare to l[["b"]] == l$b


## -------------------------------------------------------------------------------
(dat <- data.frame(
  z = 1:5, 
  b = 6:10, 
  c = letters[1:5]))
class(dat)
dat$b
dat[1,]


## -------------------------------------------------------------------------------
(dat2 <- tibble(z = 1:5, b = z + 5, c = letters[z]))
class(dat2)


## -------------------------------------------------------------------------------
#| code-fold: true
sig <- sig::sig


## -------------------------------------------------------------------------------
sig(lm)
sig(`+`)
sig(dplyr::filter)
sig(stats::filter)
sig(rnorm)


## -------------------------------------------------------------------------------
set.seed(12345)
rnorm(3)
set.seed(12345)
rnorm(n = 3, mean = 0)
set.seed(12345)
rnorm(3, 0, 1)
set.seed(12345)
rnorm(sd = 1, n = 3, mean = 0)


## ----functions------------------------------------------------------------------
f <- function(arg1, arg2, arg3 = 12, ...) {
  stuff <- arg1 * arg3
  stuff2 <- stuff + arg2
  plot(arg1, stuff2, ...)
  return(stuff2)
}
x <- rnorm(100)


## ----plot-it--------------------------------------------------------------------
y1 <- f(x, 3, 15, col = 4, pch = 19)
str(y1)


## -------------------------------------------------------------------------------
my_histogram <- hist(rnorm(1000))


## -------------------------------------------------------------------------------
str(my_histogram)
class(my_histogram)


## -------------------------------------------------------------------------------
#| error: TRUE
incrementer <- function(x, inc_by = 1) {
  x + 1
}
  
incrementer(2)
incrementer(1:4)
incrementer("a")


## -------------------------------------------------------------------------------
#| error: TRUE
incrementer <- function(x, inc_by = 1) {
  stopifnot(is.numeric(x))
  return(x + 1)
}
incrementer("a")


## -------------------------------------------------------------------------------
#| error: TRUE
incrementer <- function(x, inc_by = 1) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric")
  }
  x + 1
}
incrementer("a")
incrementer(2, -3) ## oops!
incrementer <- function(x, inc_by = 1) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric")
  }
  x + inc_by
}
incrementer(2, -3)


## -------------------------------------------------------------------------------
#| error: true
library(testthat)
incrementer <- function(x, inc_by = 1) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric")
  }
  if (!is.numeric(inc_by)) {
    stop("`inc_by` must be numeric")
  }
  x + inc_by
}
expect_error(incrementer("a"))
expect_equal(incrementer(1:3), 2:4)
expect_equal(incrementer(2, -3), -1)
expect_error(incrementer(1, "b"))
expect_identical(incrementer(1:3), 2:4)


## -------------------------------------------------------------------------------
is.integer(2:4)
is.integer(incrementer(1:3))
expect_identical(incrementer(1:3, 1L), 2:4)


## -------------------------------------------------------------------------------
tib <- tibble(
  x1 = rnorm(100), 
  x2 = rnorm(100), 
  y = x1 + 2 * x2 + rnorm(100)
)
mdl <- lm(y ~ ., data = tib )
class(tib)
class(mdl)


## -------------------------------------------------------------------------------
print(mdl)


## -------------------------------------------------------------------------------
sloop::s3_dispatch(print(incrementer))
sloop::s3_dispatch(print(tib))
sloop::s3_dispatch(print(mdl))


## -------------------------------------------------------------------------------
z <- 1
fun <- function(x) {
  z <- x
  print(z)
  invisible(z)
}
fun(14)


## -------------------------------------------------------------------------------
#| error: TRUE
tib <- tibble(x1 = rnorm(100),  x2 = rnorm(100),  y = x1 + 2 * x2)
mdl <- lm(y ~ x2, data = tib)
x2


## -------------------------------------------------------------------------------
mse1 <- print(
  sum(
    residuals(
      lm(y~., data = mutate(
        tib, 
        x3 = x1^2,
        x4 = log(x2 + abs(min(x2)) + 1)
      )
      )
    )^2
  )
)


## -------------------------------------------------------------------------------
#| code-line-numbers: "|5-6"
mse2 <- tib |>
  mutate(
    x3 = x1^2, 
    x4 = log(x2 + abs(min(x2)) + 1)
  ) %>% # base pipe only goes to first arg
  lm(y ~ ., data = .) |> # note the use of `.`
  residuals() |>
  magrittr::raise_to_power(2) |> # same as `^`(2)
  sum() |>
  print()


## -------------------------------------------------------------------------------
#| code-line-numbers: "|9-10"
tib |>
  mutate(
    x3 = x1^2, 
    x4 = log(x2 + abs(min(x2)) + 1)
  ) %>% # base pipe only goes to first arg
  lm(y ~ ., data = .) |> # note the use of `.`
  residuals() |>
  magrittr::raise_to_power(2) |> # same as `^`(2)
  sum() ->
  mse3


## -------------------------------------------------------------------------------
library(magrittr)
tib <- tibble(x = 1:5, z = 6:10)
tib <- tib |> mutate(b = x + z)
tib
# start over
tib <- tibble(x = 1:5, z = 6:10)
tib %<>% mutate(b = x + z)
tib


## -------------------------------------------------------------------------------
library(epidatr)
covid <- covidcast(
  source = "jhu-csse",
  signals = "confirmed_7dav_incidence_prop,deaths_7dav_incidence_prop",
  time_type = "day",
  geo_type = "state",
  time_values = epirange(20220801, 20220821),
  geo_values = "ca,wa") |>
  fetch() |>
  select(geo_value, time_value, signal, value)

covid


## -------------------------------------------------------------------------------
covid <- covid |> 
  mutate(signal = case_when(
    str_starts(signal, "confirmed") ~ "case_rate", 
    TRUE ~ "death_rate"
  ))


## -------------------------------------------------------------------------------
covid <- covid |> arrange(time_value, geo_value)


## -------------------------------------------------------------------------------
covid |> 
  group_by(geo_value, signal) |>
  summarise(med = median(value), .groups = "drop")


## -------------------------------------------------------------------------------
cases <- covid |> 
  filter(signal == "case_rate") |>
  rename(case_rate = value) |> select(-signal)
deaths <- covid |> 
  filter(signal == "death_rate") |>
  rename(death_rate = value) |> select(-signal)


## -------------------------------------------------------------------------------
joined <- full_join(cases, deaths, by = c("geo_value", "time_value"))


## -------------------------------------------------------------------------------
covid |> pivot_wider(names_from = signal, values_from = value)


## ----adding-geoms---------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 5
ggplot(
  data = covid |> 
    filter(signal == "case_rate")
) +
  geom_point(
    mapping = aes(
      x = time_value,
      y = value
    )
  ) + 
  geom_smooth( 
    mapping = aes( 
      x = time_value, 
      y = value 
    ) 
  ) 


## ----adding-geoms2--------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 5
ggplot(
  data = covid |> filter(signal == "case_rate")
) +
  geom_point(
    mapping = aes(
      x = time_value,
      y = value,
      colour = geo_value
    )
  ) + 
  geom_smooth( 
    mapping = aes( 
      x = time_value, 
      y = value,
      colour = geo_value
    ),
    se = FALSE,
    method = "lm"
  ) 


## ----adding-geoms3--------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 5
ggplot(
  data = covid |> filter(signal == "case_rate"),
  mapping = aes(
    x = time_value,
    y = value,
    colour = geo_value
  )
) +
  geom_point() + 
  geom_smooth(se = FALSE, method = "lm") 


## ----adding-geoms4--------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 5
ggplot(
  covid |> filter(signal == "case_rate"),
  aes(time_value, value, colour = geo_value)
) +
  geom_point() + 
  geom_smooth(se = FALSE, method = "lm") 


## ----adding-geoms5--------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 5
ggplot(
  covid, 
  aes(time_value, value, colour = geo_value)
) +
  geom_point() + 
  geom_smooth(se = FALSE, method = "lm") +
  facet_grid(signal ~ geo_value) +
  scale_colour_manual(
    name = NULL, 
    values = c(blue, orange)) +
  theme(legend.position = "bottom")


## ----adding-geoms6--------------------------------------------------------------
#| output-location: column
#| fig-width: 8
#| fig-height: 5
ggplot(
  covid, 
  aes(time_value, value, colour = geo_value)
) +
  geom_point() + 
  geom_smooth(se = FALSE, method = "lm") +
  facet_grid(signal ~ geo_value, scales = "free_y") +
  scale_colour_manual(
    name = NULL, 
    values = c(blue, orange)) +
  theme(legend.position = "bottom")

