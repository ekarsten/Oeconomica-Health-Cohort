#====================================
# Data Analysis
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
library(ggplot2)
library(lfe)
library(stargazer)

load(file.path(ddir, "clean_health_cohort_data.Rda"))


#-----------------------------------
# Making A figure for proportion of smokers over time
#-----------------------------------

# Smoking Variables

# Proportion of Smokers
smokestatus_count <-
  df %>%
  group_by(YEAR) %>%
  summarize(N_Yes = sum(smokestatus == "Smoker", na.rm = TRUE),
            N_No = sum(smokestatus == "Non-Smoker", na.rm = TRUE),
            N_Total = n()) %>% 
  mutate(prop_yes = N_Yes/(N_Yes + N_No))

smokestatus_count %>%
  ggplot(aes(x=YEAR, y=prop_yes*100)) +
  geom_point() + geom_smooth(model = lm) + theme_bw() +
  labs(x = "Year", y = "% Smokers")

df %>%
  group_by(YEAR) %>%
  summarise(prop_vaccinated = sum(vaccination == "Yes", na.rm = T )/n()  ) %>%
  ggplot(aes(x = as.character(YEAR), y = prop_vaccinated)) +
  geom_point() +
  theme_bw() +
  labs(x = "Year",
       y = "Proportion Vaccinated")


df %>%
  group_by(YEAR) %>%
  summarise(prop_vaccinated = sum(vaccination == "Yes", na.rm = T )/n()  ) %>%
  ggplot(aes(x = as.character(YEAR), y = prop_vaccinated)) +
  geom_point() +
  theme_bw() +
  labs(x = "Year",
       y = "Proportion Vaccinated")

df %>%
  group_by(YEAR, sex, race) %>%
  summarise(prop_vaccinated = sum(vaccination == "Yes", na.rm = T )/n()  ) %>%
  ggplot(aes(x = as.character(YEAR), y = prop_vaccinated, color = sex)) +
  geom_point() +
  theme_bw() +
  facet_wrap(~race) +
  labs(x = "Year",
       y = "Proportion Vaccinated")


df %>%
  filter(!is.na(any_insurance)) %>%
  group_by(YEAR, sex, any_insurance) %>%
  summarise(prop_vaccinated = sum(vaccination == "Yes", na.rm = T )/n()  ) %>%
  ggplot(aes(x = as.character(YEAR), y = prop_vaccinated, color = any_insurance)) +
  geom_point() +
  theme_bw() +
  facet_wrap(~sex) +
  labs(x = "Year",
       y = "Proportion Vaccinated")

#-------------------------------------
# Figure about insurance over time
#-------------------------------------

df %>%
  group_by(YEAR, sex, race) %>%
  summarise(prop_insurance = sum(any_insurance == "Yes", na.rm = T)/sum(any_insurance %in% c("Yes", "No"), na.rm = T)) %>%
  ggplot(aes(x = YEAR, y = prop_insurance, color = sex)) +
  geom_point() +
  theme_bw() +
  facet_wrap(~race) +
  labs(x = "Year",
       y = "Proportion with Insurance")

df %>%
  group_by(YEAR) %>%
  summarise(p = sum(any_insurance == "Yes", na.rm = T)/sum(any_insurance %in% c("Yes", "No"), na.rm = T),
            n =  sum(any_insurance %in% c("Yes", "No"), na.rm = T)  ) %>%
  mutate(error = 1.96 * sqrt(p*(1-p)/n )) %>%
  ggplot(aes(x = YEAR, y = p)) +
  geom_point() +
  geom_errorbar(aes(ymin = p-error, ymax = p+error), width = .1) +
  theme_bw() +
  labs(x = "Year",
       y = "Proportion with Insurance")

#-------------------------------------
# This is a super simple regression discontinuity framework fo rinsurance over time
#-------------------------------------

# First we have to create a dummy variable for before or after introduction of ACA:

df <-
  df %>%
  mutate(aca = YEAR >= 2011,
         zeroed_year = as.numeric(YEAR) - 2011,
         numeric_insurance = ifelse(any_insurance == "Yes", 1, 0),
         numeric_smokestatus = ifelse(smokestatus == "Smoker", 1, 0),
         numeric_aca = ifelse(aca == T, 1, 0))

# Now in the model below, we are trying to explain the time trends in insurance with
# A discontinuity at the affordable care act (so theere will be a pretrend and a postrend)
# We will also be controling for various other factors: race, hispanic ethnicity, age, sex, education

m1 <- felm(numeric_insurance ~ zeroed_year*numeric_aca | race + age + sex + educ + hispanic,
           data = df, weights = df$PERWEIGHT)

stargazer(m1, header = F, type = "text")

# OK, now let's proportion of smokers in this same framework

m2 <- felm(numeric_smokestatus ~ zeroed_year*numeric_aca | race + age + sex + educ + hispanic,
           data = df, weights = df$PERWEIGHT)

# Then we will throw insurance into the framework and see how that changes 

m3 <- felm(numeric_smokestatus ~ zeroed_year*numeric_aca*numeric_insurance | race + age + sex + educ + hispanic,
           data = df, weights = df$PERWEIGHT)

stargazer(m2,m3, header = F, type = "text")









# Tried to quit smoking
smokequit_count <- 
  df %>%
  group_by(YEAR) %>%
  summarize(N_Yes = sum(smokequit == "Yes", na.rm = TRUE),
            N_No = sum(smokequit == "No", na.rm = TRUE),
            N_Total = n()) %>% 
  mutate(prop_yes = N_Yes/(N_Yes + N_No))

smokequit_count %>%
  ggplot(aes(x=YEAR, y=prop_yes*100)) +
  geom_point() + geom_smooth(model = lm) + 
  labs(x = "Year", y = "%")
