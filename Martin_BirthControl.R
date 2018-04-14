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
root <- "/Users/okmartin/Documents/Oeconomica/Oeconomica-Health-Cohort"
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


#making a slim data file

slim_df <-
  df %>%
  select(YEAR, SERIAL, STRATA, PSU, NHISHID, HHWEIGHT, 
         NHISPID, HHX, FMX, PX, PERWEIGHT, FWEIGHT, ASTATFLG, CSTATFLG, 
         PERNUM, AGE, SEX, MARSTAT, RELATE, FAMSTRUC1F, PARENTHERE, RACEA, 
         HISPETH, EDUC, EMPSTAT, HOURSWRK, SECONDJOB, POORYN, INCFAM97ON2, 
         WELFMO, HPVHEAR, HPVACHAD, BCPILNOW)

#coding sex and merging it with df clean

sex_codebook <-
  tibble(SEX = c(1,2),
         sex_clean = c("Male","Female"))

df_clean <-
  slim_df %>%
  left_join(sex_codebook, by = "SEX")

#coding educ and merging it with df clean

educ_codebook <-
  tibble(EDUC = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,97,98),
         educ_clean = c("NIU","KOnly","1stGrade","2ndGrade","3rdGrade","4thGrade","5thGrade","6thGrade","7thGrade","8thGrade","9thGrade","10thGrade","11thGrade","12NoGrad","HSDip","GED","SomeCollege","AATech","AAAca","BABS","MAMS","MDJD","PhDEdD","Ref","Unknown"))

df_clean <-
  df %>%
  left_join(educ_codebook, by = "EDUC")

#coding birth control use and merging it with df clean

bcpill_codebook <-
  tibble(BCPILNOW = c(0,1,2,7,8,9),
         bcpill_clean = c("NIU","No","Yes","Refused","Not Ascertained","Don't Know"))

df_clean <-
  df %>%
  left_join(bcpill_codebook, by = "BCPILNOW")

#coding hpvhad

hadhpva_codebook <-
  tibble(HPVACHAD = c(00,10,11,20,97,98,99),
         hadhpva_clean = c("NIU","No","Doc Refused","Yes","Refused","Not Ascertained","Don't Know"))

df_clean <-
  df %>%
  left_join(hadhpva_codebook, by = "HPVACHAD")

#coding heard of hpv

heardhpva_codebook <-
  tibble(HPVHEAR = c(0,1,2,7,8,9),
         heardhpva_clean = c("NIU","No","Yes","Refused","Not Ascertained","Don't Know"))

df_clean <-
  df %>%
  left_join(heardhpva_codebook, by = "HPVHEAR")

