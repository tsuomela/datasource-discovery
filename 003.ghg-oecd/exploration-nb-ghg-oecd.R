# Data Source: OECD
# Web URL : https://stats.oecd.org/Index.aspx?DataSetCode=AIR_GHG
# 
# Learning Objectives:
#   1. using the rsdmx package to load data and metadata
#   2. exploring the data as imported into R
#   

# 0. Libraries and Setup
install.packages("rsdmx")
library(rsdmx)
library(tidyverse)

# Quickstart vignette for rsdmx : https://cran.r-project.org/web/packages/rsdmx/vignettes/quickstart.html
# myUrl <- ...
# dataset <- readSDMX(myUrl)
# stats <- as.data.frame(dataset)

# 1. Load Data from Remote Web URL

oecdURL <- "https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/AIR_GHG/AUS+AUT+BEL+CAN+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LVA+LTU+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA+OECDE+OECD+NMEC+BRA+CHN+COL+CRI+IND+IDN+RUS+ZAF.GHG+CO2+CH4+N2O+HFC_PFC+HFC+PFC+SF6+NF3.TOTAL+ENER+ENER_IND+ENER_MANUF+ENER_TRANS+ENER_OSECT+ENER_OTH+ENER_FU+ENER_CO2+IND_PROC+AGR+WAS+OTH+LULUCF+TOTAL_LULU+INTENS+GHG_CAP+GHG_GDP+INDEX_2000+INDEX_1990/all?startTime=1990&endTime=2016"
oecd.sdmx <- readSDMX(oecdURL)
glimpse(oecd.sdmx)
ghg.oecd <- as.data.frame(oecd.sdmx)
glimpse(ghg.oecd)
