## Defining neighbors in R
#
#
#
library(dplyr)
library(eurostat)
library(sf)
# Get the spatial data for NUTS regions 
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df60 <- get_eurostat_geospatial(resolution = 60)
#
# Select Central EU countries
CE.sf <- df60 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% c("AT","CZ","DE","HU","PL","SK")) %>% 
  dplyr::select(NUTS_ID) 
#
plot(CE.sf)
#
# for spatial analysis, most of the spatial object need to be "sp" - not "sf"
CE.sp <- as_Spatial(CE.sf)
#
library(rgeos) # install.packages("rgeos")
library(rgdal) # install.packages("rgdal")
#
######################################################
#
#
# Centroids - representative points for areal regions
#
Centroids <- as.data.frame(as.character(CE.sf$NUTS_ID))
?coordinates
Centroids <- cbind(Centroids, coordinates(CE.sp))
colnames(Centroids) <- c("NUTS2", "long", "lat")
head(Centroids)
# Data preparation for neighbor-object calculation
coords <- as.matrix(Centroids[,c("long", "lat")]) 
# the above gives the same output as `coordinates(CE.sp)`
IDs <- Centroids$NUTS_ID
#
#
######################################################
#
#
# Distance-based neighbors
#
#
# Distance based neighbors - maximum neighbor distance threshold: 250 km
library(spdep) # install.packages("spdep")
?dnearneigh
nb250km <- dnearneigh(coords, d1=0, d2=250, longlat=T, row.names = IDs)
summary(nb250km)
# Plot for distance-based neighbors
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nb250km, coords, col = "black", add = T)
#
# Distance based neighbors, 
# ..maximum neighbor distance threshold set to 150 km
nb1 <- dnearneigh(coords, d1=0, d2=150, longlat=T, row.names = IDs)
summary(nb1) # Note the non-connected units - "islands"
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nb1, coords, col = "black", add = T)
# Note the island NUTS2 regions (centroids farther apart than 150 km)
#
## Quick exercise: plot neighbors with maximum distance threshold at 220 km
#
# 
######################################################
#
#
# kNN-based neighbors
#
# KNN-based neigbors, k = 4
?knearneigh
knn4 <- knearneigh(coords, k=4, longlat=T)
?knn2nb # note the "sym" argument
nbKNN4 <- knn2nb(knn4, row.names = NULL, sym = T)
summary(nbKNN4)
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nbKNN4, coords, col = "black", add = T)
#
# KNN-based neigbors, k = 10
knn10 <- knearneigh(coords, k=10, longlat=T)
nbKNN10 <- knn2nb(knn10, row.names = NULL, sym = T)
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nbKNN10, coords, col = "black", add = T)
#
#
######################################################
#
# Connectivity and Spatial weights matrices 
# Example based on data for Poland
#
#
Poland.sf <- df60 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% "PL") %>% 
  dplyr::select(NUTS_ID) 
Poland.sp <- as_Spatial(Poland.sf)
#
plot(Poland.sf)
#
Pl.Centroids <- as.data.frame(as.character(Poland.sf$NUTS_ID))
Pl.Centroids <- cbind(Pl.Centroids, coordinates(Poland.sp))
colnames(Pl.Centroids) <- c("NUTS2", "long", "lat")
Pl.coords <- as.matrix(Pl.Centroids[,c("long", "lat")])
Pl.IDs <- Pl.Centroids$NUTS_ID
#
Pl.nb250km <- dnearneigh(Pl.coords, d1=0, d2=250, longlat=T, row.names = Pl.IDs)
summary(Pl.nb250km)
plot(Poland.sp, col = "lightgrey", border = "blue")
plot(Pl.nb250km, Pl.coords, col = "black", add = T)
#
C <- nb2mat(Pl.nb250km, style="B") # binary
C
#
W <- nb2mat(Pl.nb250km, style="W") # row-standardized
round(W,3)
#
#
#
######################################################
#
#
# It is possible to create neighbors from sf-type objects:
#
# https://cran.r-project.org/web/packages/spdep/vignettes/nb_sf.html
#