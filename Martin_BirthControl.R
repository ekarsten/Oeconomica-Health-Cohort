#====================================
# Data Manipulation in the Tidyverse
#====================================

#-----------------------------------
# Setting up workspace
#-----------------------------------

# This snippet of code is a little loop that makes my code work on your computer
root <- getwd()
while(basename(root) != "Oeconomica-Health-Cohort") {
  root <- dirname(root)
}
root <- "/Users/okmartin/Documents/Oeconomica/Oeconomica-Health-Cohort"
# This line runs the script in your data.R file so that each person can have
# their data in a different place because everyone's file structure will be 
# a little differnt
source(file.path(root, "data.R"))


# These are some fantastic packages that I always load in
# You will need to run "install.packages()" with the name of each package
# For example, to install dplyr, run "install.packages("dplyr")"
library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)

# This is the step where I actually import the data

load(file.path(ddir, "clean_health_cohort_data.rda"))


#making a slim data file

slim_df <-
  df %>%
  select(YEAR, SERIAL, STRATA, PSU, NHISHID, HHWEIGHT, 
         NHISPID, HHX, FMX, PX, PERWEIGHT, FWEIGHT, ASTATFLG, CSTATFLG, 
         PERNUM, age, sex, marstat, race, 
         hispanic, educ, empstat, hourswrk, secondjob, POORYN, family_income, 
         WELFMO, any_insurance, heardhpva, hadhpva, bcpill)

f1826_df <-
  slim_df %>%
  filter(age >= 18, age <= 26, sex == "Female")

#graphing based on race

countbc_df <-
  f1826_df %>%
  filter(age >= 18, age <= 26, sex == "Female") %>%
  group_by(YEAR, race, hispanic) %>%
  summarize(N_Yes = sum(bcpill == "Yes"),
            N_No = sum(bcpill == "No"),
            N_Total = n()) %>%
  mutate(prop_yes = N_Yes/(N_No+N_Yes))

countbc_df %>%
  ggplot(aes(x=YEAR, y=prop_yes, color = race)) +
  geom_point() +
  labs(x="Year", y="Proportion Using Birth Control") +
  facet_wrap(~ hispanic)

  
#separated by income

f1826_df <-
  slim_df %>%
  filter(age >= 18, age <= 26, sex == "Female")

countbc_df <-
  f1826_df %>%
  filter(age >= 18, age <= 26, sex == "Female") %>%
  group_by(YEAR, family_income) %>%
  summarize(N_Yes = sum(bcpill == "Yes"),
            N_No = sum(bcpill == "No"),
            N_Total = n(),
            na.rm = TRUE) %>%
  mutate(prop_yes = N_Yes/(N_No+N_Yes))
  
countbc_df %>%
  ggplot(aes(x=YEAR, y=prop_yes, color = family_income)) +
  labs(x="Year", y="Proportion Using Birth Control") +
  geom_point()

#separated by employment status

f1826_df <-
  slim_df %>%
  filter(age >= 18, age <= 26, sex == "Female")

countbc_df <-
  f1826_df %>%
  filter(age >= 18, age <= 26, sex == "Female") %>%
  group_by(YEAR, empstat) %>%
  summarize(N_Yes = sum(bcpill == "Yes"),
            N_No = sum(bcpill == "No"),
            N_Total = n()) %>%
  mutate(prop_yes = N_Yes/(N_No+N_Yes))

countbc_df %>%
  ggplot(aes(x=YEAR, y=prop_yes, color = empstat)) +
  labs(x="Year",y="Proportion Using Birth Control") +
  geom_point()

#separated by having insurance

f1826_df <-
  slim_df %>%
  filter(age >= 18, age <= 26, sex == "Female")

countbc_df <-
  f1826_df %>%
  filter(age >= 18, age <= 26, sex == "Female") %>%
  group_by(YEAR, any_insurance) %>%
  summarize(N_YesBC = sum(bcpill == "Yes"),
            N_NoBC = sum(bcpill == "No"),
            N_TotalBC = n()) %>%
  summarize(N_YesIN = sum(any_insurance == "Yes"),
            N_NoIN = sum(any_insurance == "No"),
            N_TotalIN = n()) %>%
  mutate(prop_yesBC = N_YesBC/(N_No+N_YesBC))

countbc_df %>%
  ggplot(aes(x=YEAR, y=prop_yes, color = any_insurance)) +
  geom_point()

# number using bc
f1826_df <-
  slim_df %>%
  filter(age >= 18, age <= 26, sex == "Female")

countbc_df <-
  f1826_df %>%
  filter(age >= 18, age <= 26, sex == "Female") %>%
  group_by(YEAR) %>%
  summarize(num_bcpill = sum(bcpill=="Yes"))


countbc_df %>%
  ggplot(aes(x=YEAR, y=num_bcpill)) +
  labs(x="Year",y="Number of Women on Birth Control") +
  geom_point()
