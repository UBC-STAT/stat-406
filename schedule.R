## ----setup, echo=FALSE, warning=FALSE, message=FALSE------------------------------------------------------
library(tidyverse)

sched <- read_csv("_data/schedule.csv") %>% select(Date:Activity)
specials <- sched %>% filter(Activity != "Lab") %>% 
  mutate(start = Date, content = Activity, group = as.integer(as.factor(Activity)))
cols = RColorBrewer::brewer.pal(length(unique(sched$Module)), "Set1")
specials = specials %>% 
  mutate(style=paste0("background-color: ",cols)[Module+1])


## ----timeline, eval=FALSE---------------------------------------------------------------------------------
## ng = max(specials$group)
## timevis::timevis(
##   specials, groups =
##     data.frame(id=1:ng, content=rep("",ng)))



## ---------------------------------------------------------------------------------------------------------
knitr::kable(select(filter(sched, Module==0), Date, Activity),"pipe")


## ---------------------------------------------------------------------------------------------------------
knitr::kable(select(filter(sched, Module==1), Date, Activity),"pipe")


## ---------------------------------------------------------------------------------------------------------
knitr::kable(select(filter(sched, Module==2), Date, Activity),"pipe")


## ---------------------------------------------------------------------------------------------------------
knitr::kable(select(filter(sched, Module==3), Date, Activity),"pipe")


## ---------------------------------------------------------------------------------------------------------
knitr::kable(select(filter(sched, Module==4), Date, Activity),'pipe')


## ---------------------------------------------------------------------------------------------------------
knitr::kable(select(filter(sched, Module==5), Date, Activity),'pipe')

