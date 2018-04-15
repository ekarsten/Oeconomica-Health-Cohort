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

df <- read.csv(file.path(ddir, "health_cohort_data.csv"))


#--------------------------------
# Recoding data
#--------------------------------

# Independent variables

sex_codebook <-
  tibble(SEX = c(0,1,2, 7:9),
         sex = c(NA, "Male","Female", rep(NA,3)))

age_codebook <-
  tibble(AGE = 0:99,
         age = c(0:84, rep(NA, 15)))

educ_codebook <-
  tibble(EDUC = c(0:22, 97:99),
         educ = c(NA, rep("No Degree", 13),
                  rep("HS Degree", 2), "Some College",
                  rep("College Degree", 6), rep(NA, 3)))

marstat_codebook <-
  tibble(MARSTAT = c(0, 10:13, 20, 30, 40, 50, 99),
         marstat = c(NA, rep("Married", 4), "Widowed", "Divorced", "Separated",
                     "Never Married", NA))

race_codebook <- 
  tibble(RACEA = c(100, 200, 300: 349, 400:449, 500:599, 600:619, 900:999),
         race = c("White", "Black", rep("Native American", 50),
                  rep("Asian or Pacific Islander", 50),
                  rep("Other", 100), rep("Multiple", 20), rep(NA, 100)))

hispanic_codebook <-
  tibble(HISPETH = c(10, 20:70, 90:93),
         hispanic = c("No", rep("Yes", 51), rep(NA, 4)))

empstat_codebook <-
  tibble(EMPSTAT = c(0, 10:12, 20:22, 30:37, 40, 90:99),
         empstat = c(NA, rep("Employed", 6), rep("Unemployed", 8),
                     "Not In Labor Force", rep(NA, 10)))

income_codebook <-
  tibble(INCFAM97ON2 = c(10, 20, 30:32, 96:99),
         family_income = c("Under 35K", "35K - 75K", rep("Over 75K", 3), rep(NA, 4)))

# Olivia

bcpill_codebook <-
  tibble(BCPILNOW = c(0,1,2,7,8,9),
         bcpill = c("NIU","No","Yes","Refused","Not Ascertained","Don't Know"))

hadhpva_codebook <-
  tibble(HPVACHAD = c(00,10,11,20,97,98,99),
         hadhpva = c("NIU","No","Doc Refused","Yes","Refused","Not Ascertained","Don't Know"))

heardhpva_codebook <-
  tibble(HPVHEAR = c(0,1,2,7,8,9),
         heardhpva = c("NIU","No","Yes","Refused","Not Ascertained","Don't Know"))

# Pooja

CHECKUP_codebook <- 
  tibble(CHECKUP = c(0,1,2,7,8,9), 
         checkup = c(NA, "No", "Yes", NA, NA, NA))

DENTINT_codebook <-
  tibble(DENTINT = c(00,10,20,21,22,23,30,31,32,40,41,42,43,44,45,50,60,61,62,63,90,07,98,99),
         dentint = c(rep(NA, 2), 
                           rep("6 months or less", 3),
                           rep("under a year", 4), 
                           rep("1 to 5 years", 6), 
                           rep("greater than 5 years", 5), 
                           rep(NA, 4)))

DOCVIS2W_codebook <- 
  tibble(DOCVIS2W = c(1,2,7,8,9), 
         docvis2w = c("No", "Yes", NA, NA, NA))

SAWGEN_codebook <- 
  tibble(SAWGEN = c(0,1,2,7,8,9), 
         sawgen = c(NA, "No", "Yes", NA, NA, NA))


# Karen

smokestatus_codebook <-
  tibble(SMOKESTATUS2 = c(0,10,11,12,13,20,30,40,90),
         smokestatus = c(NA, rep("Smoker", 5),"Non-Smoker", "Smoker", NA))

smokequit_codebook <-
  tibble(CSQTRYYR = c(0,1,2,7,8,9),
         smokequit = c(NA, "No", "Yes", NA, NA, NA))

timequit_codebook <-
  tibble(QUITYRS = c(0:99),
         timequit = c(0:95, rep(NA, 4)))

# Leah

vaccination_codebook <-
  tibble(VACFLU12M = c(0,1,2,3,7,8,9),
         vaccination = c(NA,"No", rep("Yes", 2), rep(NA, 3)))

# Devin

relate_codebook <-
  tibble(RELATE = c(10, 20, 21, 22, 30, 40, 41, 43, 44, 50, 60, 70, 71, 72, 73,
                    74, 75, 76, 80, 81, 82, 83, 84, 85, 90, 96:99),
         relate = c("Householder", 
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
                          "Other relative 3 (no named category)",
                          "Nonrelative",
                          "Housemate/roommate",
                          "Roomer/boarder",
                          "Legal guardian",
                          "Ward",
                          "Other nonrelative",
                          rep(NA,5)))

secondjob_codebook <-
  tibble(SECONDJOB = c(0, 1, 2, 7: 9),
         secondjob = c(NA, "No, don't have more than 1 job",
                             "Yes, have more than 1 job", rep(NA,3)))

hinoager_codebook <-
  tibble(HINOAGER = c(0, 1, 2, 9),
         hinoager = c(NA, "No","Yes", NA))


hinofamr_codebook <-
  tibble(HINOFAMR = c(0, 1, 2, 7:9),
         hinofamr = c(NA, "No","Yes", rep(NA,3)))

parenthere_codebook <-
  tibble(PARENTHERE = c(0, 10, 11, 12, 20, 30, 98, 99),
         parenthere = c(NA, "One parent", "Mother, no father",
                              "Father, no mother", "Mother and father",
                              "Neither mother nor father",
                              rep(NA,2)))
famstruc1f_codebook <-
  tibble(FAMSTRUC1F = c(11, 12, 21, 22, 23, 31, 32, 33, 41, 42, 43, 44, 45, 99),
         famstruc1f = c("Living alone", "Living with roommate",
                              "Married couple", "Unmarried couple", 
                              "All other adult only families",
                              "Mother and biological or nonbiological children only",
                              "Father and biological or nonbiological children only",
                              "All other single-adult and children families",
                              "Married or unmarried parents with biological/adoptive children only",
                              "Parent (biological or adoptive), step parent, and child(ren) only",
                              "Parent (biological or adoptive), cohabiting partner, and child(ren) only",
                              "At least 1 (biological or adoptive) parent and 1+ child(ren), and other related adults", 
                              "Other related and/or unrelated adults, 1+ child(ren), no biological or adoptive parent(s)", 
                              NA))
hourswrk_codebook <-
  tibble(HOURSWRK = c(0:95, 97:99),
         hourswrk = c(0:95, rep(NA,3)))

# Gina

delaycost_codebook <-
  tibble(DELAYCOST = c(1,2,0,7,8,9 ),
         delaycost = c("No","Yes",NA,NA,NA,NA))

# Merging in Codebooks and dropping original variables.

df <-
  df %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(age_codebook, by = "AGE") %>%
  left_join(educ_codebook, by = "EDUC") %>%
  left_join(marstat_codebook, by = "MARSTAT") %>%
  left_join(race_codebook, by = "RACEA") %>%
  left_join(hispanic_codebook, by = "HISPETH") %>%
  left_join(empstat_codebook, by = "EMPSTAT") %>%
  left_join(income_codebook, by = "INCFAM97ON2") %>%
  left_join(bcpill_codebook, by = "BCPILNOW") %>%
  left_join(hadhpva_codebook, by = "HPVACHAD") %>%
  left_join(heardhpva_codebook, by = "HPVHEAR") %>%
  left_join(CHECKUP_codebook, by = "CHECKUP") %>%
  left_join(DENTINT_codebook, by = "DENTINT") %>%
  left_join(DOCVIS2W_codebook, by = "DOCVIS2W") %>%
  left_join(SAWGEN_codebook, by = "SAWGEN") %>%
  left_join(smokestatus_codebook, by = "SMOKESTATUS2") %>%
  left_join(smokequit_codebook, by = "CSQTRYYR") %>%
  left_join(timequit_codebook, by = "QUITYRS") %>%
  left_join(vaccination_codebook, by = "VACFLU12M") %>%
  left_join(relate_codebook, by = "RELATE") %>%
  left_join(hinoager_codebook, by = "HINOAGER") %>%
  left_join(hinofamr_codebook, by = "HINOFAMR") %>%
  left_join(famstruc1f_codebook, by = "FAMSTRUC1F") %>%
  left_join(secondjob_codebook, by = "SECONDJOB") %>%
  left_join(hourswrk_codebook, by = "HOURSWRK") %>%
  left_join(delaycost_codebook, by = "DELAYCOST") %>%
  select(-SEX, -AGE, -EDUC, -MARSTAT, -RACEA, -HISPETH, -EMPSTAT, -INCFAM97ON2, -BCPILNOW, -HPVACHAD,
         -HPVHEAR, -CHECKUP, -DENTINT, -DOCVIS2W, -SAWGEN, -SMOKESTATUS2, -CSQTRYYR, -QUITYRS, 
         -VACFLU12M, -RELATE, -HINOAGER, -HINOFAMR, -FAMSTRUC1F, -SECONDJOB, -HOURSWRK, -DELAYCOST)

save(df, file = file.path(ddir, "clean_health_cohort_data.Rda"))

