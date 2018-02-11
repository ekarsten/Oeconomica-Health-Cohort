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


#----------------------------------
# making new variables using mutate
#----------------------------------

# our dataframe, df, has a ton of different variables, the following code just
# selects a few variables of interest to look at: Age, Sex, Education, and Health
# the code below uses something called piping %>% which puts the output of the
# last line into the input of the next:

slim_df <-
  df %>%
  select(AGE, SEX, EDUC, HEALTH, HEIGHT, WEIGHT)

# Now we want to create a new variable for health divided by age, because why not
# and another for weight divided by height (this isn't technically BMI, but it's
# a scale factor off, so it doesnt' matter)

df_new_vars <-
  slim_df %>%
  mutate(BMI = WEIGHT/HEIGHT,
         discounted_health = HEALTH/AGE)
  
# Now go find some interesting variables in the dataset and make some new variables
# using mutate

df_my_var <-
  df %>%
  mutate(quality = AGE/HRSLEEP,
         quantity = SEX/EDUC)


#--------------------------------
# Making evan more exciting tables using summarise
#--------------------------------

# Sometimes we want to change the way we are looking at information about data,
# So what we do is we break the data into groups and summarize by group.

# Here I will make a table that counts the number of people who rate their health
# in each category

slim_df %>%
  group_by(HEALTH) %>%
  summarise(number = n())


# Now I will do something a little more fun: doing the same counts broken down by gender

slim_df %>%
  group_by(SEX, HEALTH) %>%
  summarise(number = n())

# That table was a little hard to read, so let's spread it out into a wide table:

slim_df %>%
  group_by(SEX, HEALTH) %>%
  summarise(number = n()) %>%
  spread(key = SEX, value = number)

# Now I will group by age and summarize the mean rating of health for each age

slim_df %>%
  group_by(AGE) %>%
  summarise(AVG_HEALTH = mean(HEALTH))

# For a sneak peek into next week's tutorial, let's make a figure out of this!

slim_df %>%
  group_by(AGE) %>%
  summarise(AVG_HEALTH = mean(HEALTH)) %>%
  ggplot(aes(x = AGE, y = AVG_HEALTH)) +
  geom_point()

# That is somewhat surprising. Let's see what the raw data looks like:

slim_df %>%
  ggplot(aes(x = AGE, y = HEALTH)) +
  geom_jitter() +
  geom_smooth()


# Please use the space below to write some code to make some cool summary tables

# new_df <- 
#   df %>%
#   select(AGE, SEX, EDUC, HEALTH, HRSLEEP)

new_df <- 
  subset(df, HRSLEEP >= 01 | HRSLEEP < 24, 
                            select=c(AGE, SEX, EDUC, HEALTH))

df_my_var <-
  new_df %>%
  mutate(life = AGE/HRSLEEP) 

new_df %>%
  group_by(AGE , HRSLEEP) %>%
  summarise(number = n()) %>%
  spread(key = AGE, value = number)

new_df %>%
  group_by(AGE) %>%
  summarise(AVG_HRSLEEP = mean(HRSLEEP)) %>%
  ggplot(aes(x = AGE, y = AVG_HRSLEEP)) +
  geom_point()





