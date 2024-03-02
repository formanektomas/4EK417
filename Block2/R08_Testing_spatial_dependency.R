## Tests for spatial dependency
#
library(dplyr)
library(eurostat)
library(giscoR)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(spdep)
rm(list = ls())
#
#
## Step 1
## Get map from Eurostat, get GDP data
#
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
map1 <- giscoR::gisco_get_nuts()
# Get GDP data (annual, NUTS2)
GDP.DF <- eurostat::get_eurostat("nama_10r_2gdp", time_format = "num") 
summary(GDP.DF)
# Filter "Central Europe", 2016, EUR-per-Hab   for plotting & analysis
GDP.CE <- GDP.DF %>% 
  dplyr::filter(TIME_PERIOD %in% c(2016), nchar(as.character(geo)) == 4) %>% # 2016 & NUTS2 only
  dplyr::filter(unit %in% c("EUR_HAB")) %>% # GDP per capita only
  dplyr::mutate(NUTS0 = substr(as.character(geo), start=1, stop=2)) %>% # retrieve NUTS0 id from NUTS2
  dplyr::filter(NUTS0 %in% c(c("AT","CZ","DE","HU","PL","SK")))
summary(GDP.CE)
# Merge with {sf} spatial data
GDP.sf <- map1 %>% 
  dplyr::inner_join(GDP.CE, by = c("NUTS_ID" = "geo"))   
# Plot the data 
ggplot(GDP.sf) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('GDP \nEUR/cap', colours=brewer.pal(9, "Greens"))+
  ggtitle("GDP in EUR per capita") +
  theme_bw()
#
#####################
#
## Step 2
## Get centroids & the W matrix (spatial weights)
#
centroids <- sf::st_centroid(st_geometry(GDP.sf)) # find centroids
head(centroids)
#
nb250km <- dnearneigh(centroids, d1=0, d2=250, row.names = GDP.sf$NUTS_ID)
summary(nb250km)
#
plot(GDP.sf[,"CNTR_CODE"], border="white", reset=FALSE,
     main=paste("Distance based neighbours"))
plot(nb250km, centroids, add=TRUE)
#
?nb2listw # style = "W" (row standardization) is the default
W.matrix <- nb2listw(nb250km) 
summary(W.matrix) # the object is not formally a matrix (W), 
#                   but it is used as such for testing and estimation
#
#
#####################
#
## Step 3
## Tests of spatial dependency (Moran, Geary)
#
## Moran I test for the observed GDP
#
?moran.test
# GDP is in the "values" column
moran.test(GDP.sf$values, W.matrix, na.action=na.omit)
?moran.plot
#
## Spatial lag of GDP
## .. W.matrix %*% GDP vector is displayed on the y-axis.
# can be used to visualize basic spatial dependency: strength & pattern
dev.off()
moran.plot(GDP.sf$values, W.matrix, zero.policy=T, labels=GDP.sf$NUTS_ID)
#
#
## Local Moran I test 
?localmoran
LocMorTest <- localmoran(GDP.sf$values, W.matrix, na.action=na.omit)
round(head(LocMorTest,20),4)
##
# Geary's C test
#
?geary.test
geary.test(GDP.sf$values,W.matrix)
#
#
#
#
## Quick exercise:  
## Verify robustness of the Moran's I test with respect to 
## changing spatial structure assumptions
## - use tau = 170 km and  350 km,
## - use contiguity-based neighbors
## - Produce Moran plots for alternative spatial structures
#
#
#