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

# This is the step where I actually import the data
df <- read.csv(file.path(ddir, "health_cohort_data.csv"))


slim_df <-
  df %>%
  select(ASTATFLG, CSTATFLG, SEX, MARSTAT, RELATE, FAMSTRUC1F, PARENTHERE, RACEA, HISPETH, EDUC, EMPSTAT, HOURSWRK, SECONDJOB, POORYN, INCFAM97ON2, WELFMO,ERYRNO,DELAYCOST)

delaycost_codebook <-
  tibble(DELAYCOST = c(1,2,0,7,8,9 ),
         delaycost_clean = c("No","Yes",NA,NA,NA,NA))

df_clean <-
  df %>%
  left_join(delaycost_codebook, by = "DELAYCOST")

slim_df_clean <-
  df %>%
  left_join(delaycost_codebook, by = "DELAYCOST")




