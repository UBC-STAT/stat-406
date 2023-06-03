xaringanExtra::use_scribble(
  pen_color = secondary,
  palette = c(primary, secondary, tertiary, fourth_color, 
              RColorBrewer::brewer.pal(6, "Set1"))
)
xaringanExtra::use_panelset()
xaringanExtra::style_panelset_tabs(
  active_foreground = primary,
  hover_foreground = secondary
)
htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i>",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i>",
  ),
  rmarkdown::html_dependency_font_awesome()
)
# xaringanExtra::use_extra_styles(
#   mute_unhighlighted_code = FALSE
# )
# xaringanExtra::use_progress_bar(color = primary, location = "top")
