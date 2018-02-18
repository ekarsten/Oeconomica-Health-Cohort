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
df <- read.csv(file.path(ddir, "nhis_00001.csv.gz"))


#A little bit of data cleaning before we begin
sex_codebook <-
  tibble(SEX = c(1,2),
         sex_clean = c("Male","Female"))

educ_codebook <- 
  tibble(EDUC = c(0:22, 97:99),
         educ_clean = c(rep("No Degree", 14),
                        rep("HS Diploma",2),
                        rep("Some College", 3),
                        rep("College Degree", 4),
                        rep(NA, 3)
                        )
         )

slim_df <-
  df %>%
  select(AGE, SEX, EDUC, HEALTH, HEIGHT, WEIGHT) %>%
  mutate(BMI = WEIGHT/HEIGHT) %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(educ_codebook, by = "EDUC")


#----------------------------------
# Basic ggplot plots
#----------------------------------

# Let's make a simple histogram of the age of our sample
# First we feed a dataset into ggplot with piping
# Next we tell ggplot what variables should map to which parameters of the plot
# Then we tell ggplot the geometry of the figure we would like it to create
# Finally, we specify other options about our plot, such as labels or the scale

slim_df %>%
  ggplot(aes(x = AGE)) +
  geom_histogram(binwidth = 1) +
  labs(title = "Histogram of Age in NHIS survey sample")

# Now let's do something fancy and estimate age density functions by gender

slim_df %>%
  ggplot(aes(x = AGE, fill = sex_clean)) +
  geom_density(alpha = .6) +
  labs(title = "Density of Age by Gender")

# I couldn't think of a useful scatter plot, but the geometry for that is geom_point()
  
# Now it's your turn to write some code that makes a beautiful plot that impresses me
# Be sure to use point geometry in one plot and histogram geometry in another

sex_codebook <-
  tibble(SEX = c(1,2),
         sex_clean = c("Male","Female"))

age_codebook <- 
  tibble(AGE = c(18:85),
         age_clean = c(rep("20s", 12),
                        rep("30s", 10),
                        rep("40s", 10),
                        rep("50s", 10),
                        rep("60s", 10),
                        rep("70s", 10),
                        rep("80s", 6)
         )
  )

sleep_codebook <- 
  tibble(HRSLEEP = c(01:15),
         sleep_clean = c(rep("5<", 5),
                       rep("5-10", 5),
                       rep("10-15", 5)
         )
  )


new_df <- 
  df %>%
  select(AGE, SEX, EDUC, HEALTH, HRSLEEP) %>%
  filter(HRSLEEP >= 1,
         HRSLEEP < 24) %>%
  mutate(life = AGE/HRSLEEP) %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(educ_codebook, by = "EDUC") %>%
  left_join(age_codebook, by = "AGE") %>%
  left_join(sleep_codebook, by = "HRSLEEP") 


new_df %>%
  ggplot(aes(x = HRSLEEP)) +
  geom_histogram(binwidth = 1) +
  labs(title = "Histogram of Sleep in NHIS survey sample")

new_df %>%
  ggplot(aes(x = HRSLEEP, fill = sex_clean)) +
  geom_density(alpha = .6) +
  labs(title = "Density of Sleep by Gender")

new_df %>%
  filter(age_clean %in% c("20s","80s")) %>%
  ggplot(aes(x = HRSLEEP, fill = age_clean)) +
  geom_density(alpha = .6) +
  labs(title = "Density of Sleep by Age")

#--------------------------------
# Faceting with ggplot
#--------------------------------

# Oftentimes, we are attempting to render a complex relationship between a variety
# of different variables and it becomes important to avoid clutter.

# Below I will compare gender and education differences in the histograms of BMI in
# our sample using a technique called faceting:

slim_df %>%
  ggplot(aes(educ_clean, fill = as.character(HEALTH))) +
  geom_bar(position = "fill") +
  facet_grid(sex_clean ~ .) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each health level by education and gender",
       y = "Proportion",
       x = "Education Level",
       fill = "Health Level")

#dot means nothing. sex_clean is vertical, tilda is to seperate vertical form horizontal
#angle is for labels on plot
#count is wrong since those a proportions, so label it as prop

# Now you make some awesome faceted plots below!!

new_df %>%
  ggplot(aes(age_clean, fill = as.character(sleep_clean))) +
  geom_bar(position = "fill") +
  facet_grid(sex_clean ~ .) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each sleep level by Age and gender",
       y = "Proportion",
       x = "Age",
       fill = "Sleep")

new_df %>%
  ggplot(aes(age_clean, fill = as.character(sleep_clean))) +
  geom_crossbar(position = "fill") +
  facet_grid(sex_clean ~ .) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each sleep level by Age and gender",
       y = "Proportion",
       x = "Age",
       fill = "Sleep")
