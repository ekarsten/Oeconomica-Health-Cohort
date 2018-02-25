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

weight_codebook <- 
  tibble(WEIGHT = c(0:999),
         weight_clean = c(NA,
                        1:499,
                        rep(NA, 500)
         )
  )


height_codebook <- 
  tibble(HEIGHT = c(0:99),
         height_clean = c(1:95, rep(NA,5)
         )
  )

slim_df <-
  df %>%
  select(AGE, SEX, EDUC, HEALTH, HEIGHT, WEIGHT) %>%
  left_join(height_codebook, by = "HEIGHT") %>%
  left_join(weight_codebook, by = "WEIGHT") %>%
  left_join(sex_codebook, by = "SEX") %>%
  left_join(educ_codebook, by = "EDUC") %>%
  mutate(BMI = weight_clean/height_clean)


#----------------------------------
# Basic ggplot plots
#----------------------------------

# Let's make a simple histogram of the age of our sample
# First we feed a dataset into ggplot with piping
# Next we tell ggplot what variables should map to which parameters of the plot
# Then we tell ggplot the geometry of the figure we would like it to create
# Finally, we specify other options about our plot, such as labels or the scale

## ggplot makes really nice pretty plots!!
##piping sends stuff from one place to another, within ggplots, can use plus or minus signs.
##geom makes it a 
slim_df %>%
  ggplot(aes(x = AGE)) +
  geom_histogram(binwidth = 1) +
  labs(title = "Histogram of Age in NHIS survey sample")

# Now let's do something fancy and estimate age density functions by gender
##Not surprising that sampled more older women than older men, since women live longer.
##Not surprising lots of kids bc survey lots of households
slim_df %>%
  ggplot(aes(x = AGE, fill = sex_clean)) +
  geom_density(alpha = .6) +
  labs(title = "Density of Age by Gender")

# I couldn't think of a useful scatter plot, but the geometry for that is geom_point()
  
# Now it's your turn to write some code that makes a beautiful plot that impresses me
# Be sure to use point geometry in one plot and histogram geometry in another


#--------------------------------
# Faceting with ggplot
#--------------------------------

# Oftentimes, we are attempting to render a complex relationship between a variety
# of different variables and it becomes important to avoid clutter.

# Below I will compare gender and education differences in the histograms of BMI in
# our sample using a technique called faceting:
slim_df %>%
  ggplot(aes(educ_clean, fill = as.character(HEALTH))) +
  #proportion of people in diff categories of education 
  #and gender that report a health
  geom_bar(position = "fill") + 
  #fills the thing to the very top, easier to make relative comparisons 
  #between the education columsn. Try without this bit only empty parenteses
  facet_grid(sex_clean ~ .) +
  #  facet_grid(.~ sex_clean ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +#tilts the labesl at 45 degree angle so don't get crunched
  labs(title = "Proportion reporting each health level by education and gender",
       y = "Proportion",
       x = "Education Level",
       fill = "Health Level") #all the titles


# Now you make some awesome faceted plots below!!

slim_df %>%
  ggplot(aes(AGE, fill = as.character(HEALTH))) +
  geom_bar(position = "fill") + 
  facet_grid(sex_clean ~ .) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Proportion reporting each health level by age and gender",
       y = "Proportion",
       x = "Age",
       fill = "Health Level")







slim_df %>%
  ggplot(aes(x = HEIGHT)) +
  geom_histogram(binwidth = 1) +
  labs(title = "Histogram of HEIGHT in NHIS survey sample")
slim_df %>%
  ggplot(aes(x = WEIGHT)) +
  geom_histogram(binwidth = 1) +
  labs(title = "Histogram of WEIGHT in NHIS survey sample")

slim_df %>%
  ggplot(aes(BMI, fill = as.character(HEALTH))) +
  geom_bar(position = "fill") + 
  facet_grid(sex_clean ~ .) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Proportion reporting each Health level by BMI and gender",
       y = "Proportion",
       x = "BMI Level",
       fill = "Health Level")





