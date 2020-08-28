## code to prepare `gbbakeoff` dataset goes here
library(bakeoff)

better_results = baker_results %>% mutate(
  percent_star = star_baker / total_episodes_appeared,
  winners = series_runner_up | series_winner,
  percent_technical_wins = technical_winner / total_episodes_appeared,
  percent_technical_bottom3 = technical_bottom / total_episodes_appeared
)

exam_results = better_results %>% dplyr::select(
  winners, series, baker_full, age, occupation, hometown, percent_star, percent_technical_wins,
  percent_technical_bottom3, percent_technical_top3, technical_highest, technical_lowest,
  technical_median
)
judge1 = rep("Paul Hollywood", nrow(exam_results))
exam_results$judge1 = judge1
exam_results = exam_results %>% mutate(judge2 = ifelse(series<8, "Merry Berry", "Prue Leith"))

bake_ratings = ratings_seasons %>% group_by(series) %>% 
  summarise_at(vars(viewers_7day:viewers_28day), mean, na.rm=TRUE)

gbbakeoff = left_join(exam_results, bake_ratings, by="series")


usethis::use_data(gbbakeoff, overwrite = TRUE)
