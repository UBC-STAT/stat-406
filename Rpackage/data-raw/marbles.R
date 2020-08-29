library(tidyverse)
marbles_raw = read_csv("http://www.randalolson.com/wp-content/uploads/Jelles-Marble-Racing-Marbula-One.csv")

marbles_raw = marbles_raw %>% select(-X14) %>% rename(notes=X15) %>%
  mutate(issues = is.na(notes), notes=NULL, QR = substr(Race,3,3),
         Race_number = substr(Race,4,4))

collapsed = marbles_raw %>% 
  pivot_wider(c(`Marble Name`,Race_number), names_from = QR, 
              values_from = c(`Time (s)`,Pole,Points,`Avg Time/Lap`)) %>%
  select(-Pole_R,-Points_Q) %>% 
  rename(Qualifier_Time=`Time (s)_Q`, Starting_position=Pole_Q,
         Race_Points = Points_R, Qualifier_Lap_Avg = `Avg Time/Lap_Q`,
         Race_Lap_Avg=`Avg Time/Lap_R`,
         Race_Time = `Time (s)_R`)
collapsed$QR = 'R'

marbles_short = left_join(
  collapsed, 
  marbles_raw %>% 
    select(QR, `Marble Name`,Site, `Team Name`, 
           `Track Length (m)`, `Host?`,Race_number, `Number Laps`)) 

marbles = marbles_short %>% select(-QR) %>%
  rename(Marble_Name=`Marble Name`, Team_Name=`Team Name`, 
         Track_Length=`Track Length (m)`, Host=`Host?`,
         Race_laps=`Number Laps`)


usethis::use_data(marbles, overwrite = TRUE)
