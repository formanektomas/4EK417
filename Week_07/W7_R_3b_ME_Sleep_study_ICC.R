#### Sleep study example: ICC and its bootstrapped significance ####
#
#
# 
#
#
#
rm(list=ls())
library(sjstats) # for ICC and bootstrapping
library(dplyr)   # for the pipe
library(lme4)
?sleepstudy
#
# compute ICC
fit <- lmer(Reaction ~ Days + ( 1| Subject), sleepstudy)
summary(fit)
#
# ICC manual calculation:
1378.2/(960.5+1378.2)
#
?icc
icc(fit) # (1378.2)/(960.5+1378.2)
#
#
# compute bootstrapped SE of ICC
#
#
#
# Step 1
set.seed(500)
dummy <- sleepstudy %>% 
  # generate 100 bootstrap replicates of dataset
  bootstrap(100) %>% 
  # run mixed effects regression on each bootstrap replicate
  mutate(models = lapply(.$strap, function(x) {
    lmer(Reaction ~ Days + (1|Subject), data = x)
  })) %>% 
  # compute ICC for each "bootstrapped" regression
  mutate(icc = unlist(lapply(.$models, icc, ajusted=T)))
#
# # Step 2
# now compute SE and p-values for the bootstrapped ICC
boot_se(dummy, icc)
boot_p(dummy, icc)
# boot_ci(dummy, icc)
# boot_est(dummy, icc)
#
#
# Check the functions in {sjstats} for reference 
?sjstats::bootstrap
?boot_se
?boot_p
#
# Amended from
# https://stats.stackexchange.com/questions/232252/intraclass-correlation-standard-error

