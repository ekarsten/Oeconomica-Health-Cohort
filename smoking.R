#====================================
# Data Cleaning for Smoking Variables
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

# This is the step where I actually import the data
df <- read.csv(file.path(ddir, "health_cohort_data.csv"))


#--------------------------------
# Recoding data
#--------------------------------

# Smoking Status variable

# first create a sort of codebook table by looking up the codebook online

smokestatus_codebook <-
  tibble(SMOKESTATUS2 = c(0,10,11,12,13,20,30,40,90),
         smokestatus_clean = c(NA, rep("Smoker", 5),"Non-Smoker", "Smoker", NA))

# Then merge in the new codings into the dataset:

df <-
  df %>%
  left_join(smokestatus_codebook, by = "SMOKESTATUS2")

# Tried to quit smoking variable

# first create a sort of codebook table by looking up the codebook online

smokequit_codebook <-
  tibble(CSQTRYYR = c(0,1,2,7,8,9),
         smokequit_clean = c(NA, "No", "Yes", NA, NA, NA))

# Then merge in the new codings into the dataset:

df <-
  df %>%
  left_join(smokequit_codebook, by = "CSQTRYYR")

# Time since quit smoking

# first create a sort of codebook table by looking up the codebook online

timequit_codebook <-
  tibble(QUITYRS = c(0:99),
         timequit_clean = c(0:95, rep(NA, 4)))

# Then merge in the new codings into the dataset:

df <-
  df %>%
  left_join(timequit_codebook, by = "QUITYRS")
