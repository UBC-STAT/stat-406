# load packages ----------------------------------------------------------------

library(xaringanthemer)

secondary = "#e98a15"
primary = "#2c365e"
tertiary = "#0a8754"
fourth_color = "#a8201a"

# set colors -------------------------------------------------------------------
style_duo_accent(
  primary_color      = primary, 
  secondary_color    = secondary, 
  header_font_google = google_font("Fira Sans"),
  text_font_google   = google_font("Fira Sans", "300", "300i"),
  code_font_google   = google_font("Ubuntu Mono"),
  #text_font_size     = "30px",
  table_row_even_background_color = lighten_color(primary, 0.8),
  outfile            = "materials/xaringan-themer.css",
  colors = c(
    tertiary = tertiary, fourth_color = fourth_color,
    light_pri = lighten_color(primary, 0.8),
    light_sec = lighten_color(secondary, 0.8),
    light_ter = lighten_color(tertiary, 0.8),
    light_fou = lighten_color(fourth_color, 0.8)
    )
)
