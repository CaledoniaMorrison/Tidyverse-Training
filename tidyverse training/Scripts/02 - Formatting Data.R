# 02 - Parsing and Formatting Data in R
# This script will detail the following methods:
#   Working with and calculating numeric, character and date variables
#   Data filtering
#   Aggregation
#   Reshaping data using pivot

# Extra Resources: https://www.rstudio.com/resources/cheatsheets/
#   Recommended: "Data transformation with dplyr cheatsheet"

# housekeeping ----

# libraries
library(tidyverse)
library(lubridate)
library(janitor)

# data
covid_trends <- readRDS("Data/COVID19 Trends.rds")

# Pipe opperators (%>%) ----

# pipe operators are part of the tidyverse syntax
# a function, f(x,y), can be written as x %>% f(y);
# a function, g(x), can be written as x %>% g()
# for example:

number_vector <- c(1,2,3,4)  # assign an object to number_vector 

# calculate the sum of all the numbers in the object
sum(number_vector)
number_vector %>% sum()

# calculate the mean
mean(number_vector)
number_vector %>% mean() 


# data structures ----
# We call a dataset loaded through the tidyverse a 'tibble'
covid_trends <- as_tibble(covid_trends)
covid_trends # View data in console
View(covid_trends) # View data in new pane

# variable names
names(covid_trends)
covid_trends <- covid_trends %>% clean_names()
names(covid_trends)

# select variables
covid_trends %>% 
  select(date, hb_name, positive_tests)

# Calculating Variables with mutate() ----

# numeric
covid_trends <- covid_trends %>%
  mutate(percent_positive_tests1 = 100*positive_tests/total_tests) %>%
  mutate(percent_positive_tests2 = if_else(total_tests == 0, 0, 100*positive_tests/total_tests))

View(covid_trends)

# character
covid_trends %>%
  mutate(health_board =  gsub("NHS ", "", hb_name)) %>%
  select(health_board, hb_name)

# date
covid_trends %>% select(date) # view just the date variable
 
covid_trends <- covid_trends %>%
  
  # convert from numeric to date
  mutate(date = ymd(date)) %>%
  
  # calculate the month and year
  mutate(month = month(date, label = TRUE,abbr = FALSE),
         year = year(date))

covid_trends

# filtering and aggregation ----

# how many positive tests in Scotland in 2020
covid_trends %>%
  
  # filter for Scotland and the year 2020
  filter(hb_name == "Scotland", year == 2020) %>%
  
  # aggregate by taking the sum of the positive tests variable
  summarise(total_positive = sum(positive_tests))

# how many positive and total tests per health board in 2020, calculate this as
# the percent positive
hb_2020 <- covid_trends %>%
  
  # filter for Scotland and the year 2020
  filter(year == 2020) %>%
  
  # group by the health board variable
  group_by(hb_name) %>%
  
  # calculate the sum
  summarise(total_tests = sum(total_tests),
            total_positive = sum(positive_tests)) %>%
  
  # ungroup the data
  ungroup() %>%
  
  # calculate the percent positive
  mutate(percent_positive = 100*total_positive/total_tests)

# how many positive tests as a percent of total tests in Scotland by month?
monthly_tests <- covid_trends %>%
  
  # filter for Scotland
  filter(hb_name == "Scotland") %>%
  
  # group by the month and year 
  group_by(month, year) %>%
  
  # take the sum of the test count variables
  summarise(positive_tests = sum(positive_tests),
            total_tests = sum(total_tests)) %>%
  
  # ungroup the data
  ungroup() %>%
  
  # calculate the percent positive
  mutate(percent_positive = 100*positive_tests/total_tests) %>%
  
  arrange(year, month)

monthly_tests

# reshaping data (pivot_wider(), pivot_longer) ----

# pivoting the data into wide format
hb_2020

hb_2020_wide <- hb_2020 %>% 
  select(hb_name, percent_positive) %>%
  pivot_wider(names_from = hb_name, values_from = percent_positive)

View(hb_2020_wide)

# pivot to long format
hb_2020_wide %>% 
  
  # pivot to long format
  pivot_longer(cols = 1:ncol(hb_2020_wide)) %>%
  
  # change the variable names
  rename(Health_Board = name, Percent_Positive = value)

# Merging Data ----

# create two datasets with one (or more) shared variable to merge together by
health_board_lookup <- covid_trends %>%
  select(HB, HBName) %>% distinct()

daily_positives <- covid_trends %>% 
  select(Date, HB, DailyPositive)

# view
health_board_lookup
daily_positives

# join function 
left_join(daily_positives,health_board_lookup, by = "HB")

# can also join using the pipe operator
daily_positives %>%
  left_join(health_board_lookup, by = "HB")

# see the data-transformation cheat sheet for more joining functions and
# when to use them

# save data ----
saveRDS(hb_2020, "Data/2020 COVID19 Tests by Health Board.rds")
saveRDS(monthly_tests, "Data/Monthly COVID19 tests in Scotland.rds")
