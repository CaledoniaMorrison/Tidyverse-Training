# housekeeping ----

# libraries
library(tidyverse)
library(lubridate)
library(janitor)

# data
covid_trends <- readRDS("Data/COVID19 Trends.rds")

# Q1 ----
# How many cumulative covid cases were there in NHS Highland on the 28th of April 2021?

covid_trends %>%
  
  # filter for the date and NHS Highland
  filter(Date == "20210428", HBName  == "NHS Highland") %>%
  
  # select the appropriate variables
  select(Date,HBName, CumulativePositive)


# Q2 ----
# How many positive cases were reported for NHS Highland on 28/04/2021?
# (hint: filter as in Q1 and use the DailyPositive variable)

# Q3 ----
# On the 28th of April 2021, which Health Board reported the highest crude rate of positive cases?
# (hint: you can use %>% arrange(desc(VARIABLE)) to sort by a VARIABLE in descending order)

# Q4 ----
# Which day saw the highest number of positive cases in Scotland?