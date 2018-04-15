
root <- getwd()
while(basename(root) != "Oeconomica-Health-Cohort") {
  root <- dirname(root)
}

source(file.path(root, "data.R"))

library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)


load(file.path(ddir, "clean_health_cohort_data.rda"))


countER_df <-
  df %>%
  group_by(YEAR) %>%
  summarize(N_Yes = sum(delaycost == "Yes",na.rm=TRUE),
            N_No = sum(delaycost == "No",na.rm=TRUE),
            N_Total = n()) %>% 
  mutate(prop_yes=N_Yes/(N_Yes+N_No))

g1<-countER_df %>%
  ggplot(aes(x=YEAR, y=prop_yes)) +
  geom_point()
g1

g2<-countER_df %>%
  ggplot(aes(x=YEAR, y=N_yes)) +
  geom_point()
g2

