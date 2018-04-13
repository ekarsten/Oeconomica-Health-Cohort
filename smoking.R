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

# Sometimes we want nicer variable labels. This is my prefered method of recoding

# first create a sort of codebook table by looking up the codebook online

smokestatus_codebook <-
  tibble(SMOKESTATUS2 = c(0,10,11,12,13,20,30,40,90),
         smokestatus_clean = c(NA, rep("Smoker", 5),"Non-Smoker", "Smoker", NA))

SMOKESTATUS2		Cigarette smoking recode 2: Current detailed/former/never
00		NIU
10		Current smoker
11		Current every day smoker
12		Current some day smoker
13		Current smoker, unknown how often smokes
20		Former smoker
30		Never smoked
40		Has smoked, current smoking status unknown
90		Unknown if ever smoked

# Then merge in the new codings into the dataset:

df_clean <-
  df %>%
  left_join(smokestatus_codebook, by = "SMOKESTATUS2")

# Now you try recoding education in a sensible way












