library(sf)
library(RCzechia)
library(terra) 
library(dplyr)
library(ggplot2)
rm(list = ls())
#-----------------
#
# Step 1: Download a pre-processed image from Copernicus
# example is for buil-up area but can be used for air pollution, etc.
#
# https://lcviewer.vito.be/download , select Built-up , 2019 , Discrete classification
# & save file as "2019.tif" in your working directory
#
#-----------------
#
year_2019 <- terra::rast("2019.tif")
# base plot
plot(year_2019)
#
#-----------------
#
# CZ: highest res adm. units, 
counties <- RCzechia::okresy()
plot(counties[,1])
#
#-----------------
#
# calculate average buitup area (proportion) at county level
# can be done similarly for NUTS2, etc.
#
counties$builtup <- exactextractr::exact_extract(
  x = year_2019, # source
  y = counties, # target
  fun = "mean", # calculation of average built-up - can be used for air pollution, etc.
  weights = "area",
  coverage_area = T
) 
#
#-----------------
#
ggplot(data = counties, aes(fill = builtup, label = round(builtup))) +
  geom_sf(lwd = 1/3) +
  scale_fill_viridis_c(name = "Build-up area\n(as % of total)\n ") +
  labs(title = "Build-up relative area as of 2019 (latest data)",
       caption = " (c) Copernicus Service Information 2019") +
  theme(axis.title = element_blank(),
        plot.caption = element_text(face = "italic"))
#
#-----------------
#
# Example 2: NO2 pollution 
#
#-----------------
#
library(ncdf4) # package for netcdf manipulation
rm(list = ls())
#
# https://maps.s5p-pal.com/no2/
# download NO2 pollution image data using the icon on lower-right of the map
# change name of the NetCDF to some simple name, eg. "NO2data.nc"
# Note: File has approx. 1GB
#
# example follows from the tutorial here: https://rpubs.com/boyerag/297592
# and https://rpubs.com/GeospatialEcologist/SpatialRaster
#
#-----------------
#
r <- terra::rast("NO2data.nc")
r
plot(r)
plot(r[[1]])
# The maps show the concentration of nitrogen dioxide (NO2) in the lowest kilometers 
# of the atmosphere. Nitrogen oxides are mainly produced by human activity and the 
# combustion of (fossil) fuels, such as road traffic, ships, power plants and other 
# industrial facilities. Burning activities and wildfires also contribute significantly 
# to the NO2 concentrations observed. NO2 can have a significant impact on human health, 
# both directly and indirectly through the formation of ozone and small particles.


# crop to Europe
EuropeBBOX <- sf::st_bbox(c(xmin = -9, xmax = 32, ymax = 72, ymin = 35), crs = sf::st_crs(4326))
rEurope <- crop(r[[1]], EuropeBBOX)
plot(rEurope)
#
writeCDF(rEurope, "NO2Europe.nc", overwrite=TRUE, varname="NO2",
         longname="troposhperic_NO2_density_umol/m2")
#
# 
library(giscoR)
NUTS3 <- giscoR::gisco_get_nuts(country=c("Germany","Austria","Czechia"),nuts_level = 3)

NUTS3$NO2 <- exactextractr::exact_extract(
  x = rEurope, # source
  y = NUTS3, # target
  fun = "mean", # calculation of average air pollution in the area
  weights = "area"
) 
# 
summary(NUTS3$NO2)
# Plot the results
ggplot(data = NUTS3, aes(fill = NO2, label = round(NO2))) +
  geom_sf(lwd = 1/3) +
  scale_fill_viridis_c(name = "NO2 air\npollution") +
  labs(title = "NO2 air pollution infomap)",
       caption = " (c) Copernicus Service Information") +
  theme(axis.title = element_blank(),
        plot.caption = element_text(face = "italic"))



