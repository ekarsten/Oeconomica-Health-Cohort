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


smokestatus_count <-
  df %>%
  group_by(YEAR) %>%
  summarize(N_Yes = sum(smokestatus == "Smoker", na.rm = TRUE),
            N_No = sum(smokestatus == "Non-Smoker", na.rm = TRUE),
            N_Total = n()) %>% 
  mutate(prop_yes = N_Yes/(N_Yes + N_No))

smokestatus_count %>%
  ggplot(aes(x=YEAR, y=prop_yes)) +
  geom_point()
