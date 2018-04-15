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

load(file.path(ddir, "clean_health_cohort_data.Rda"))

