#### Identification of local clusters of high/low values of the variable being analysed
#
library(dplyr)
library(eurostat)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(spdep)
rm(list = ls())
#
# Get the spatial data for NUTS regions and cast it as a sf object
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df60 <- eurostat::get_eurostat_geospatial(resolution = 60)
# Get Unemployment data (annual, NUTS2)
U.DF <- eurostat::get_eurostat("lfst_r_lfu3rt", time_format = "num") 
summary(U.DF)
# Filter "Central Europe", 2017, Total U, Y15-74   for plotting & analysis
U.CE <- U.DF %>% 
  dplyr::filter(time %in% c(2017), nchar(as.character(geo)) == 4) %>% # 2017 & NUTS2 only
  dplyr::filter(age %in% c("Y15-74"), sex %in% ("T")) %>% # age and gender
  dplyr::mutate(NUTS0 = substr(as.character(geo), start=1, stop=2)) %>% # retrieve NUTS0 id from NUTS2
  dplyr::filter(NUTS0 %in% c(c("AT","CZ","DE","HU","PL","SI","SK")))
summary(U.CE)
# Merge with {sf} spatial data
U.sf <- U.CE %>% 
  dplyr::inner_join(df60, ., by = c("NUTS_ID" = "geo"))   
# Plot the data 
ggplot(U.sf) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('Unempl.', colours=brewer.pal(9, "Reds"))+
  ggtitle("Unemployment in %, 2017, NUTS2 level") +
  theme_bw()
#
#
#
## To perform spatial dependency test
## and clustering analysis, we need a geo-coded data frame, e.g.:
#
#       | Unemployment | long | lat |
#
# Step 1: store long/lat coordinates of centroids
Centroids1 <- st_centroid(U.sf)
Centroids2 <- as.data.frame(st_coordinates(Centroids1))
colnames(Centroids2) <- c("lon","lat")
Centroids <- cbind(as.data.frame(Centroids1[,"NUTS_ID"]),Centroids2)
head(Centroids,10)
# Merge with GDP data
U.data <- merge(U.CE,Centroids, by.x="geo", by.y="NUTS_ID")
head(U.data)
#
#
# Getis's clustering analysis is only valid for positive spatial autocorelation
coords <- U.data[,c("lon", "lat")] # spdep works with sp features and objects
coords <- coordinates(coords) # sp coordinates
IDs <- U.data$geo # separately provided IDs
#
nb200km <- dnearneigh(coords, d1=0, d2=200, longlat=T, row.names = IDs)
W.matrix <- nb2listw(nb200km) # style = "W" (row standardization) is the default
moran.test(U.data$values, W.matrix, na.action=na.omit)
#
#
# Cluster identification G*
# .. Ord, J. K. and Getis, A. 1995
?localG # returns a z-score (not the underlying G statistic)
#
# Search for clusters in the U.data (unemployment) variable 
# .. We use "W.matrix" weights.
# .. A high positive z-score for a feature indicates there
# .. is an apparent concentration of high density values within its neighbourhood of
# .. a certain distance (hot spot), and vice versa (cold spot). A z-score near zero
# .. indicates no apparent concentration. Critical values of the z-statistic 
# .. for the 95th percentile are for n=50: 3.083, n=100: 3.289. 
# 
U.data$LocG <- localG(U.data$values, W.matrix)
U.data$LocG
#
# We may want to plot cluster data for "significant" z-scores only
#
U.data$lG <- 0
U.data[U.data$LocG < -3.289, "lG"] <- -1 # significant cold-spot
U.data[U.data$LocG > 3.289, "lG"] <- 1 # significant hot-spot
hist(U.data$lG)
UlG.sf <- U.data[,c("lG","geo")] %>% 
  dplyr::inner_join(df60, ., by = c("NUTS_ID" = "geo"))   
#
# Plot coldspots and hotspots
#
ggplot(UlG.sf) +
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
## set tau to 170, 300 and 400 km
#
#
#