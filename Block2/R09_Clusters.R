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
map1 <- giscoR::gisco_get_nuts()
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
U.sf <- map1 %>% 
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
## Centroids and W matrix 
#
centroids <- sf::st_centroid(st_geometry(U.sf)) # find centroids
head(centroids)
#
nb200km <- dnearneigh(centroids, d1=0, d2=200, row.names = U.sf$NUTS_ID)
summary(nb200km)
#
plot(U.sf[,"CNTR_CODE"], border="white", reset=FALSE,
     main=paste("Distance based neighbours"))
plot(nb200km, centroids, add=TRUE)
#
W.matrix <- nb2listw(nb200km) 
summary(W.matrix) 
#
#
## Step 3
## Preliminary testing
## Getis's clustering analysis is only valid for positive spatial auto-correlation
#
moran.test(U.sf$values, W.matrix, na.action=na.omit)
#
#
## Step 4:  Cluster identification using G*
##
# .. Ord, J. K. and Getis, A. 1995
?localG # returns a z-score (not the underlying G statistic)
?include.self
#
# Search for clusters in the U.data (unemployment) variable 
# .. We use "C_star" weights.
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
# C* matrix
C_star <- nb2listw(include.self(nb200km), style="B")
# show z-score, plus the underlying G*, E(G*) and var(G*)
localG(U.sf$values, C_star, return_internals = T)
G_star <- localG(U.sf$values, C_star, return_internals = T)
G_star_m <- attributes(localG(U.sf$values, C_star, return_internals = T))$internals %>% 
  as.data.frame()
G_star_m 
# save z-score & p-values for subsequent analysis
U.sf$LocG <- localG(U.sf$values, C_star) 
# same z-score can be imported from G_star_m$`Z(G*i)`
U.sf$LocGpval <- G_star_m$`Pr(z != E(G*i))`
#
# We may want to plot cluster data for "significant" z-scores only, 5% sig. level only
U.sf$locG <- "0"
U.sf[U.sf$LocG < 0 & U.sf$LocGpval < 0.05, "locG"] <- "Low" # significant cold-spot 
U.sf[U.sf$LocG > 0 & U.sf$LocGpval < 0.05, "locG"] <- "High" # significant hot-spot
U.sf$locG <- as.factor(U.sf$locG)
#
# Plot coldspots and hotspots
#
ggplot(U.sf) +
  geom_sf(aes(fill = locG)) +
  scale_fill_manual(values = c("0" = "grey",
                                "High" = "red",
                                "Low" = "blue"))+
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