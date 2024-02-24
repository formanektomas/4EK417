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
# Visualization example 1
#
#
#
cropped <- terra::crop(year_2019, counties) # crop
CZrast <- terra::mask(cropped, counties) # mask to a defined polygon boundary
terra::plot(CZrast, main = "Built-up raster data")
plot(counties$geometry, add = T)
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
# save data with spatial information preserved
st_write(counties,"counties.gpkg")
#
savedDF <- st_read("counties.gpkg")
savedDF # compare to using write.csv() or similar functions
#
#
#
#
#-----------------
#
# Example 2: Muliple countries, NUTS2 regions vs hexagonal raster
#
#-----------------
#
rm(list = ls())
year_2019 <- terra::rast("2019.tif")
map <- giscoR::gisco_get_nuts()
#
EU <- map %>%   # country level
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% c("CZ","DE","AT")) %>% 
  dplyr::select(NUTS_ID)
#
plot(EU) # you can use ggplot - see Block 2 in the 4EK417 repository
#
EU_joint <- EU %>% # Whole area of analysis in one map
  summarize()
#
plot(EU_joint) # can be used for cropping, masking and geting NUTS2 values throug exactextract
#
EU_NUTS2 <- map %>%   # NUTS2
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% c("CZ","DE","AT")) %>% 
  dplyr::select(NUTS_ID)
# 
plot(EU_NUTS2)
#
cropped <- terra::crop(year_2019, EU_NUTS2) # crop
EU_NUTS2_rast <- terra::mask(cropped, EU_NUTS2) # mask to a defined polygon boundary
terra::plot(EU_NUTS2_rast, main = "Built-up raster data")
plot(EU_NUTS2$geometry, add = T)
#
EU_NUTS2$builtup <- exactextractr::exact_extract(
  x = year_2019, # source
  y = EU_NUTS2, # target
  fun = "mean", # calculation of average built-up - can be used for air pollution, etc.
  weights = "area",
  coverage_area = T
) 
#
#-----------------
#
ggplot(data = EU_NUTS2, aes(fill = builtup, label = round(builtup))) +
  geom_sf(lwd = 1/3) +
  scale_fill_viridis_c(name = "Build-up area\n(as % of total)\n ") +
  labs(title = "Build-up relative area as of 2019 (latest data)",
       caption = " (c) Copernicus Service Information 2019") +
  theme(axis.title = element_blank(),
        plot.caption = element_text(face = "italic"))
#
# Repeat the above using hexagonal raster, rather than NUTS2 regions
#
# The number of hexagons (80x100 is ad-hoc)
# you need to evaluate and change for each region you work with
grid1 <- st_make_grid(EU_NUTS2, square = F, n = c(80,100)) # n=c(columns, rows)
plot(grid1)
EUgrid <- st_intersection(grid1,EU_joint)
plot(EUgrid)
EUpolygons <- st_as_sf(EUgrid)
# data cleaning (necesary for exactextract to work)
# choose polygons and multipolygons only, drop the rest (lines, points, etc.).
EUpolygons <- EUpolygons[st_is(EUpolygons,c("POLYGON", "MULTIPOLYGON")),] 
EUpolygons$PolID <- 1:nrow(EUpolygons)
EUpolygons
EUpolygons <- as(EUpolygons,"Spatial") # fix sf structure
EUpolygons <- st_as_sf(EUpolygons) # fix sf structure
EUpolygons
plot(EUpolygons)
# can be used for exactextract - calculate values from satellite image to each hexagon
#
#
EUpolygons$builtup <- exactextractr::exact_extract(
  x = year_2019, # source
  y = EUpolygons, # target
  fun = "mean", # calculation of average built-up - can be used for air pollution, etc.
  weights = "area",
  coverage_area = T
) 
EUpolygons

#
#-----------------
#
ggplot(data = EUpolygons, aes(fill = builtup, label = round(builtup))) +
  geom_sf(lwd = 1/3) +
  scale_fill_viridis_c(name = "Build-up area\n(as % of total)\n ") +
  labs(title = "Build-up relative area as of 2019 (latest data)",
       caption = " (c) Copernicus Service Information 2019") +
  geom_sf(data=EU_NUTS2, fill=NA, color = "white") +
  theme(axis.title = element_blank(),
        plot.caption = element_text(face = "italic"))
#
#
st_write(EUpolygons, "EUpolygons.gpkg",delete_dsn = T) 
#
#
#
#-----------------
#
# Example 3: NO2 pollution 
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
NUTS0 <- giscoR::gisco_get_nuts(country=c("Germany","Austria","Czechia"),nuts_level = 0)
NUTS0 <- select(NUTS0, NUTS_ID)

NUTS3$NO2 <- exactextractr::exact_extract(
  x = rEurope, # source
  y = NUTS3, # target
  fun = "mean", # calculation of average air pollution in the area
  weights = "area"
) 
# 
summary(NUTS3$NO2)
# Plot the results
ggplot(data = NUTS3) +
  geom_sf(aes(fill = NO2), lwd = 1/3) +
  scale_fill_viridis_c(name = "NO2 air\npollution") +
  labs(title = "NO2 air pollution infomap",
       caption = " (c) Copernicus Service Information") +
  geom_sf(data=NUTS0, color="white", fill=NA, linewidth=1)+
  theme_dark()



