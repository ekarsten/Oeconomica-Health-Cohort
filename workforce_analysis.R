# =====================================
# Analyzing workforce data with ggplot
# =====================================

source(file.path(root, "data.R"))
root <- "C:/Users/devin/Documents/Oeconomica-Health-Cohort"


library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)
library(measurements)

load(file.path(ddir, "clean_health_cohort_data.rda"))


u26_df <-
  df %>%
  filter(age <= 26, age >= 18, !is.na(empstat)) %>%
  group_by(YEAR) %>%
  summarise(emprate = sum(empstat == "Employed")/sum(age <= 26))
  
u26_df %>%
  ggplot(aes(x = YEAR, y = emprate)) +
  geom_point() 

u26_df <-
  df %>%
  filter(age <= 26, age >= 18, !is.na(hinoager)) %>%
  group_by(YEAR) %>%
  summarise(n_yes = sum(hinoager == "Yes")/sum(age <= 26))

u26_df %>%
  ggplot(aes(x = YEAR, y = n_yes)) +
  geom_point() 


