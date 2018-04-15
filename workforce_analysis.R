# =====================================
# Analyzing workforce data with ggplot
# =====================================

source(file.path(root, "data.R"))
root <- "C:/Users/devin/Documents/Oeconomica-Health-Cohort"


library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)
library(measurements)

load(file.path(ddir, "clean_health_cohort_data.rda"))
