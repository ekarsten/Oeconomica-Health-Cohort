root <- getwd()
while(basename(root) != "Oeconomica-Health-Cohort") {
  root <- dirname(root)
}

source(file.path(root, "data.R"))
  
  library(dplyr)
  library(ggplot2)
  library(lubridate)
  library(knitr)
  library(purrr)
  library(tidyr)
  library(stringr)
  
  
load(file.path(ddir, "clean_health_cohort_data.rda"))

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

# Proportion of smokers (insurance vs. no insurance)
smokestatus_count <-
  df %>%
  group_by(YEAR, any_insurance) %>%
  summarize(N_Yes = sum(smokestatus == "Smoker", na.rm = TRUE),
            N_No = sum(smokestatus == "Non-Smoker", na.rm = TRUE),
            N_Total = n()) %>% 
  mutate(prop_yes = N_Yes/(N_Yes + N_No))

smokestatus_count %>%
  filter(!is.na(any_insurance)) %>%
  ggplot(aes(x=YEAR, y=prop_yes*100, color = any_insurance)) +
  geom_point() + geom_smooth(model = lm) +
  labs(x = "Year", y = "% Smokers") + scale_color_discrete(name = "Any Insurance") +
  theme(legend.position="bottom")


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

# Tried to quit smoking (insurance vs. no insurance)
smokequit_count <- 
  df %>%
  group_by(YEAR, any_insurance) %>%
  summarize(N_Yes = sum(smokequit == "Yes", na.rm = TRUE),
            N_No = sum(smokequit == "No", na.rm = TRUE),
            N_Total = n()) %>% 
  mutate(prop_yes = N_Yes/(N_Yes + N_No))

smokequit_count %>%
  filter(!is.na(any_insurance)) %>%
  ggplot(aes(x=YEAR, y=prop_yes*100, color = any_insurance)) +
  geom_point() + geom_smooth(model = lm) + 
  labs(x = "Year", y = "%") + scale_color_discrete(name = "Any Insurance") + 
  theme(legend.position="bottom")
