#
# Dahlberg and Johansson Municipal Expenditure Data, 
# 265 Swedish Municipalities, 9 years
rm(list=ls())
Sweden <- read.csv("_dataW07/dahlberg.csv")
# ID = Municipality identification, 1,..., 265
# YEAR = year, 1979,...,1987
# EXPEND = Expenditures
# REVENUE = Receipts, taxes and Fees
# GRANTS = Government grants and shared tax revenues
str(Sweden)
summary(Sweden)
plot(Sweden[,-1])
#
# Assignment:
#
# Do the poolability tests from pages 25-27 of 
# "Week07_panel_data_models.pdf"
# ... Bonus task: do the Honda 1985 test
# interpret test results
#
#-------------------------------------------------------
# LM
#
# 1 Estimate a pooled model: EXPEND <- REVENUE+GRANTS
#
# 2 Use FD/FE/RE estimators
#   Perform basic tests (significant effects, FE/RE Hasuman test)
#