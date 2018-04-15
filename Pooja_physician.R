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
library(tidyr)hell
library(stringr)

# This is the step where I actually import the data
# ddir <-  "/Users/Pooja/Desktop/Oeconomica"
df <- read.csv(file.path(ddir, "health_cohort_data.csv"))

#cleaup by codebooks
CHECKUP_codebook <- 
  tibble(CHECKUP = c(0,1,2,7,8,9), 
         checkup_clean = c(NA, "No", "Yes", NA, NA, NA))

DENTINT_codebook <-
  tibble(DENTINT = c(00,10,20,21,22,23,30,31,32,40,41,42,43,44,45,50,60,61,62,63,90,07,98,99),
         dentint_clean = c(rep(NA, 2), 
                           rep("6 months or less", 3),
                           rep("under a year", 4), 
                           rep("1 to 5 years", 6), 
                           rep("greater than 5 years", 5), 
                           rep(NA, 4)))

DOCVIS2W_codebook <- 
  tibble(DOCVIS2W = c(1,2,7,8,9), 
         docvis2w_clean = c("No", "Yes", NA, NA, NA))

SAWGEN_codebook <- 
  tibble(SAWGEN = c(0,1,2,7,8,9), 
         sawgen_clean = c(NA, "No", "Yes", NA, NA, NA))

#applying codebooks
physician_df <-
  df %>%
  select(YEAR, SERIAL, STRATA< PSU, NHISID, NHWEIGHT, HHWEIGHT, NHISPID, HHX, FMX, PX, 
         PERWEIGHT, SAMPWEIGHT, FWEIGHT, ASTATFLG, CSTAFLG, PERNUM, AGE, SEX, MARSTAT, 
         RELATE, FAMSTRUCC1F, PARENTHERE, RACEA, HISPETH, EDUC, EMPSTAT, HOURSWRK, 
         SECONDJOB, POORYN, INCFAM970N2, WELFMO, CHECKUP, DENTINT, DOCVIS2W, SAWGEN) %>%
  left_join(CHECKUP_codebook, by = "CHECKUP") %>%
  left_join(DENTINT_codebook, by = "DENTINT") %>%
  left_join(DOCVIS2W_codebook, by = "DOCVIS2W") %>%
  left_join(SAWGEN_codebook, by = "SAWGEN") 



