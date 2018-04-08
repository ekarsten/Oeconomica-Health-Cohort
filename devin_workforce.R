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

df <- read.csv(file.path(ddir, "health_cohort_data.csv"))


slim_df <-
  df %>%
  select(YEAR, SERIAL, STRATA, PSU, NHISHID, HHX, FMX, PX, PERWEIGHT, 
         SAMPWEIGHT, FWEIGHT, ASTATFLG, CSTATFLG, PERNUM, AGE, SEX, MARSTAT,
         # labor force variables
         RELATE, FAMSTRUC1F, PARENTHERE, EDUC, EMPSTAT, HOURSWRK, SECONDJOB,
         HINOAGER, HINOFAMR)

# RELATE

relate_codebook <-
  tibble(RELATE = c(10, 20, 21, 22, 30, 40, 41, 43, 44, 50, 60, 70, 71, 72, 73,
                    74, 75, 76, 80, 81, 82, 83, 84, 85, 90, 96, 97, 98, 99),
         relate_clean = c("Householder", 
                          "Spouse",
                          "Spouse, other spouse at home and NOT in Armed forces",
                          "Spouse, other spouse at home and in Armerd Forces",
                          "Unmarried partner",
                          "Child",
                          "Child (bio/adopt/in-law/foster) of householder",
                          "Child of partner",
                          "Child of ineligible householder",
                          "Other relative 1 (not wife, child)",
                          "Grandchild",
                          "Other relative 2 (not grandkid, child, spouse, parent)",
                          "Parent (bio/adopt/in-law/step/foster) of householder",
                          "Brother/sister (bio/adopt/in-law/step/foster)",
                          "Grandparent (Grandma/Grandpa)",
                          "Aunt/uncle",
                          "Niece/nephew",
                          "Other relative 3 (no named category",
                          "Nonrelative",
                          "Housemate/roommate",
                          "Roomer/boarder",
                          "Legal guardian",
                          "Ward",
                          "Other nonrelative",
                          "Unknown",
                          "Unknown - Don't know or refused",
                          "Unknown - Refused",
                          "Unknown - Not ascertained",
                          "Unknown - Don't know"))

empstat_codebook <-
  tibble(EMPSTAT = c(0, 11,12, 20, 30, 40, 97, 98, 99),
         empstat_clean = c("NIU",  "Working for pay at job/business",
                           "Working, w/out pay, at job/business",
                           "With job, but not at work",
                           "Unemployed",
                           "Not in labor force",
                           "Unknown-refused",
                           "Unknown-not ascertained",
                           "Unknown-don't know"))

df_clean <-
  df %>%
  left_join(relate_codebook, by = "RELATE") %>%
  left_join(empstat_codebook, by = "EMPSTAT")


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








