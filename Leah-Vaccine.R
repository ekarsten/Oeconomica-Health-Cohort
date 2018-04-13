library(readr)
myData <- read.csv("~/Desktop/health_cohort_data.csv", header = T)
View(myData)

library(dplyr)
library(ggplot2)
library(lubridate)
library(knitr)
library(purrr)
library(tidyr)
library(stringr)
myData$VACFLU12M

vaccination_codebook <-
  tibble(VACFLU12M = c(0,1,2,3,7,8,9),
         vaccination_clean = c("NIU","No", "Yes", "Reported both shot and spray", "Refused", "Not Ascertained", "Don't Know"))
