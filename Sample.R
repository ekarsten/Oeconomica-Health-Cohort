root <- getwd()
while(basename(root) !="Oeconomica-Health-Cohort") {
  root <- dirname(root)
}
source(file.path(root, "data.R"))
load(file.path(ddir, "clean_health_cohort_data.Rda"))

library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)