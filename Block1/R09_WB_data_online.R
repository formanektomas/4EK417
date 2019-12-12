#### World Bank's World Development Indicators  ####
#
## World Bank Data website
## http://data.worldbank.org/data-catalog/world-development-indicators 
## http://data.worldbank.org/ 
#
## Country codes:
## http://wits.worldbank.org/WITS/WITS/WITSHELP/Content/Codes/Country_Codes.htm
#
## Indicators' (variable) codes:
## http://data.worldbank.org/indicator/all
## ... Search the web page for the indicator, then use "Metadata" tab
## or
## Use the WDIsearch() function of the {WDI} package
#  
## Error codes:
## http://data.worldbank.org/node/211
#
#
#
#
#
rm(list=ls())
#
library(WDI) # install.packages("WDI")
library(ggplot2) # install.packages("ggplot2")
library(countrycode) # install.packages("countrycode")
#
#
#
#
### Search World Bank Data for GDP per capita in the USA, Canada & Mexico, constant prices
#
#
# Step 1: find suitable variable
#
?WDIsearch
gdp.datasets <- WDIsearch('gdp')
dim(gdp.datasets)
View(gdp.datasets)
#
# WDIsearch uses grep syntax {type ?grep into R concole} and is NOT case-sensitive
#
?regex # Regular Expressions as used in R
# ".*"
# We shall use the ".*" metacharacter combination:
# The "." matches/substitutes any character, "*" allows the preceding character 
# (dot) to be repeated 0 or more times
# So, if we want to search for something like: 
# "GDP per capita in constant prices, we may use e.g. the following:
#
WDIsearch('gdp.*capita.*constant')
# 
# Say, we decide to use:
# "NY.GDP.PCAP.PP.KD" "GDP per capita, PPP (constant 2005 international $)"
#
#
# Step 2: check the country code, if necessary:
#
?codelist
str(codelist,list.len=15)
?countrycode
countrycode("USA",'iso3c', 'genc2c')
countrycode("Canada", "country.name", 'genc2c')
countrycode("Mexico", "country.name", 'genc2c')
#
#
# Step 3: retrieve the data
#
?WDI 
# We create a data.frame "dat" for subsequent analysis.
# .. year chosen ad-hoc
dat <- WDI(indicator='NY.GDP.PCAP.KD', 
           country=c('MX','CA','US'), 
           start=1960, end=2015)
head(dat)
tail(dat)
write.csv(dat, "datasets/mcu_gdp.csv", row.names = F) # Writes the data into Working directory
#
# Plot the data using ggplot2:
ggplot(dat, aes(x = year, y = NY.GDP.PCAP.KD, color=country)) + 
  geom_line() + 
  xlab('Year') + 
  ylab('GDP per capita, PPP (constant 2005 international $)')
#
#
#
#### Merging data frames - adding one country to the panel (new rows) ###
#
#
# Say, we want to include Brazil in our analysis 
# and append Brazilian 'NY.GDP.PCAP.KD' data for the years 1960 - 2012
# to the "dat" data.frame
#
dat.BR <- WDI(indicator='NY.GDP.PCAP.KD', 
           country="BR", 
           start=1960, end=2015)
head(dat.BR)
tail(dat.BR)
#
# Now, lets merge "dat" and "dat.BR" into "newData"
?rbind
# to use rbind, we have to be sure that column structre in DFs is identical
GDP.Data <- rbind(dat, dat.BR) 
fix(GDP.Data)
#
# Plot new data.frame
ggplot(GDP.Data, aes(x = year, y = NY.GDP.PCAP.KD, color=country)) + 
  geom_line() + 
  xlab('Year') +
  ylab('GDP per capita, PPP (constant 2005 international $)')
#
#
#
#
#### Merging data frames - adding new variable to the panel (new column) ###
#
#
# Say, we want to include population (millions) volume for all countries 
# in the newData data.frame for the years 1960 - 2012
# 
WDIsearch('population')
WDIsearch('.*population.*total')
WDIsearch('.*population..total')
#
dat.POP <- WDI(indicator="SP.POP.TOTL", 
              country=c('MX','CA','US','BR'), 
              start=1960, end=2012)
#
summary(dat.POP) # number of inhabitants, NOT in millions, or thousands...!
head(dat.POP)
# Lets tranform the data, we want population in millions:
# Lets round to 3 dec. numbers - information saved up to thousands of people
dat.POP$SP.POP.TOTL <- round(dat.POP$SP.POP.TOTL/1000000, 3)
# Change the corresponding variable name accordingly
names(dat.POP) <- c("iso2c", "country", "POP.in.Millions", "year")
#
head(dat.POP)
names(dat.POP)
#
#
# Plot population data
ggplot(dat.POP, aes(x = year, y = POP.in.Millions, color=country)) + 
  geom_line() + 
  xlab('Year') + 
  ylab('Total population in millions')
#
#
#
### We want to merge data.frames "newData" (GDP/capita for BR, CA, MX, US)
### and "dat.POP" - information on population for the same countries
### .. Please note that countries and years are identical in both panels
### .. non-perfect overlap would result in NA values where data is missing.
#
#
head(dat.POP)  # Rows in data frames are NOT aligned!
head(GDP.Data)
#
#
tail(dat.POP)  
tail(GDP.Data)  
#
# Rows in data frames are not alligned.
# we cannot use cbind() at this point. 
# order() needs to be applied on both data frames before using cbind().
# A more convenient approach: merge() function or tidyverse() functions
#
?merge
merged.Data <- merge(GDP.Data, dat.POP, by = c("iso2c", "year"))
View(merged.Data)
# How can we adjust code on line 173 to fix the "country.x" and "country.y" entries ?
#
# Use dplyr()
require(dplyr)
Merged.DF <- left_join(GDP.Data, dat.POP, by = c("iso2c", "year", "country"))
#
#
#
##
## Assignment 1
## a) Use the online WDI database to retrieve the following data:
##    - Unemployment (you can  use total or relative values)
##    - data for some 3 - 5 countries (e.g.: the V4 group: CZ,SK,PL,HU)
##    - data for a6 least 10 years (say, 2006 to 20115).
##      
##
## b) Plot the data using ggplot2
##    (choose a convenient plot type)
##
#
#
#
#
#
#
#####################################################################
# Example 2 
# WDI database, Fertility rates & the use of metadata
rm(list=ls())
#
#
# Use the WDIsearch function to get a list of fertility rate indicators
indicatorMetaData <- WDIsearch("Fertility rate", field="name", short=FALSE)
# This serves for data source documentation & reproducibility
View(indicatorMetaData) 
#
#
# Define a list of countries for which to download the data
countries <- c("United States", "Britain", "Sweden", "Japan")
#
# Convert the country names to iso2c format used in the World Bank data
iso2cNames <- countrycode(countries, "country.name", "iso2c")
#
# Download data for each country, for selected fertility rate indicators, 
# for the years 2001 to 2011
wdiData <- WDI(iso2cNames, "SP.DYN.TFRT.IN", start=1980, end=2011)
View(wdiData)
#
#
# Create trend charts for the selected indicator
plot1 <- ggplot(wdiData, aes(x=year, y=SP.DYN.TFRT.IN, color=country)) +
              geom_line(size=1) +
              ylab('Fertility') +
              ggtitle("Fertility rate")
plot1 # shows the graph
?ggsave
ggsave("datasets/plot1.jpg", plot1) # save graph to disk
ggsave("datasets/plot1.pdf", plot1)
#
#