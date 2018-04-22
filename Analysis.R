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
         secondjob, POORYN, family_income, WELFMO, checkup, dentint, docvis2w, sawgen, 
         any_insurance) 


b <- physician_df %>%
  mutate(checkupgood = checkup %in% c("Yes")) %>%
  group_by(YEAR) %>%
  summarise(checkup_prop = sum(checkupgood, na.rm = T)/n() ) %>%
  ggplot(aes(x = YEAR, y = checkup_prop)) +
  geom_point() %>%
 
  
physician_df %>%
  mutate(checkupgood = checkup %in% c("Yes")) %>% 
  filter(!is.na(any_insurance)) %>%
  group_by(any_insurance, YEAR) %>%
  summarise(checkup_prop = sum(checkupgood, na.rm = T)/sum(checkup %in% c("Yes", "No"), na.rm = T) )%>%
  ggplot(aes(y = checkup_prop, x = YEAR, color = any_insurance )) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each checkup by proportion and year",
       y = "Proportion",
       x = "Year",
       fill = "Checkup")

physician_df %>%
  group_by(YEAR) %>%
  summarise(checkup_prop = sum(checkup=="Yes", na.rm = T)/sum(checkup %in% c("Yes", "No"), na.rm = T),
            insurance_prop = sum(any_insurance=="Yes", na.rm = T)/sum(any_insurance %in% c("Yes", "No"), na.rm = T))%>%
  ggplot(aes(y = checkup_prop, x = insurance_prop) ) +
  geom_point()

physician_df %>%
  group_by(YEAR) %>%
  summarise(checkup_prop = sum(checkup=="Yes", na.rm = T)/n(),
            insurance_prop = sum(any_insurance=="Yes", na.rm = T)/n())%>%
  ggplot(aes(y = checkup_prop, x = insurance_prop) ) +
  geom_point()


physician_df %>%
  ggplot(aes(any_insurance, fill = as.character(Year))) +
  geom_crossbar(position = "fill") +
  facet_grid(any_insurance ~ .) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each sleep level by Age and gender",
       y = "Proportion",
       x = "Year",
       fill = "Checkups")

a <- physician_df %>%
  mutate(dentgood = dentint %in% c("under a year", "6 months or less")) %>%
  group_by(YEAR) %>%
  summarise(dent_prop = sum(dentgood, na.rm = T)/n() ) %>%
  ggplot(aes(x = YEAR, y = dent_prop)) +
  geom_point()

c <- physician_df %>%
  mutate(docvis2wgood = docvis2w %in% c("Yes")) %>%
  group_by(YEAR) %>%
  summarise(docvis2w_prop = sum(docvis2wgood, na.rm = T)/n() ) %>%
  ggplot(aes(x = YEAR, y = docvis2w_prop)) +
  geom_point()
