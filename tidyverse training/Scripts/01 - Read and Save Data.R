# 01 - Reading and Saving Data from R 
# This script will detail how the tidyverse and other packages can be used to 
# load and save data of various file types

# housekeeping ----

# libraries
library(tidyverse)
library(lubridate)
library(janitor)
library(haven)
library(readxl)
library(writexl)

# url to data files
covid_trends_url <- paste0("https://www.opendata.nhs.scot/dataset/",
                           "b318bddf-a4dc-4262-971f-0ba329e09b87/",
                           "resource/2dd8534b-0a6f-4744-9253-9565d62f96c2/",
                           "download/trend_hb_20211113.csv")

# Reading in Data ----

# 00 - From Open Data (url for .csv file)
covid_trends <- read_csv(covid_trends_url)

# 01 - CSV file (.csv)
covid_trends <- read_csv("Data/COVID19 Trends.csv")

# 02 - Excel file (.xlsx)
covid_trends <- read_xlsx("Data/COVID19 Trends.xlsx")

# 03 - SPSS file (.sav)
covid_trends <- read_sav("Data/COVID19 Trends.sav")

# 04 - RDS file (.rds)
covid_trends <- readRDS("Data/COVID19 Trends.rds")

# Saving Data ----

# 01 - CSV file (.csv)
write_csv(covid_trends, "Data/COVID19 Trends.csv")

# 02 - Excel file (.xlsx)
write_xlsx(covid_trends, "Data/COVID19 Trends.xlsx")

# 03 - SPSS file (.sav)
write_sav(covid_trends, "Data/COVID19 Trends.sav")

# 04 - RDS file (.rds)
saveRDS(covid_trends, "Data/COVID19 Trends.rds")
