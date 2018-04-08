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
library(stargazer)

# This is the step where I actually import the data
df <- read.csv(file.path(ddir, "nhis_00001.csv.gz"))


#A little bit of data cleaning before we begin
sex_codebook <-
  tibble(SEX = c(1,2),
         sex_clean = c("Male","Female"))

educ_codebook <- 
  tibble(EDUC = c(0:22, 97:99),
         educ_clean = c(rep("No Degree", 14),
                        rep("HS Diploma",2),
                        rep("Some College", 3),
                        rep("College Degree", 4),
                        rep(NA, 3)
                        )
         )

slim_df <-
  df %>%
  select(AGE, SEX, EDUC, HEALTH, HEIGHT, WEIGHT) %>%
  mutate(BMI = WEIGHT/HEIGHT) %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(educ_codebook, by = "EDUC")


#----------------------------------
# How do you do a linear model
#----------------------------------

# It's really easy, you just have to create something called a linear model
# object that takes a formula you want to estimate and some data to use to estimate it
# and then the model estimates it 

# This model estimates whether health declines with age and whether there are sex differences in that


model_1 <- lm(HEALTH ~ sex_clean + AGE, data = slim_df)


# Now to display the model

stargazer(model_1,type = "text")


# We see interestingly that as age increases, people report worse health, 
# we also see that men will in general rate their health better than women.
# Additionally the average "at birth" health rating is 1.5 or so.


# Now let's do a model with interaction terms

model_2 <- lm(HEALTH ~ sex_clean * AGE, data = slim_df)

stargazer(model_2,type = "text")

# In this model we observe that the decline rate of their health (as reported)
# will decline ever so slightly slower for men than women


# Now go try out some cool and interesting things on your own!
sex_codebook <-
  tibble(SEX = c(1,2),
         sex_clean = c("Male","Female"))

age_codebook <- 
  tibble(AGE = c(18:85),
         age_clean = c(rep("20s", 12),
                       rep("30s", 10),
                       rep("40s", 10),
                       rep("50s", 10),
                       rep("60s", 10),
                       rep("70s", 10),
                       rep("80s", 6)
         )
  )

sleep_codebook <- 
  tibble(HRSLEEP = c(01:15),
         sleep_clean = c(rep("5<", 5),
                         rep("5-10", 5),
                         rep("10-15", 5)
         )
  )


new_df <- 
  df %>%
  select(AGE, SEX, EDUC, HEALTH, HRSLEEP) %>%
  filter(HRSLEEP >= 1,
         HRSLEEP < 24) %>%
  mutate(life = AGE/HRSLEEP) %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(educ_codebook, by = "EDUC") %>%
  left_join(age_codebook, by = "AGE") %>%
  left_join(sleep_codebook, by = "HRSLEEP") 

model_3 <- lm(HRSLEEP ~ sex_clean + AGE, data = new_df)

stargazer(model_3,type = "text")

model_4 <- lm(HRSLEEP ~ sex_clean * AGE, data = new_df)

stargazer(model_4,type = "text")
