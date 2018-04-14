#====================================
# Data Cleaning
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

df <- read.csv(file.path(ddir, "health_cohort_data.csv"))


#--------------------------------
# Recoding data
#--------------------------------

# NOTE TO DEVIN! I don't want all our variables to have nonsense
# names with "clean" in them, so for other cleaning, try to 
# emulate the below:

# Codebooks

sex_codebook <-
  tibble(SEX = c(0,1,2, 7:9),
         sex = c(NA, "Male","Female", rep(NA,3)))

age_codebook <-
  tibble(AGE = 0:99,
         age = c(0:84, rep(NA, 15)))

educ_codebook <-
  tibble(EDUC = c(0:22, 97:99),
         educ = c(NA, rep("No Degree", 13),
                  rep("HS Degree", 2), "Some College",
                  rep("College Degree", 6), rep(NA, 3)))

marstat_codebook <-
  tibble(MARSTAT = c(0, 10:13, 20, 30, 40, 50, 99),
         marstat = c(NA, rep("Married", 4), "Widowed", "Divorced", "Separated",
                     "Never Married", NA))

race_codebook <- 
  tibble(RACEA = c(100, 200, 300: 349, 400:449, 500:599, 600:619, 900:999),
         race = c("White", "Black", rep("Native American", 50),
                  rep("Asian or Pacific Islander", 50),
                  rep("Other", 100), rep("Multiple", 20), rep(NA, 100)))

hispanic_codebook <-
  tibble(HISPETH = c(10, 20:70, 90:93),
         hispanic = c("No", rep("Yes", 51), rep(NA, 4)))

empstat_codebook <-
  tibble(EMPSTAT = c(0, 10:12, 20:22, 30:37, 40, 90:99),
         empstat = c(NA, rep("Employed", 6), rep("Unemployed", 8),
                     "Not In Labor Force", rep(NA, 10)))

income_codebook <-
  tibble(INCFAM97ON2 = c(10, 20, 30:32, 96:99),
         family_income = c("Under 35K", "35K - 75K", rep("Over 75K", 3), rep(NA, 4)))



# Merging in Codebooks and dropping original variables.

df <-
  df %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(age_codebook, by = "AGE") %>%
  left_join(educ_codebook, by = "EDUC") %>%
  left_join(marstat_codebook, by = "MARSTAT") %>%
  left_join(race_codebook, by = "RACEA") %>%
  left_join(hispanic_codebook, by = "HISPETH") %>%
  left_join(empstat_codebook, by = "EMPSTAT") %>%
  left_join(income_codebook, by = "INCFAM97ON2") %>%
  select(-SEX, -AGE, -EDUC, -MARSTAT, -RACEA, -HISPETH, -EMPSTAT, -INCFAM97ON2)













