#### Heckit - sample selection correction model ####
#
#
#
# install.packages('sampleSelection')
library(sampleSelection)
help(package=sampleSelection)
?heckit
#
# Data
rm(list=ls())
data( Mroz87 )
?Mroz87
# new dummy variabe: 1 if "has kids".
Mroz87$kids  <- ( Mroz87$kids5 + Mroz87$kids618 > 0 )
#
#
#
#
### Example 1:  Greene ( 2003 ): example 22.8, page 786
#
#
# Heckit estimation
summary( heckit( lfp ~ age + I( age^2 ) + faminc + kids + educ,
                 wage ~ exper + I( exper^2 ) + educ + city, Mroz87,
                 method = "ml") )
#
summary( heckit( lfp ~ age + I( age^2 ) + faminc + kids + educ,
                 wage ~ exper + I( exper^2 ) + educ + city, Mroz87,
                 method = "2step") )
#
#
#
#
#
#
### Example 2:  Wooldridge( 2003 ): example 17.5 
#   .. amended: hourly wages used instead of log(wage)
#
# Two-step estimation
Heckit.2step <- heckit(lfp ~ nwifeinc+educ+exper+I(exper^2)+age+kids5+kids618, 
                wage ~ educ + exper + I( exper^2 ), 
                data = Mroz87, method = "2step" )
summary(Heckit.2step)
#
# ML estimation
Heckit.ML <- heckit(lfp ~ nwifeinc+educ+exper+I(exper^2)+age+kids5+kids618, 
                       wage ~ educ + exper + I( exper^2 ), 
                       data = Mroz87, method = "ml" )
summary(Heckit.ML)
#
#
## Prediction types/arguments
#
?predict.selection
#
# Selection
# predicted probabilities of the selection equation are returned
head(predict(Heckit.ML, type = "response", part = "selection"))
#
#
# Outcome
# unconditional is the default type: E[y|X] = X %*% beta
head(predict(Heckit.ML, type = "unconditional", part = "outcome"))
#
# Conditional
# i.e. E[y|X,Z,w=1] = X %*% beta + rho * sigma * dnorm( Z %*% gamma ) / pnorm( Z %*% gamma )
#
# returns a matrix with two columns, 
# the first column returns the expectations conditional on the observation being not selected 
# (E[yo|ys=0]), while the second column returns the expectations conditional on the observation 
# being selected (E[yo|ys=1])
head( predict( Heckit.ML, type = "conditional", part = "outcome" ) )
#
#
#
#
#
#