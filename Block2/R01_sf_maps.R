library(dplyr)
library(giscoR)
library(sf)
rm(list=ls())
# https://r-spatial.github.io/sf/ 
#
#
# Get the spatial data - as an {sf} object
?gisco_get_nuts
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
myMap <- giscoR::gisco_get_nuts()
#
# Inspect downloaded spatial data
class(myMap)
str(myMap)
head(myMap)
tail(myMap)
summary(myMap)
#
#
#
# Use simple {sf} functionality for plotting NUTS0 to NUTS3 
# Example: different NUTS-levels in Germany
# .. plotss geographical features only
# .. for simplicity, we do not use ggplot2 here (see next excercise)
#
?plot.sf 
# Germany - NUTS 0
myMap %>%   
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% ("DE")) %>% # filter country level data for Germany
  dplyr::select(NUTS_ID) %>% # this is just a "trick" to get a map - you can try to comment this line.... 
  plot() # plot.sf() is performed,, plot.sf() arguments can be used.
# Germany - NUTS 1
myMap %>%   
  dplyr::filter(LEVL_CODE == 1 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  plot(key.pos=2, key.width = lcm(2.3))
# Germany - NUTS 1 - borders only (B/W)
myMap %>%   
  dplyr::filter(LEVL_CODE == 1 & grepl("DE", NUTS_ID)) %>% # alternative filtering
  dplyr::select(NUTS_ID) %>% 
  st_geometry() %>% # plot boundaries only
  plot()
#
# Germany - Combine 2 plots: NUTS 3 and NUTS1 (borders only) for Germany
# .. we are plotting 2 plots: the second is overlayed on the first
# .. note the "reset=F" and "add=T" arguments that control this.
myMap %>%   
  dplyr::filter(LEVL_CODE == 3 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  plot(main="NUTS3 Germany", reset=F) # note the reset=F argument
# Add border-lines
myMap %>%
  dplyr::filter(LEVL_CODE == 1 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  st_geometry() %>% 
  plot(lwd=2, add=T, border="black") # note the add=T argument
#
#
# Plot data for multiple countries
myMap %>%   
  dplyr::filter(CNTR_CODE %in% (c("DE","CZ","PL","AT","SK"))) %>%
  dplyr::filter(LEVL_CODE == 2) %>%
  dplyr::select(NUTS_ID) %>% 
  plot(main="Central Europe", reset=F)
# Add border-lines
myMap %>%
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% (c("DE","CZ","PL","AT","SK"))) %>%
  dplyr::select(NUTS_ID) %>% 
  st_geometry() %>% 
  plot(lwd=3, add=T, border="black")
#
#
## Additional topics:
##
## Additional NUTS plot & corresponding information
## a] Data are available at different resolutions
## b] EU's NUTS regions change over time - different NUTS "revisions" exist: 
##    2003, 2006, 2010, 2013, 2016, 2021.
#
myMap.2003 <- giscoR::gisco_get_nuts(year="2003", resolution = 20)
df1 <- giscoR::gisco_get_nuts(resolution = 01, nuts_id = "CZ02")
#
# Compare NUTS2 region CZ02 at 1:20mio and 1:1mio resolution:
#
myMap %>% # CZ02 at 1:20mio
  dplyr::filter(LEVL_CODE == 2 & grepl("CZ02", NUTS_ID)) %>%
  dplyr::select(NUTS_ID) %>% st_geometry() %>% plot(main="1:60 mio resolution")
#
df1 %>% # CZ02 at 1:1mio resolution
  dplyr::select(NUTS_ID) %>% st_geometry() %>% plot(main="1:1 mio resolution")
#
#
# Compare NUTS2 region for Croatia, revisions 2003 and current
#
myMap.2003 %>%
  dplyr::filter(LEVL_CODE == 2 & grepl("HR", NUTS_ID)) %>%
  dplyr::select(NUTS_ID) %>% plot(main="Croatia, 3 regions, NUTS rev.2003",key.pos=1)
# 
myMap %>%
  dplyr::filter(LEVL_CODE == 2 & grepl("HR", NUTS_ID)) %>%
  dplyr::select(NUTS_ID) %>% plot(main="Croatia, 2 regions, NUTS rev.2016",key.pos=1)
#
## Use different projection (geometry) settings
#
# A) WGS84 / EPSG:4326
# Basic Coordinate Reference System for computerized applications
# coordinates in degrees, preserves angles, simple, 
# major distortion closer to poles
# for details, see (CZ): https://github.com/jlacko/4EK418
st_crs(myMap)
#
myMap %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  plot(key.pos=2,key.width = lcm(2.3), graticule=T, axes = T)
#
# B) Lambert equal area
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
# Lambert equal area
# .. mapping from a sphere to a disk 
# .. accurately represents area in all regions of the sphere, 
# .. but it does not accurately represent angles.
# .. Note: "centerpoint" lattitude and longite arguments are valid for Germany only
# .. should be adjusted to match plotted data....
# .. see https://r-spatial.github.io/sf/ for detailed information
myMap %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  st_transform(laea) %>% 
  plot(key.pos=2,key.width = lcm(2.3), graticule=T, axes = T)
#
#
## Quick exercise
## Print plot of Belgium, Luxembourg and the Netherlands at NUTS3 level, 
## add NUTS 0 borders, use "laea" projection
## .. remember the "reset=F" and "add=T" arguments
## .. choose appropriate "laea" centerpoint
#
#
############################################################################
## Package RCzechia: a quick example
##
library(RCzechia) # install.packages("RCzechia")
help(package="RCzechia") # list of datasets / map elements available
#
# Quick example: plot regions and railways,
# calculate length of international railways in each LAU1 region:
#
# data download
okresy <- okresy() # LAU1
zeleznice <- zeleznice() # railway
zeleznice <- zeleznice %>% 
  mutate(ELEKTRIFIKACE = as.factor(ELEKTRIFIKACE))
zeleznice$ELEKTRIFIKACE <- forcats::fct_recode(zeleznice$ELEKTRIFIKACE, YES = "TRUE", NO = "FALSE")
#
# plot
plot(zeleznice[,"ELEKTRIFIKACE"], lwd=2, main="CZ - Railway electrification", reset=F, key.pos=1)
plot(st_geometry(okresy[,"KOD_KRAJ"]), add=T)
#
#
#
# D1 highway lenght across regions
#
D1 <- silnice()
D1 <- D1 %>% 
  filter(CISLO_SILNICE == "D1")
#
# calculation can take 5+ minutes...
sf::st_intersection(okresy, D1) %>% # LAU1 with D1 only
  mutate(Length = st_length(.)) %>% # length 
  st_drop_geometry() %>% # drops geometry
  group_by(NAZ_LAU1) %>% 
  summarise(total_length = sum(Length)) %>% 
  ungroup() %>% 
  arrange(desc(total_length)) # ordering the otuput
#
# Output as of October 2021:
#
# A tibble: 18 x 2
# NAZ_LAU1         total_length
# <chr>                     [m]
#  1 P?erov                 56377.
#  2 Bene?ov                50980.
#  3 ???r nad S?zavou       42657.
#  4 Vy?kov                 38162.
#  5 Brno-venkov            36872.
#  6 Nov? Ji??n             31768.
#  7 Praha-v?chod           27706.
#  8 Ostrava-m?sto          26807.
#  9 Jihlava                24334.
# 10 Krom????               23348.
# 11 Pelh?imov              22576.
# 12 Brno-m?sto             18318.
# 13 Havl??k?v Brod         12443.
# 14 Karvin?                10186.
# 15 Prost?jov               8225.
# 16 Praha                   6521.
# 17 Praha-z?pad             2129.
# 18 Opava                    859.
#
#
############################################################################
## Package giscoR: a quick example
##
#
library(giscoR)
world <- gisco_get_countries(resolution = "60")
#
plot(world[,1],reset = T)
#
world %>% 
  filter(CNTR_ID == "AU") %>% 
  select(CNTR_ID) %>% 
  plot()
#
#
############################################################################
## Geographic administrative units available from:  gadm.org
##
# Working example based on the gadm.org website and data
download.file("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_MLT_2_sf.rds",
              "gadm36_MLT_2_sf.rds")
#
malta <- readRDS("gadm36_MLT_2_sf.rds")
#
plot(malta[,1])
