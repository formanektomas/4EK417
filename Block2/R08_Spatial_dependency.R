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
## Get map & spatial data from Eurostat 
## and cast it as a sf object
#
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df20 <- giscoR::gisco_get_nuts()
# Get GDP data (annual, NUTS2)
GDP.DF <- eurostat::get_eurostat("nama_10r_2gdp", time_format = "num") 
summary(GDP.DF)
# Filter "Central Europe", 2016, EUR-per-Hab   for plotting & analysis
GDP.CE <- GDP.DF %>% 
  dplyr::filter(time %in% c(2016), nchar(as.character(geo)) == 4) %>% # 2016 & NUTS2 only
  dplyr::filter(unit %in% c("EUR_HAB")) %>% # GDP per capita only
  dplyr::mutate(NUTS0 = substr(as.character(geo), start=1, stop=2)) %>% # retrieve NUTS0 id from NUTS2
  dplyr::filter(NUTS0 %in% c(c("AT","CZ","DE","HU","PL","SK")))
summary(GDP.CE)
# Merge with {sf} spatial data
GDP.sf <- df20 %>% 
  dplyr::inner_join(GDP.CE, by = c("NUTS_ID" = "geo"))   
# Plot the data 
ggplot(GDP.sf) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('GDP \nEUR/Hab', colours=brewer.pal(9, "Greens"))+
  ggtitle("GDP in EUR per Habitant") +
  theme_bw()
#
#
## Step 2
## Get centroids - representative coordinates and IDs of spatial units
## (see previous R script)
#
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
# transform selected countries to laea
CE_sf <- GDP.sf %>% 
  st_transform(laea)
# get coords & translate back to WGS84
centroids <- sf::st_centroid(CE_sf) # find centroids
centroids <- st_transform(centroids, 4326)
coords <- sf::st_coordinates(centroids) # object 1: matrix of coordinates
colnames(coords) <- c("long","lat")
# IDs
CE_IDs <- st_drop_geometry(CE_sf[,"NUTS_ID"]) # object 2: vector of CS-unit IDs
IDs <- CE_IDs[,1] # make a vector with IDs
#
#
## Step 3
## Get W-matrix (or its modifications)
## start with nb structure and transform into a "nb2listw" object
## .. note that nb structure affects "spatial lag" and test results!
#
nb250km <- dnearneigh(coords, d1=0, d2=250, longlat=T, row.names = IDs)
summary(nb250km) # see previous R script
# For spatial dependency tests and model estimation, we have to 
# transform the "nb" object into a "nb2listw" - basically its a W matrix
?nb2listw # style = "W" (row standardization) is the default
W.matrix <- nb2listw(nb250km) 
summary(W.matrix) # the object is not formally a matrix (W), 
#                   but it is used as such for testing and estimation
#
#
##
##
## Moran I test for the observed GDP
#
?moran.test
# GDP is in the "values" column
moran.test(CE_sf$values, W.matrix, na.action=na.omit)
?moran.plot
#
## Spatial lag of GDP
## .. W.matrix %*% GDP vector is displayed on the y-axis.
moran.plot(CE_sf$values, W.matrix, zero.policy=T, labels=IDs)
#
#
## Local Moran I test 
?localmoran
LocMorTest <- localmoran(CE_sf$values, W.matrix, na.action=na.omit)
round(head(LocMorTest,20),4)
#
#
#
# Geary's C test
#
?geary.test
geary.test(CE_sf$values,W.matrix)
#
#
#
#
## Quick exercise:  
## Verify robustness of the Moran's I test with respect to 
## changing spatial structure assumptions
## use tau = 170 km, 300 km and 500 km.
## .. Produce Moran plots for the alternative thresholds
#
#
#