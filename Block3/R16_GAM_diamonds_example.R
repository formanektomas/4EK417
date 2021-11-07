### R16 Example: GAM model
#
#
rm(list = ls())
library(ggplot2)
seq1 <- seq(from=1, to=50000, by=50)
diamonds <- diamonds[seq1,] # 1000 obs. from the diamonds dataset
str(diamonds)
plot(diamonds[,c("price","carat","depth","clarity")])
#
library(gam)
#
#
#
# 1 Estimate OLS model log(price) <- carat + depth + clarity




# 2 Visualize marginal effects using gam::plot.Gam()




# 3 Use GAM to make f(carat) and f(depth) smoothing splines with df=4
# evaluate significance & specification tests, suggest amendments if any




# 4 Visualize marginal effects from Step 3




# 5 Amend step 3: make f(depth) a local regression with degree=2 & span=0.3
# evaluate significance & specification tests, suggest amendments if any




# 6 Visualize marginal effects from Step 5




# 7 Plot fitted vs observed values of price




