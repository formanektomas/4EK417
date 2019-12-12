#### {quantmod} - Financial data from YAHOO Finance and other sources ####
#
#
library("dplyr")
library("quantmod") # install.packages("quantmod")
help(package="quantmod")
# http://www.quantmod.com/
# .. for additional documentation and examples
#
#
## Example 1: load and describe Apple market data from Yahoo 
#
#######################################################################################
#
# Apple
#
getSymbols("AAPL", from = "2015-01-01", to = Sys.Date()) # Yahoo is the default data source
# loads "silently" - no need to specify destination object name
head(AAPL)
tail(AAPL)
chartSeries(AAPL)
#
# Basic financial analysis tools are available:
?periodReturn
head(quarterlyReturn(AAPL),12)
yearlyReturn(AAPL)
#
# Montlhly returns 
#
barChart(to.monthly(AAPL),up.col='green',dn.col='red', theme = "black") 
#
# Bollinger Bands
# N-period moving average (MA), with K times an N-period standard deviation bound shown
# .. N and K are (generally) user provided, R default: n=20, K=2.
#
AAPL %>%
  chartSeries(TA='addBBands();
              addBBands(draw="p");
              addVo();
              addMACD()', 
              subset='2018',
              theme="white") 
#
# https://en.wikipedia.org/wiki/Bollinger_Bands
#
#
# The downloaded "xts"type object may be easily tranformed into
# data frames or time series:
apple.frame <- as.data.frame(AAPL)
apple.ts <- as.ts(AAPL)
library(zoo) # install.packages("zoo")
apple.zoo <- zoo(AAPL)
#
#
# Basic data manipulation: monthly averages from daily data
#
# Say, we want to retrieve montly & quarterly average exchange rates.
# Besides dplyr functions that we can use,
# {zoo} provides own simple aggregation tools. 
#
# Aggregate by months
?aggregate.zoo
aggregate(apple.zoo, as.yearmon, mean)
# and by quarters
aggregate(apple.zoo, as.yearqtr, mean)
#
#
#
#######################################################################################
#
# Ford Motors
#
getSymbols("F", from = "2014-07-01", to = Sys.Date())
chartSeries(F)
addMACD() 
addBBands() 
#
#######################################################################################
#
## Assignment 1
## Using the above methods, download and plot:
## - Microsoft stock data / MSFT
## - Tesla stock data     / TSLA
#
#
#
#
#######################################################################################
#
#
#
#
#
#
#
#
## Example 2: load exchange rates from oanda.com
#
getFX("EUR/USD") # loads silently..
head(EURUSD, 10)
tail(EURUSD, 10)
candleChart(EURUSD)
#
getFX("EUR/CZK", from="2017-01-01")
candleChart(EURCZK)
#
#
#
#
#
#
#
#
#
# See web page for additional examples
# https://rpubs.com/mr148/364194
#
#
#
#