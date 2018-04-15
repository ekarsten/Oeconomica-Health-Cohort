#====================================
# Data Analysis
#====================================

#-----------------------------------
# Setting up workspace
#-----------------------------------

root <- getwd()
while(basename(root) != "Oeconomica-Health-Cohort") {
  root <- dirname(root)
}

source(file.path(root, "data.R"))

library(dplyr)
library(ggplot2)

load(file.path(ddir, "clean_health_cohort_data.Rda"))

#-----------------------------------
# Making A figure for proportion vaccinated over time
#-----------------------------------

df %>%
  group_by(YEAR) %>%
  summarise(prop_vaccinated = sum(vaccination == "Yes", na.rm = T )/n()  ) %>%
  ggplot(aes(x = as.character(YEAR), y = prop_vaccinated)) +
  geom_point() +
  theme_bw() +
  labs(x = "Year",
       y = "Proportion Vaccinated")

df %>%
  group_by(YEAR, sex, race) %>%
  summarise(prop_vaccinated = sum(vaccination == "Yes", na.rm = T )/n()  ) %>%
  ggplot(aes(x = as.character(YEAR), y = prop_vaccinated, color = sex)) +
  geom_point() +
  theme_bw() +
  facet_wrap(~race) +
  labs(x = "Year",
       y = "Proportion Vaccinated")
