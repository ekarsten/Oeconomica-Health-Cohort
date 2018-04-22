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

