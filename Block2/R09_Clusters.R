#### Identification of local clusters of high/low values of the variable being analysed
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
## Get the spatial data for NUTS regions and cast it as a sf object
#
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df20 <- giscoR::gisco_get_nuts()
# Get Unemployment data (annual, NUTS2)
U.DF <- eurostat::get_eurostat("lfst_r_lfu3rt", time_format = "num") 
summary(U.DF)
# Filter "Central Europe", 2017, Total U, Y15-74   for plotting & analysis
U.CE <- U.DF %>% 
  dplyr::filter(time %in% c(2017), nchar(as.character(geo)) == 4) %>% # 2017 & NUTS2 only
  dplyr::filter(age %in% c("Y15-74"), sex %in% ("T"), isced11 == "TOTAL") %>% # age and gender
  dplyr::mutate(NUTS0 = substr(as.character(geo), start=1, stop=2)) %>% # retrieve NUTS0 id from NUTS2
  dplyr::filter(NUTS0 %in% c(c("AT","CZ","DE","HU","PL","SI","SK"))) 
summary(U.CE) # check data dimension
# Merge with {sf} spatial data
U.sf <- df20 %>% 
  dplyr::inner_join(U.CE, by = c("NUTS_ID" = "geo")) %>% 
  arrange(NUTS_ID)  
# Plot the data 
ggplot(U.sf) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('Unempl.', colours=brewer.pal(9, "Reds"))+
  ggtitle("Unemployment in %, 2017, NUTS2 level") +
  theme_bw()
#
#
## Step 2
## Centroids, IDs, nb and W matrix ("listw")
## for spatial data used
#
# centroids
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
CE_sf <- U.sf %>% 
  st_transform(laea)
centroids <- sf::st_centroid(CE_sf)
centroids <- st_transform(centroids, 4326)
coords <- sf::st_coordinates(centroids) 
colnames(coords) <- c("long","lat")
# IDs
CE_IDs <- st_drop_geometry(CE_sf[,"NUTS_ID"]) 
IDs <- CE_IDs[,1] 
# nb - distance based with tau = 200 km
nb200km <- dnearneigh(coords, d1=0, d2=200, longlat=T, row.names = IDs)
# W matrix
W.matrix <- nb2listw(nb200km) 
#
#
## Step 3
## Preliminary testing
## Getis's clustering analysis is only valid for positive spatial auto-correlation
#
moran.test(CE_sf$values, W.matrix, na.action=na.omit)
#
#
## Step 4:  Cluster identification using G*
##
# .. Ord, J. K. and Getis, A. 1995
?localG # returns a z-score (not the underlying G statistic)
?include.self
#
# Search for clusters in the U.data (unemployment) variable 
# .. We use "W.matrix" weights.
# .. A high positive z-score for a feature indicates there
# .. is an apparent concentration of high density values within its neighbourhood of
# .. a certain distance (hot spot), and vice versa (cold spot). A z-score near zero
# .. indicates no apparent concentration. Critical values of the z-statistic 
# .. for the 95th percentile are for n=50: 3.083, n=100: 3.289. 
# 
#
# Given the G* formula, we use binary neighborhood indicators
# instead of the weighted "listw" object used for Moran's I.
# .. also, we use include.self() for G* formula
# .. and leave this function out for G formula
#
W.matrix <- nb2listw(include.self(nb200km), style="B")
# show z-score, plus the underlying G*, E(G*) and var(G*)
localG(CE_sf$values, W.matrix, return_internals = T)
# save z-score for subsequent analysis
CE_sf$LocG <- localG(CE_sf$values, W.matrix)
CE_sf$LocG
#
# We may want to plot cluster data for "significant" z-scores only
CE_sf$lG <- 0
CE_sf[CE_sf$LocG < -3.289, "lG"] <- -1 # significant cold-spot (approx)
CE_sf[CE_sf$LocG > 3.289, "lG"] <- 1 # significant hot-spot
hist(CE_sf$lG)
#
# Plot coldspots and hotspots
#
ggplot(CE_sf) +
  geom_sf(aes(fill = lG)) +
  scale_fill_gradient2('Unemployment \nHotspots \n(Red) \nColdspots \n(Blue)', 
                       low = "blue", mid = "white", high = "red")+
  ggtitle("Unemployment hotspots and coldspots, 2017, NUTS2 level") +
  theme_bw()
#
#
#
## Quick exercise
## Evaluate stability of the results with respect to
## changing spatial structure (neighbor-distance threshold)
## -> set tau to 170, 300 and 400 km and re-cast the plot.
#
#
#