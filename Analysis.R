root <- getwd()
while(basename(root) != "Oeconomica-Health-Cohort") {
  root <- dirname(root)
}

# This line runs the script in your data.R file so that each person can have
# their data in a different place because everyone's file structure will be 
# a little differnt
source(file.path(root, "data.R"))

load(file.path(ddir,"clean_health_cohort_data.Rda"))

library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)

physician_df <-
  df %>%
  select(YEAR, SERIAL, STRATA, PSU, NHISHID, HHWEIGHT, HHWEIGHT, NHISPID, HHX, FMX, PX, 
         PERWEIGHT, SAMPWEIGHT, FWEIGHT, ASTATFLG, CSTATFLG, PERNUM, age, sex, marstat, 
         relate, famstruc1f, PARENTHERE, race, hispanic, educ, empstat, hourswrk, 
         secondjob, POORYN, family_income, WELFMO, checkup, dentint, docvis2w, sawgen) 


b <- physician_df %>%
  mutate(checkupgood = checkup %in% c("Yes")) %>%
  group_by(YEAR) %>%
  summarise(checkup_prop = sum(checkupgood, na.rm = T)/n() ) %>%
  ggplot(aes(x = YEAR, y = checkup_prop)) +
  geom_point()
  
  ggplot(aes(sex, fill = as.character(checkup_prop))) +
  geom_crossbar(position = "fill") +
  facet_grid(sex ~ .) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each checkup by gender and year",
       y = "Proportion",
       x = "Gender",
       fill = "Checkup")


a <- physician_df %>%
  mutate(dentgood = dentint %in% c("under a year", "6 months or less")) %>%
  group_by(YEAR) %>%
  summarise(dent_prop = sum(dentgood, na.rm = T)/n() ) %>%
  ggplot(aes(x = YEAR, y = dent_prop)) +
  geom_point()

