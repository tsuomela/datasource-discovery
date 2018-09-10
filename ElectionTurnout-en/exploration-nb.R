# 0. load libraries

library(tidyverse)
library(lubridate)

# 1. import data

elections <- read_csv("VoterTurnoutData-1980-2014.csv")
glimpse(elections)
str(elections)

# 2. filter for 2014 and generate some quick summaries

election.2014 <- elections %>%
  filter(Year == 2014 & State != "United States")

summary(election.2014)

# 3. exploratory graphs

p1 <- ggplot(election.2014,
       aes(y = Turnout_Rates_VAP_Highest_Office, x = State))
p1 + geom_point()

## let's change the scale on the x-axis to start at 0

p1 + geom_point() + expand_limits(y = 0) + coord_flip()

## or a bar chart
# deciding how to explore this led to changing the mapping of x and y. Which should be mapped to x?
# You can use coord_flip to alter this if the display is not working out.

p1 + geom_col() + coord_flip()

# can we sort this from largest to smallest turnout
# use forcats

election.2014 %>%
  ggplot(aes(x = fct_reorder(State, Turnout_Rates_VAP_Highest_Office), y = Turnout_Rates_VAP_Highest_Office)) +
  geom_col() +
  geom_vline(aes(xintercept = mean(Turnout_Rates_VAP_Highest_Office))) +
  coord_flip() +
  theme_minimal()
  
# let's color the lines based on whether they are greater or smaller than the mean

election.2014 <- election.2014 %>%
  mutate(Above_Average_VAP_Turnout 
         = ifelse(Turnout_Rates_VAP_Highest_Office > mean(Turnout_Rates_VAP_Highest_Office), T, F))

election.2014 %>%
  ggplot(aes(x = fct_reorder(State, Turnout_Rates_VAP_Highest_Office), 
             y = Turnout_Rates_VAP_Highest_Office,
             fill = Above_Average_VAP_Turnout)) +
  geom_col() +
  geom_vline(aes(xintercept = mean(Turnout_Rates_VAP_Highest_Office))) + # this calculation is incorrect
  coord_flip() +
  theme_minimal()

mean(election.2014$Turnout_Rates_VAP_Highest_Office)

election.2014 %>%
  select(State, Turnout_Rates_VAP_Highest_Office) %>%
  filter(Turnout_Rates_VAP_Highest_Office > 35) %>%
  arrange(desc(Turnout_Rates_VAP_Highest_Office)) %>%
  View()
