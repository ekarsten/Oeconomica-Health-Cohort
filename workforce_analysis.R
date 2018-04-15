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
  filter(age <= 26, age >= 18, hourswrk != NA)
  
u26_df %>%
  ggplot(aes(x = YEAR, y = hourswrk)) +
  geom_point() 
