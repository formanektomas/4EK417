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
df20 <- giscoR::gisco_get_nuts()
#
# Select Central EU countries
CE.sf <- df20 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% c("AT","CZ","DE","HU","PL","SK")) %>% 
  dplyr::select(NUTS_ID,CNTR_CODE) 
#
# To caluclate centroids (geographic centerpoints),
# one should use appropriate projection (equal area)
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
CE.sf <- st_transform(CE.sf,laea)
#
ggplot() + 
  geom_sf(data = CE.sf, aes(fill = CNTR_CODE))+
  theme(legend.position = "none")
##
## Centroids - representative points for areal regions
##
centroids <- sf::st_centroid(CE.sf) # find centroids
head(centroids)
#
ggplot() + 
  geom_sf(data = CE.sf, aes(fill = NUTS_ID))+
  geom_sf(data = centroids, color="black")+
  theme(legend.position = "none")
#
##
## translate centroids back to WGS84, i.e. to long/lat coordinates
head(centroids)
centroids <- st_transform(centroids, 4326)
head(centroids)
#
#
## Neighborhood calculation
#
# Matrix of coordinates & vector of identifiers (names)
# of spatial units must be provided for distance-based
# neighborhood calculation
# .. most of the "econometric" functions are not directly compatible with {sf} objects
#
#
coords <- sf::st_coordinates(centroids) # object 1: matrix of coordinates
head(coords)
colnames(coords) <- c("long","lat")
#
CS_IDs <- st_drop_geometry(CE.sf[,"NUTS_ID"]) # object 2: vector of CS-unit IDs
IDs <- CS_IDs[,1] # make a vector with IDs
head(IDs)
#
# Centroid information can be combined and stored for later use:
centds_df <- cbind(CS_IDs, coords)
head(centds_df) # & save as csv, etc.
#
######################################################
# Alternative centroid calculation, based on {sp} functions
# library(rgeos) # install.packages("rgeos")
# library(rgdal) # install.packages("rgdal")
# CE.sp <- as_Spatial(CE.sf)
# Centroids <- as.data.frame(as.character(CE.sf$NUTS_ID))
# ?coordinates
# Centroids <- cbind(Centroids, coordinates(CE.sp))
# colnames(Centroids) <- c("NUTS2", "long", "lat")
# head(Centroids)
# coords <- as.matrix(Centroids[,c("long", "lat")]) 
# IDs <- Centroids$NUTS_ID
######################################################
#
##
## Calculation/identification of distance-based neighbors
##
#
# Distance based neighbors - maximum neighbor distance threshold: 250 km
#
library(spdep) 
?dnearneigh
nb250km <- dnearneigh(coords, d1=0, d2=250, longlat=T, row.names = IDs)
summary(nb250km)
#
# Plot for distance-based neighbors / works with {sp} objects only
CE.sf <- st_transform(CE.sf, 4326) # back to WGS84
CE.sp <- as_Spatial(CE.sf) # convert to {sp}
#
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nb250km, coords, col = "black", add = T)
#
# Distance based neighbors, 
# ..maximum neighbor distance threshold set to 150 km
#
nb1 <- dnearneigh(coords, d1=0, d2=150, longlat=T, row.names = IDs)
summary(nb1) # Note the regions with no links - "islands"
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nb1, coords, col = "black", add = T)
# Island NUTS2 regions - centroids farther apart than 150 km
#
#
## Quick exercise: plot neighbors with maximum distance threshold at 220 km
#
# 
######################################################
#
#
# kNN-based neighbors
#
# kNN-based neigbors, k = 4
?knearneigh
knn4 <- knearneigh(coords, k=4, longlat=T)
?knn2nb # note the "sym" argument
nbKNN4 <- knn2nb(knn4, row.names = NULL, sym = F)
summary(nbKNN4)
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nbKNN4, coords, col = "black", add = T)
#
# kNN-based neigbors, k = 6, impose symmetry of connections (sym=T)
knn6 <- knearneigh(coords, k=6, longlat=T)
nbKNN6 <- knn2nb(knn6, row.names = NULL, sym = T)
plot(CE.sp, col = "lightgrey", border = "blue")
plot(nbKNN6, coords, col = "black", add = T)
#
#
######################################################
#
# Connectivity and Spatial weights matrices 
# Example based on data for Poland
# Contiguity rule (common border)
# .. C and W matrices are produced for illustration only
# .. (most model estimations use nb objects as inputs)
#
#
Poland.sf <- df20 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% "PL") %>% 
  dplyr::select(NUTS_ID) 
plot(Poland.sf)
#

# Centroids (only necessary to plot the neighborhood structure, NOT to calucate it)
# .. so we can ignore the laea transf. and the subsequent small inaccuracy of coords
# .. also, we manually alter centroid in the "hole" region PL92.
PL_centroids <- sf::st_centroid(Poland.sf)
PL_coords <- sf::st_coordinates(PL_centroids) # object 1: matrix of coordinates
colnames(PL_coords) <- c("long","lat")
PL_coords[17,2] <- 53 # manually shift "centroid" of "Mazowiecki regionalny" from Warszaw
# .. for visualization only, will not affect contiguity evaluation
#
# We will need the {sp} object for poly2nb()
Poland.sp <- as_Spatial(Poland.sf)
# 
#
?poly2nb # transforms polygons to nb, based on common borders
PL_contig <- poly2nb(Poland.sp, snap = 0.03) # note the snap & queen arguments
PL_contig
#
plot(Poland.sp, col = "lightgrey", border = "blue")
plot(PL_contig, PL_coords, col = "black", add = T)
#
C <- nb2mat(PL_contig, style="B") # nb to binary matrix of connectivity
C
#
W <- nb2mat(PL_contig, style="W") # nb to row-standardized matrix of connectivity
round(W,2)
#
#
#