# 0. load libraries

library(tidyverse)
library(lubridate)

# 1. import data

elections <- read_csv("data/VoterTurnoutData-1980-2014.csv")
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


# 4. let's at a time series in elections df

pa.elections <- elections %>%
  filter(State == "Pennsylvania")

ggplot(pa.elections,
    aes(x = Year, y = Turnout_Rates_VAP_Highest_Office)
  ) +
  geom_line()

# One thing to notice is the swing in turnout between presidential and off-year elections.
# 5. How can we filter to only have presidential cycles.

# Setup variables to contain the years we want.
pres.years <- c(1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008, 2012)
off.years <- c(1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010, 2014)

elections %>% # testing to see if the outputs make sense
  filter(Year %in% pres.years) %>%
  count(Year)

elections.pres <- elections %>%  # assigning to a data frame
  filter(Year %in% pres.years)

# Graph for a single state

elections.pres %>%
  filter(State == "Minnesota") %>%
  ggplot(
    aes(x = Year, y = Turnout_Rates_VAP_Highest_Office)) +
  geom_line()

# now let's put all of the states into the plot

elections.pres %>%
  ggplot(
    aes(x = Year, y = Turnout_Rates_VAP_Highest_Office, color = State)
  ) +
  geom_line()

# that graph is too busy, let's facet

elections.pres %>%
  ggplot(
    aes(x = Year, y = Turnout_Rates_VAP_Highest_Office)
  ) +
  geom_line() +
  facet_wrap(vars(State))

# let's sort by average turnout across the years

elections.pres %>%
  group_by(State) %>%
  summarise(Avg_Turnout = mean(Turnout_Rates_VAP_Highest_Office)) %>%
  arrange(desc(Avg_Turnout))

elections.pres %>%
  group_by(State) %>%
  mutate(Avg_Turnout = mean(Turnout_Rates_VAP_Highest_Office)) %>%
  View()

elections.pres <- elections.pres %>%
  group_by(State) %>%
  mutate(Avg_Turnout = mean(Turnout_Rates_VAP_Highest_Office))


# can we use fct_reorder in the facet

elections.pres %>%
  ggplot(
    aes(x = Year, y = Turnout_Rates_VAP_Highest_Office)
  ) +
  geom_line() +
  facet_wrap(vars(fct_reorder(State, Avg_Turnout)))