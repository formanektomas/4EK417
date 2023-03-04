## Defining neighbors in R 
#
#
#
library(ggplot2)
library(dplyr)
library(eurostat)
library(giscoR)
library(sf)
rm(list = ls())
# Get the spatial data for NUTS regions 
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
map1 <- giscoR::gisco_get_nuts()
#
# Select Central EU countries
CE.sf <- map1 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% c("AT","CZ","DE","HU","PL","SK")) %>% 
  dplyr::select(NUTS_ID,CNTR_CODE) 
#
# To caluclate centroids (geographic centerpoints),
# one should use appropriate projection (equal area)
#
ggplot() + 
  geom_sf(data = CE.sf, aes(fill = CNTR_CODE))+
  theme(legend.position = "none")
##
## Centroids - representative points for areal regions
##
#
# Note that centroids' and distances' calculations depend on projection
# .. for projection choice, see
# .. https://learn.arcgis.com/en/projects/choose-the-right-projection/
# .. ( e.g. transform CE.sf1 to LAEA, calculate coordinates and tranform back to WGS 84)
#
#
centroids <- sf::st_centroid(st_geometry(CE.sf)) # find centroids
head(centroids)
#
# compare to
# sf::st_centroid(CE.sf) 
# .. original DF with centroids instead of polygons in the geometry column
#
#
# Distance based neighbors - maximum neighbor distance threshold: 250 km
#
library(spdep) 
?dnearneigh
nb250km <- dnearneigh(centroids, d1=0, d2=250, row.names = CE.sf$NUTS_ID)
summary(nb250km)
#
plot(CE.sf[,2], border="white", reset=FALSE,
     main=paste("Distance based neighbours"))
plot(nb250km, centroids, add=TRUE)
#
#
#
## Quick exercise: plot neighbors with maximum distance threshold at 150 km
#
# 
######################################################
#
#
## kNN-based neighbors
#
# kNN-based neigbors, k = 4
#
?knearneigh
?knn2nb # note the "sym" argument
#
knn4 <- knearneigh(centroids, k=4)
nbKNN4 <- knn2nb(knn4, row.names = CE.sf$NUTS_ID, sym = F)
summary(nbKNN4)
#
plot(CE.sf[,2], border = "blue", reset = F)
plot(nbKNN4, centroids, col = "black", add = T)
#
#
## Quick exercise:
## make kNN-based neigbors, k = 6, impose symmetry of connections (sym=T)
#
# 
######################################################
#
## Contiguity rule (common border) 
## Connectivity and Spatial weights matrices 
## 
#
#
Poland.sf <- map1 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% "PL") %>% 
  dplyr::select(NUTS_ID) 
plot(Poland.sf, key.pos=1)
#
#
# Centroids (only necessary to plot the neighborhood structure, NOT to calucate it)
PL_centroids <- Poland.sf %>% 
  st_geometry() %>% 
  st_centroid()
PL_centroids
#
# manually shift "centroid" of "Mazowiecki regionalny" from Warszaw
# .. for visualization only, will not affect contiguity evaluation
PL_centroids[17] <- st_point(c(21.08923, 53))
#
#
?poly2nb # transforms polygons to nb, based on common borders
PL_contig <- poly2nb(Poland.sf, snap = 0.03) # note the snap & queen arguments
summary(PL_contig)
#
# dev.off()
plot(Poland.sf, col = "lightgrey", border = "blue", reset = F)
plot(PL_contig, PL_centroids, col = "black", add = T)
#
# Connectivity and weight matrices
#
C <- nb2mat(PL_contig, style="B") # nb to binary matrix of connectivity
colnames(C) <- Poland.sf$NUTS_ID
rownames(C) <- Poland.sf$NUTS_ID
C
#
W <- nb2mat(PL_contig, style="W") # nb to row-standardized matrix of connectivity
colnames(W) <- Poland.sf$NUTS_ID
rownames(W) <- Poland.sf$NUTS_ID
round(W,2)
#
#
## Quick exercise:
## make contiguity-based neigbors for Italy
#
#
##################################

