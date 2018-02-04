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

# Loop wasn't working for me
#root <- "C:/Users/devin/Documents/Oeconomica-Health-Cohort"

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
library(measurements)

# This is the step where I actually import the data
df <- read.csv(file.path(ddir, "nhis_00001.csv"))


#----------------------------------
# Selecting data
#----------------------------------

# our dataframe, df, has a ton of different variables, the following code just
# selects a few variables of interest to look at: Age, Sex, Education, and Health
# the code below uses something called piping %>% which puts the output of the
# last line into the input of the next:

slim_df <-
  df %>%
  select(AGE, SEX, EDUC, HEALTH)

#Now we want to know what is going on with some variable: simply use the
# following code:

# To list all the things a variable is coded as
unique(df$SEX)

# To summarize the information in a variable
summary(df$AGE)

 # Now let's say we only want people whose sex is coded as 1. I will do the same
# thing three differnt ways to illustrate why piping is useful

slim_df_sex_one <-
  df %>%
  select(AGE, SEX, EDUC, HEALTH) %>%
  filter(SEX == 1)
  
slim_df_sex_one <-
  slim_df %>%
  filter(SEX == 1)

slim_df_sex_one <-
  filter(select(df, AGE, SEX, EDUC, HEALTH), SEX == 1)

# As you can see, this last one is a bit of a pain to read and clearly see what 
# is going on. Now try some out for yourself:

# Select a different set of variables, explore the way they are coded using the 
# above summary statistics tools, and select some interesting subset

my_df <-
  df %>%
  select(AGE, HEIGHT, WEIGHT)

summary(my_df$HEIGHT)

my_df$WEIGHT_KG = conv_unit(my_df$WEIGHT, "lbs", "kg")
my_df$HEIGHT_CM = conv_unit(my_df$HEIGHT, "inch", "cm")

my_df$BMI = with(my_df, WEIGHT_KG/(HEIGHT_CM/100)^2)

slim_df_overweight <-
  my_df %>%
  filter(BMI > 25 & BMI < 40)


#--------------------------------
# Recoding data
#--------------------------------

# Sometimes we want nicer variable labels. This is my prefered method of recoding

# first create a sort of codebook table by looking up the codebook online

sex_codebook <-
  tibble(SEX = c(1,2),
         sex_clean = c("Male","Female"))

# Then merge in the new codings into the dataset:

df_clean <-
  df %>%
  left_join(sex_codebook, by = "SEX")

# Now you try recoding education in a sensible way


educ_codebook <-
  tibble(EDUC = c(00,01,02,03.,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,
                  19,20,21,22,97,98,99),
         educ_clean = c("NIU", "Never attended/kindergarten only",
                       "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5",
                       "Grade 6", "Grade 7", "Grade 8", "Grade 9",
                       "Grade 10", "Grade 11", "12th grade, no diploma",
                       "High school graduate",
                       "GED or equivalent", "Some college, no degree",
                       "AA degree: technical/vocational/occupational",
                       "AA degree: academic program",
                       "Bachelor's degree (BA,AB,BS,BBA",
                       "Master's degree (MA,MS,Med,MBA)", 
                       "Professional (MD,DDS,DVM,JD", 
                       "Doctoral degree (PhD,EdD)", "Unknown--refused",
                       "Unknown--not ascertained", "Unknown--don't know"))


df_clean <-
  df %>%
  left_join(educ_codebook, by = "EDUC")

health_codebook <-
  tibble(HEALTH = c(1,2,3,4,5,7,8,9),
         health_clean = c("Excellent","Very Good", "Good", "Fair", "Poor", 
                       "Unknown-refused", "Unknown-not ascertained", 
                       "Unknown-don't know"))

df_clean <-
  df %>%
  left_join(health_codebook, by = "HEALTH")








