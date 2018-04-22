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

#-------------------------------------
# Figure about insurance over time
#-------------------------------------

df %>%
  group_by(YEAR, sex, race) %>%
  summarise(prop_insurance = sum(any_insurance == "Yes", na.rm = T)/sum(any_insurance %in% c("Yes", "No"), na.rm = T)) %>%
  ggplot(aes(x = YEAR, y = prop_insurance, color = sex)) +
  geom_point() +
  theme_bw() +
  facet_wrap(~race) +
  labs(x = "Year",
       y = "Proportion with Insurance")

df %>%
  group_by(YEAR) %>%
  summarise(p = sum(any_insurance == "Yes", na.rm = T)/sum(any_insurance %in% c("Yes", "No"), na.rm = T),
            n =  sum(any_insurance %in% c("Yes", "No"), na.rm = T)  ) %>%
  mutate(error = 1.96 * sqrt(p*(1-p)/n )) %>%
  ggplot(aes(x = YEAR, y = p)) +
  geom_point() +
  geom_errorbar(aes(ymin = p-error, ymax = p+error), width = .1) +
  theme_bw() +
  labs(x = "Year",
       y = "Proportion with Insurance")




