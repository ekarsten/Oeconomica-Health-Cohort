#===============
# Data Cleaning 
#===============

# This snippet of code is a little loop that makes my code work on your computer
root <- getwd()
while(basename(root) != "Oeconomica-Health-Cohort") {
  root <- dirname(root)
}

library(dplyr)

df <- read.csv(file.path(ddir, "health_cohort_data.csv"))


#------------------------------
# Codebooks
#------------------------------

# Olivia

bcpill_codebook <-
  tibble(BCPILNOW = c(0,1,2,7,8,9),
         bcpill_clean = c("NIU","No","Yes","Refused","Not Ascertained","Don't Know"))

hadhpva_codebook <-
  tibble(HPVACHAD = c(00,10,11,20,97,98,99),
         hadhpva_clean = c("NIU","No","Doc Refused","Yes","Refused","Not Ascertained","Don't Know"))

heardhpva_codebook <-
  tibble(HPVHEAR = c(0,1,2,7,8,9),
         heardhpva_clean = c("NIU","No","Yes","Refused","Not Ascertained","Don't Know"))

# Pooja

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


# Karen

smokestatus_codebook <-
  tibble(SMOKESTATUS2 = c(0,10,11,12,13,20,30,40,90),
         smokestatus_clean = c(NA, rep("Smoker", 5),"Non-Smoker", "Smoker", NA))

smokequit_codebook <-
  tibble(CSQTRYYR = c(0,1,2,7,8,9),
         smokequit_clean = c(NA, "No", "Yes", NA, NA, NA))

timequit_codebook <-
  tibble(QUITYRS = c(0:99),
         timequit_clean = c(0:95, rep(NA, 4)))

# Leah

vaccination_codebook <-
  tibble(VACFLU12M = c(0,1,2,3,7,8,9),
         vaccination_clean = c(NA,"No", rep("Yes", 2), rep(NA, 3)))

# Devin

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

secondjob_codebook <-
  tibble(SECONDJOB = c(0, 1, 2, 7, 8, 9),
         secondjob_clean = c("NIU", "No, don't have more than 1 job",
                             "Yes, have more than 1 job", "Unknown-refused",
                             "Unknown-not ascertained", "Unknown-don't know"))

hinoager_codebook <-
  tibble(HINOAGER = c(0, 1, 2, 9),
         hinoager_clean = c("NIU", "No","Yes", "Unknown"))


hinofamr_codebook <-
  tibble(HINOFAMR = c(0, 1, 2, 7, 8, 9),
         hinofamr_clean = c("NIU", "No","Yes", "Unknown - refused", 
                            "Unknown - not ascertained", 
                            "Unknown - don't know"))
parenthere_codebook <-
  tibble(PARENTHERE = c(0, 10, 11, 12, 20, 30, 98, 99),
         parenthere_clean = c("NIU", "One parent", "Mother, no father",
                              "Father, no mother", "Mother and father",
                              "Neither mother nor father",
                              "Unknown-not ascertained", 
                              "Unknown-don't know"))
famstruc1f_codebook <-
  tibble(FAMSTRUC1F = c(11, 12, 21, 22, 23, 31, 32, 33, 41, 42, 43, 44, 45, 99),
         famstruc1f_clean = c("Living alone", "Living with roommate",
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
                              "Unknown"))

# Gina

delaycost_codebook <-
  tibble(DELAYCOST = c(1,2,0,7,8,9 ),
         delaycost_clean = c("No","Yes",NA,NA,NA,NA))

#------------------------------
# Combining
#------------------------------

df_clean <-
  df %>%
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
  left_join(empstat_codebook, by = "EMPSTAT") %>%
  left_join(hinoager_codebook, by = "HINOAGER") %>%
  left_join(hinofamr_codebook, by = "HINOFAMR") %>%
  left_join(famstruc1f_codebook, by = "FAMSTRUC1F") %>%
  left_join(secondjob_codebook, by = "SECONDJOB")
