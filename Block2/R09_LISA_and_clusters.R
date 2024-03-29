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
## Step 1 - Data
## Get the spatial data for NUTS regions and cast it as a sf object
#
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
map1 <- giscoR::gisco_get_nuts()
# Get Unemployment data (annual, NUTS2)
U.DF <- eurostat::get_eurostat("lfst_r_lfu3rt", time_format = "num") 
summary(U.DF)
# Filter "Central Europe", 2017, Total U, Y15-74   for plotting & analysis
U.CE <- U.DF %>% 
  dplyr::filter(TIME_PERIOD %in% c(2017), nchar(as.character(geo)) == 4) %>% # 2017 & NUTS2 only
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
nb250km <- dnearneigh(centroids, d1=0, d2=250, row.names = U.sf$NUTS_ID)
summary(nb250km)
#
plot(U.sf[,"CNTR_CODE"], border="white", reset=FALSE,
     main=paste("Distance based neighbours"))
plot(nb250km, centroids, add=TRUE)
#
W.matrix <- nb2listw(nb250km) 
summary(W.matrix) 
#
#
## Step 3 - Clustering analysis 
#
#
## Local Moran & LISA ---------------------------
#
# LISA, Local Indicators of Spatial Association (based on local Moran)
# Hotspots, coldspots & spatial outliers
# https://geodacenter.github.io/workbook/6a_local_auto/lab6a.html#lisa-principle
#
moran.test(U.sf$values, W.matrix, na.action=na.omit) # check general sp.dep.
dev.off()
moran.plot(U.sf$values, W.matrix, zero.policy=T, labels=U.sf$NUTS_ID)
# High-High: upper-right quadrant, hotspot, high-value region surrounded by
#            other high-value regions.
# Low-Low:   lower-left quadrant, coldspot, low-values surrounded by 
#            other low-value regions.
# Low-High:  upper-left quadrant, low-value region surrounded by high-value regions,
#            i.e. outlier.
# High-Low:  lower-right region, high-value region surrounded by low-value regions
#            i.e. outlier.
#
# As we account for statistical significance of the High/Low classification,
# we can use Local Moran's I, as follows:
LocMorTest <- localmoran(U.sf$values, W.matrix, na.action=na.omit)
U.sf$Ih <- hotspot(LocMorTest, Prname="Pr(z != E(Ii))",cutoff=0.05,)
U.sf$Ih <- addNA(U.sf$Ih) # NA values are not included as factors by default
U.sf<- U.sf %>% mutate(
  Ih = as.character(Ih),
  Ih = ifelse(is.na(Ih), "Not significant", Ih),
  Ih = as.factor(Ih))
ggplot(U.sf) +
  geom_sf(aes(fill = Ih)) +
  scale_fill_manual('LISA',
                    values = c("High-High" = "red",
                               "Low-High" = "orange",
                               "Low-Low" = "blue",
                               "High-Low" = "green",
                               "Not significant" = "bisque1"))+
  geom_sf(color = "black", linewidth=0.7, fill=NA)+
  ggtitle("Unemployment rates: LISA") +
  theme_bw()
#
#
#
#
#
#
## Getis' G, Getis' G* & hotspots, coldspots ---------------------------
#
# Getis's clustering analysis is only valid for positive spatial auto-correlation
# (Moran test repeated from code above)
moran.test(U.sf$values, W.matrix, na.action=na.omit)
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
# Given the G* formula, we use binary neighborhood indicators
# instead of the weighted "listw" object used for Moran's I.
# .. also, we use include.self() for G* formula
# .. and leave this function out for G formula
#
# C* matrix
C_star <- nb2listw(include.self(nb250km), style="B")
# show z-score, plus the underlying G*, E(G*) and var(G*)
localG(U.sf$values, C_star, return_internals = T)
#
## Manual preparation of the hotspot-coldspot map
G_star <- localG(U.sf$values, C_star, return_internals = T)
G_star_m <- attributes(localG(U.sf$values, C_star, return_internals = T))$internals %>% 
  as.data.frame()
G_star_m 
# save z-score & p-values for subsequent analysis
U.sf$LocG <- localG(U.sf$values, C_star) 
# same z-score can be imported from G_star_m$`Z(G*i)`
U.sf$LocGpval <- G_star_m$`Pr(z != E(G*i))`
# We may want to plot cluster data for "significant" z-scores only, 5% sig. level only
U.sf$locG <- "0"
U.sf[U.sf$LocG < 0 & U.sf$LocGpval < 0.05, "locG"] <- "Low" # significant cold-spot 
U.sf[U.sf$LocG > 0 & U.sf$LocGpval < 0.05, "locG"] <- "High" # significant hot-spot
U.sf$locG <- as.factor(U.sf$locG)
#
ggplot(U.sf) +
  geom_sf(aes(fill = locG)) +
  scale_fill_manual(values = c("0" = "grey",
                                "High" = "red",
                                "Low" = "blue"))+
  ggtitle("Unemployment hotspots and coldspots, 2017, NUTS2 level") +
  theme_bw()
#
## Alternative preparation, using hotspot() function
#
set.seed(12345)
G <- localG_perm(U.sf$values, C_star)
U.sf$Gh <- hotspot(G, Prname="Pr(z != E(Gi)) Sim", cutoff=0.05, p.adjust="none")
U.sf$Gh <- addNA(U.sf$Gh) # NA values are not included as factors by default
U.sf<- U.sf %>% mutate(
  Gh = as.character(Gh),
  Gh = ifelse(is.na(Gh), "Not significant", Gh),
  Gh = as.factor(Gh))
ggplot(U.sf) +
  geom_sf(aes(fill = Gh)) +
  scale_fill_manual('Getis G* \nhotspot \ncoldspot \nanalyis',
                    values = c("High" = "red",
                               "Low" =  "blue",
                               "Not significant" = "bisque1"))+
  geom_sf(color = "black", linewidth=0.7, fill=NA)+
  ggtitle("Unemployment rates: hotspots and coldspots") +
  theme_bw()


#
## Quick exercise
## Evaluate stability of the results with respect to
## changing spatial structure (neighbor-distance threshold)
## -> set tau to 170, 300 and 400 km and re-cast the plot.
#
#
#