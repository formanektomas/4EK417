#### Eurostat database and data manipulation using {reshape2} ####
#
#
#
#
#
############################################################
#################### {reshape2} package ####################
############################################################
#
#
#
#
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
rm(list = ls())
library(dplyr)
library(reshape2) # install.packages("reshape")
#
### Data files in melted and cast formats ###
#
#
## Melting & casting data: a simple example
#
mydata <- as.data.frame(matrix(c(1,1,2,2,2010,2015,2010,2015,5,6,17,18,11,12,23,24),ncol = 4))
colnames(mydata) <- c("ID", "Time", "DEBT", "GDP")
mydata$ID <- as.factor(c("CZ","CZ","AT","AT")) 
mydata # Original data.frame
#
## melt() command is analogous to pivot_longer() from {tidyr}
?melt.data.frame
# To melt a dataset, we restructure it into a format where each measured variable 
# (DEBT and GDP) is in its own row, along with all the variables needed 
# to uniquely identify it (ID and Time).
# .. hence, ID and Time are used as arguments to the melt() function
molten <- melt(mydata, id.vars = c("ID", "Time"))
molten
# alternative arguments used, same results:
molten <- melt(mydata, measure.vars = c("DEBT", "GDP"))
molten
#
#
#
## dcast() is similar to pivot_wider() from {tidyr}, offers additional functionality
?dcast # if casting into a data.frame, acast() for arrays, matrices, ...
# Melted data may be cast in different shapes
# The dcast() function starts with melted data and reshapes it using a formula:
# newdata <- cast(molten, formula, ...)
#
# .. the formula takes the form:
# ..rowvar1 + rowvar2 + ?  ~  colvar1 + colvar2 + ?
#
# .... rowvar1 + rowvar2 + ? set of variables that define the rows of new (cast) dataframe
# .... colvar1 + colvar2 + ? variables that define the columns of new dataframe
# 
#
# Example 1 - back to original dataframe
dcast(molten, ID + Time ~ variable)
mydata # original data for comparison
# 
# Example 2 - alternative ordering of the "row-defining" information
dcast(molten, Time + ID ~ variable)
#
# Example 3 - wide format: IDs in rows
dcast(molten, ID ~ variable + Time)
#
# Example 4 - wide format: data organized as time series
dcast(molten, Time ~ ID + variable)
dcast(molten, Time ~ variable + ID)
#
#
#
## Quick Assignment
rm(list=ls())
myData1 <- read.csv("datasets/CE_data.csv")
head(myData1,10)
tail(myData1,10)
summary(myData1[,1:3])
str(myData1)
#
## The dataset is in molten (long) format
## 2  observed variables: "GDP" and "UNEM"
## 3  countries: AT, CZ, DE
## 77 quarters: 1995Q1 to 2014Q1
## .... 2 x 3 x 77 = 462 rows of data
##
## Note: conversion of "time" to actual date format may be performed as follows
# library(zoo)
# myData.zoo <- zoo(DF.wide, order.by = as.yearqtr(myData1$time))
# .. because of repeated time entries, this is done after transforming the data to "wide" format 
#
#
#
# 
## 1] Use dcast() to produce a time-series object "table1", 
##    with time obs. in rows and VARIABLE.NAME_COUNTRY.ID in columns
#
#    i.e.
#
#    time   GDP_AT   GDP_CZ    GDP_DE    .....
# ----------------------------------------------
#  1995Q1  45115.4  10523.0  472917.2    .....
#  ......   ......   ......    ......   
#
table1 <- dcast(       )
head(table1)
#
## 2] Use dcast() to produce a time-series object "table1", 
##    with time obs. in rows and COUNTRY.ID_VARIABLE.NAME in columns
##    .. simply reverse column names from e.g. GDP_AT to AT_GDP
#
table2 <- dcast(       )
head(table2)
#
## 3] Use dcast() to produce a "panel.data" table
#    with heading as follows:
#
#     ID        time        GDP      UNEM
#  ----------------------------------------------
#     AT      1995Q1       ....      .....
#
#
#
panel.data <- dcast(       )
head(panel.data)
#
#
#
#
#
#
#
############################################################
#################### {eurostat} package ####################
############################################################
#
# Data from the Eurostat database are downloaded in a molten form 
# & often need to be reshaped using the dcast() function...
#
#
#
#
#### Example 1 - GDP data from Eurostat (CR, SR, AT)
#
# Retrieving Eurostat data using the {eurostat} package
rm(list=ls())
library("eurostat") # install.packages("eurostat")
?search_eurostat # grep syntax is used to search for particular character strings
GDP.series <- search_eurostat(".*GDP",fixed = F)
View(GDP.series) # GDP.series
# Say, we choose to work with "GDP and main components..." (annual data)
# ... the download may take a few moments....
?get_eurostat # note the "time_format" and other arguments
GDP <- get_eurostat("namq_10_gdp", time_format = "num")
head(as.data.frame(GDP, 50))
# Data are downloaded in a 'molten' form. 
# 
#
#### Using Eurostat data ####
#
# Download GDP and Unemployment data from Eurostat
# Filter "interesting" variables, countries, time period
# Join two datasets and convert to zoo (TS) format
# 
#
## Step 1 - GDP ## 
# Know your data
#
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=namq_10_gdp&lang=en
#
# In order to filter & reformat our data, we need to be aware 
# of the different variables contained within the dataset. 
#
GDP.labels <- label_eurostat(GDP, fix_duplicated = T)
colnames(GDP)
# Measurement units of the obs. variable 
unique(GDP$unit) 
View(cbind(as.character(unique(GDP$unit)),as.character(unique(GDP.labels$unit))))
# Obs. variable code (nomenclature: national accounts indicator)
unique(GDP$na_item) 
View(cbind(as.character(unique(GDP$na_item)),as.character(unique(GDP.labels$na_item))))
# Geographic units
unique(GDP$geo)
View(cbind(as.character(unique(GDP$geo)),as.character(unique(GDP.labels$geo))))
# time span of the observations
range(GDP$TIME_PERIOD) # we did not use: get_eurostat(..., time_format = "argument")
# seasonal adjustment
unique(GDP$s_adj)
View(cbind(as.character(unique(GDP$s_adj)),as.character(unique(GDP.labels$s_adj))))
# 
#
#
## Step 2 - GDP ## 
# Filtering
#
# Say, we only want the B1GQ - Gross domestic product at market prices from "na_item"
# AND we only want the CP_MEUR - Current prices, million euro from "unit"
# AND we only want data for CZ, PL and AT from "geo"
# AND "SCA" seas. adj. 
# AND year 2000 or later
GDP.dataset <- GDP %>% 
  filter(na_item == "B1GQ", 
         unit == "CP_MEUR", 
         geo %in% c("CZ", "PL", "AT"),
         s_adj == "SCA",
         TIME_PERIOD >= 2000)
head(as.data.frame(GDP.dataset))
# each measured variable (GDP) is in its own row, along with all the variables needed 
# to uniquely identify it (geo and time).
#
#
## Step 3 - GDP ## 
# reshape the data using dcast() 
#
# We will now rearrange the data using the dcast() 
# function so that the data frame contains a column 
# for GDP in each country. We want individual years as rows.
GDP.new.dataset <- dcast(GDP.dataset, TIME_PERIOD ~ geo+na_item, value.var = "values")
head(GDP.new.dataset)
library(zoo) # illustration only, not saved to Gl. Env.
head(zoo(GDP.new.dataset[,-1], order.by = as.yearqtr(GDP.new.dataset$TIME_PERIOD)),10)
#
#
## Step 1 - Unemployment ## 
#
#
U.series <- search_eurostat("unemployment")
View(U.series)
# We choose: Long-term unemployment by sex - quarterly average, %
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=une_ltu_q&lang=en
U.data <- get_eurostat("une_ltu_q", time_format = "num")
#
colnames(U.data)
unique(U.data$sex)
unique(U.data$indic_em) # Long term unemployment -- Very long term unemployment
unique(U.data$s_adj) # Seas. Unadjusted -- Adjusted data (not calendar adjusted) -- Trend cycle
unique(U.data$age)  # Y15-74 -- Y20-64
unique(U.data$unit) # % of active -- % of unemployment -- (000)s person
unique(U.data$geo)
range(U.data$TIME_PERIOD) # quarterly data
#
## Step 2 - Unemployment ##
# Let's retrieve data for Austria, Czech Republic and Slovakia, 
# Share of long term on total unemployment (disregard M/F data)
U.AT_CZ_PL <- U.data %>% 
  filter(indic_em == "LTU", sex == "T", unit == "PC_UNE", s_adj == "SA", age == "Y15-74") %>% 
  filter(geo %in% c("AT","CZ","PL"), TIME_PERIOD >= 2000)
#
## Step 3 - Unemployment ##
U.AT_CZ_PL.ts <- dcast(U.AT_CZ_PL, TIME_PERIOD ~  geo+indic_em , value.var = "values")
head(U.AT_CZ_PL.ts)
#
#
#
#### Join GDP and Long-term unemployment data 
#    for subsequent econometric analysis
#
## Step 1 - merge data
head(as.data.frame(GDP.new.dataset))
head(as.data.frame(U.AT_CZ_PL.ts))
?base::merge
Combined.DF <- merge(U.AT_CZ_PL.ts, GDP.new.dataset, by="TIME_PERIOD")
head(Combined.DF)
# save your dataframe for subsequent use
write.csv(Combined.DF, "datasets/GDP_Unem.csv", row.names = F)
#
#
## Step 2 - convert to TS (zoo) object
library(zoo)
head(Combined.DF)
GDP_Unem.zoo <- zoo(Combined.DF[,-1], order.by = as.yearqtr(Combined.DF$TIME_PERIOD)) # drop first column
#
head(GDP_Unem.zoo)
# Now, the usual data operations on TS may be performed easily
# lag
GDP_Unem.zoo$AT_LTU_1 <- stats::lag(GDP_Unem.zoo$AT_LTU, k = -1) # note the the -1 for "t-1"
# 1st diff
GDP_Unem.zoo$AT_LTU_d1 <- GDP_Unem.zoo$AT_LTU - GDP_Unem.zoo$AT_LTU_1 # 1st differences for AT
head(GDP_Unem.zoo)
#
## Step 3 - plot the data
#
# Normally, we have to use long-format datasets in ggplot
# {zoo} has an autoplot() function that provides simple interface to ggplot:
require(ggplot2)
autoplot(GDP_Unem.zoo[,1:3]) + 
  ggtitle("Long-Term Unemployment") + 
  scale_x_yearqtr()
#
autoplot(log(GDP_Unem.zoo[,4:6])) + 
  ggtitle("log(GDP)") + 
  scale_x_yearqtr()
#
#