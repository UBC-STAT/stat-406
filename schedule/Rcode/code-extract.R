id <- here::here("schedule/slides")
od <- here::here("schedule/Rcode")

slides <- list.files(
  path = id,
  pattern = "*.qmd",
  full.names = FALSE
)

for (i in seq_along(slides)) {
  nm <- stringr::str_remove(slides[i], ".qmd")
  knitr::purl(
    input = here::here(id, slides[i]),
    output = here::here(od, paste0(nm, ".R"))
  )
}
