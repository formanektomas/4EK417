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
#-------------------------------------------------------
# LM
#
# 1 Estimate a LM model: EXPEND <- REVENUE+GRANTS
#
# 2 Add year dummies to the LM model (1)
#
# 3 Add fixed effects (municipality-based interpcets) to model (2)
#-------------------------------------------------------
# LME models   ....  use either lme()  or lmer()
#
# 4 Add random intercept (for each municipality)
#
# 5 Add crossed random effects (municipality, year)
#
# 6 Use fixed time effects, random intercept and random slope on REVENUE
#
# 7 Assess the generalization from model (4) to model (6)