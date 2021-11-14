# 03 - Plotting Data in R with ggplot

# housekeeping ----

# libraries
library(tidyverse) 
library(lubridate)

# data
hb_2020 <- readRDS("Data/2020 COVID19 Tests by Health Board.rds")
monthly_tests <- readRDS("Data/Monthly COVID19 tests in Scotland.rds")

# Plot 1 - Percent Positive Tests by Health Board (Barplot)

scotland_total <- hb_2020 %>% 
  filter(hb_name == "Scotland") %>% 
  pull(percent_positive)

hb_2020 <- hb_2020 %>%
  filter(hb_name != "Scotland") %>%
  arrange(desc(percent_positive)) 

ggplot(hb_2020, aes(x = factor(hb_name, levels = hb_name), y = percent_positive)) +
  
  geom_bar(stat = "identity", position = position_dodge(), fill = "darkgreen") +
  geom_line(aes(y = scotland_total, x = hb_name, group = 1), colour = "red") +
  
  labs(x = "Health Board Name", y = "Percent Positive", 
       title = "Positive COVID19 Tests as a Percent of All Tests in Scotland, 2020, by Health Board") +
  
  # Look of the plot
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  
  scale_y_continuous(labels = function(x){paste0(x, ".0%")})

# Plot 2 - Percent Positive Tests in Scotland by Month (Line Chart)

monthly_tests <- monthly_tests %>%
  mutate(month_year = my(paste0(month, year)))

ggplot(monthly_tests, aes(x = month_year, y = percent_positive, group =1 )) +
  geom_line(colour = "darkblue") +
  geom_point(colour = "darkblue") +
  
  labs(x = "Month", y = "Percent Positive", 
       title = "Monthly Positive COVID19 Tests as a Percent of All Tests in Scotland") +
  
  # Look of the plot
  theme_minimal() +
  scale_y_continuous(labels = function(x){paste0(x, ".0%")}) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_x_date(date_breaks = "3 months", 
               labels = function(x){paste0(month(x, label = TRUE, abbr = TRUE),
                                           "-", year(x))})
