## Maps and choropleths with {ggplot2}
#
library(dplyr)
library(eurostat)
library(sf)
library(ggplot2)
library(RColorBrewer)
rm(list = ls())
#
#
#### Simple maps with {ggplot2}
#
# Get the spatial data for NUTS regions in {sf} format
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
myMap <- giscoR::gisco_get_nuts()
#
#
# Example of map for Germany - NUTS 2
Germany_NUTS2 <- myMap %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% ("DE")) %>% 
  dplyr::select(NUTS_ID)
# ggplot2 map
ggplot() + 
  geom_sf(data = Germany_NUTS2)
#
# LAEA geometry
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
GermanyLAEA <- st_transform(Germany_NUTS2,laea)
ggplot() + 
  geom_sf(data = GermanyLAEA)
#
#
###########################################################################
#
#
#### Simple choropleths with {ggplot2}
#
# 1) Download a dataset from Eurostat
#
# Macroeconomic data
# .. Disposable income of private households by NUTS 2 regions
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=tgs00026
#
Income.DF <- eurostat::get_eurostat("tgs00026", time_format = "num") 
# 
Income.DF <- Income.DF %>% 
  mutate(unit = as.factor(unit),
         direct = as.factor(direct),
         na_item = as.factor(na_item))
#
summary(Income.DF) # single variable for differet CS and TS observations
labels <- label_eurostat(Income.DF, fix_duplicated = T)
t(labels[1,])
#
#
# 2) Filtering data for NUTS2 level
#    - just a single-step in data simplification,
#      we keep data for multiple time periods and multiple countries
Income.DF <- Income.DF %>% 
  dplyr::filter(nchar(as.character(geo)) == 4) 
# NUTS2 ID is 4-digit
# note that the "nchar()" does nothing here as all data are NUTS2 already 
# .. generally, NUTS1 and NUTS0 summarized data would be present in Eurostat datasets
summary(Income.DF)
#
# 3) Merge with {sf} spatial data
# .. if you want LAEA geometry, use map-transformation before/after joining.
# when joining sf and df object, sf object must go first to preserve (geometry), i.e. sf format
# inner_joins is used, because map contains different NUTS levels and we only need NUTS2.
Income.sf <- myMap %>% 
  dplyr::inner_join(Income.DF, by = c(  "NUTS_ID"="geo")) #   
# note the number of rows: not all NUTS2 regions have data for all years
#
summary(Income.sf) # PPS/Hab for all NUTS2 regions and years + shapefiles
#
#
# 4) Plot the data 
#
#
# 4a) Plot example:  2015 only, Germany only
Plot1DF <- Income.sf%>%   
  dplyr::filter(TIME_PERIOD == 2015 & CNTR_CODE %in% ("DE"))
#
head(Plot1DF) # we want to plot "values" using the "geometry" entries (on a map)
# choropleth/infomap is simple to produce
ggplot(Plot1DF) +
  geom_sf(aes(fill = values))
#
#
#
# 4b) Repeat using {RColorBrewer} package
?scale_fill_gradientn
?brewer.pal
# The sequential palettes names are 
# Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu 
# PuBuGn PuRd Purples RdPu Reds YlGn YlGnBu YlOrBr YlOrRd
# .. from 3 different values up to 9 different values.
# The diverging palettes are 
# BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
#
#
ggplot(Plot1DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Greens"))+
  ggtitle("PPS per Habitant") +
  theme_bw()
# 
#
#
# 4c) Plot 2010 & 2015, Germany and Austria 
#
# 1st DF with PPS information for the two countries (sf format)
Plot2DF <- Income.sf %>%   
  dplyr::filter(TIME_PERIOD %in% c(2010,2015) & CNTR_CODE %in% c("DE","AT"))
head(Plot2DF) # note that data is in "long format"
tail(Plot2DF) # some columns are redundant (geo/id...)
#
# 2nd DF with supplementary information to be used in the plot - NUTS0 borders.
borders <- myMap %>%   
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% c("DE","AT")) %>%
  dplyr::select(NUTS_ID)
#
ggplot(Plot2DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Greens"))+
  geom_sf(data=borders, color = "black", linewidth=1, fill=NA) + # borders - from own DF
  ggtitle("PPS per capita") +
  facet_wrap(~TIME_PERIOD, ncol=2)+
  theme_bw()
#
# 4d) Plotting can be done in single pipeline (still, borders come from separate DF) :
#
Income.sf%>%   
  dplyr::filter(TIME_PERIOD %in% c(2010,2015) & CNTR_CODE %in% c("DE","AT")) %>% 
  ggplot() +
    geom_sf(aes(fill = values)) +
    scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Greens"))+
    geom_sf(data=borders, color = "darkred", linewidth=1, fill=NA) + # borders - from own DF
    ggtitle("PPS per Habitant") +
    facet_wrap(~TIME_PERIOD, ncol=2)+
    theme_bw()
#
# Saving data to disk while maintaining spatial awareness
# - compare to using write.csv()
#
Income.sf$FID <- NULL # https://github.com/qgis/QGIS/issues/34613
st_write(Income.sf, dsn = "Income.gpkg")
#
Inc2 <- st_read("Income.gpkg")
head(Inc2)
#
#
# 5) binary and/or categorical data
#
# Say, we want to plot the data for Germany, 2015
# and distinguish only above-average from below-average (Germany-wide) values:
#
Plot5DF <- Income.sf%>%   
  dplyr::filter(TIME_PERIOD == 2015 & CNTR_CODE %in% ("DE"))
#
meanVal <- mean(Plot5DF$values)
Plot5DF$RichReg <- as.factor(ifelse(Plot5DF$values >= meanVal,1,0)) # identifies above-avg regions as "rich"
#
ggplot(Plot5DF) +
  geom_sf(aes(fill = RichReg))
#
#
# 
#-------------
#
## Quick supervised example
#
# 1) Download data: Eurostat code: road_eqr_zevpc
#    Share of new zero-emission vehicles in all new vehicles of the same type, 
#    by type of vehicle and type of motor energy (source: Eurostat, EAFO)
#    
# 2) Identify variables (labels) and data structure (NUTS level, time period, etc.)
#    - use R07_Eurostat.Rmd from Block1 as reference
#
# 3) Provide an infomap (choropleth) for the latest (newest) period available
#    - focus on continental Europe, leave non-EU countries (with NA values) in, maybe drop Turkey
#      (look at coord_sf() function used in self-study example below)
#








#
#
#--------------------------------------------------
#
# Additional self-study examples
#
#--------------------------------------------------
#### Spain & Portugal
#
# based on data used previously
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=tgs00026
#
# Plot 2015, Spain
Plot3DF <- Income.sf%>%   
  dplyr::filter(TIME_PERIOD %in% c(2015) & CNTR_CODE %in% c("ES"))
Plot3DF
#
ggplot(Plot3DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "YlGn"))+
  ggtitle("PPS per Habitant") +
  theme_dark()
#
# We can avoid plotting Canary islands by limiting x and y coordinates
ggplot(Plot3DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "YlGn"))+
  ggtitle("PPS per Habitant") +
  coord_sf(xlim = c(-10, 5), ylim = c(35, 45)) # x <-> longitude, y <-> latitude
#
#
# Plot 2015, Spain & Portugal, add state border-lines
Plot4DF <- Income.sf%>%   
  dplyr::filter(TIME_PERIOD %in% c(2010) & CNTR_CODE %in% c("ES","PT"))
Plot4DF
#
borders <- myMap %>%   
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% c("ES","PT")) %>%
  dplyr::select(NUTS_ID)
#
ggplot() + # note the changed data argument...
  geom_sf(data=Plot4DF, aes(fill = values)) + # data for choropleth
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Oranges"))+ # scale and colors
  geom_sf(data=borders, color = "gray30", linewidth=1.3, fill=NA) + # borders - from own DF
  labs(title="PPS per Habitant", y="Latitude", x="Longitude")+ # labels
  coord_sf(xlim = c(-10, 5), ylim = c(35, 45))+ # map range
  theme_light()  # theme
#
## Quick exercise 1:
## Repeat previous plot, but switch "Plot4DF" and "borders" line-ordering
#
#
#
## Quick exercise 2:
## Plot a choropleth as follows:
## - Spain and Portugal
## - 2010 and 2015 (use facets - organize in one column)
## - use LAEA
## - add state borders.
## - use "Greens" palette with 7 levels
#
#
#
#
## Map with inset object (Canary Islands) - a simplified example
#
# Plot4DF repeated (in case "changed" during Q.E.2)
Plot4DF <- Income.sf%>%   
  dplyr::filter(TIME_PERIOD %in% c(2010) & CNTR_CODE %in% c("ES"))
borders <- myMap %>%   
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% c("ES")) %>%
  dplyr::select(NUTS_ID)
#
P1 <- ggplot() + 
  geom_sf(data=Plot4DF, aes(fill = values)) + # data for choropleth
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Greens"))+ # scale and colors
  geom_sf(data=borders, color = "gray30", linewidth=1, fill=NA) + # borders - from own DF
  labs(title="PPS per Habitant - Spain", y="Latitude", x="Longitude")+ # labels
  coord_sf(xlim = c(-11, 5), ylim = c(34, 44.5))+ # map range
  theme_light()  # theme
#
CI <- ggplot() + # Canary Islands
  geom_sf(data=Plot4DF, aes(fill = values)) + # data for choropleth
  scale_fill_gradientn(name=NULL, colours=brewer.pal(9, "Greens"))+ # scale and colors
  geom_sf(data=borders, color = "gray30", linewidth=1, fill=NA) + # borders - from own DF
  coord_sf(xlim = c(-18, -13), ylim = c(27.5, 29.5))+ # map range
  theme_minimal()+
  theme(axis.title = element_blank(), # strip-down the inset plot
        axis.text  = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_line("white"), 
        legend.position = "none",
        plot.background = element_rect(colour = "black"))

#
library(grid)
P1 +
  annotation_custom(ggplotGrob(CI), xmin = -12, xmax = -5, ymin = 33.7, ymax = 35.8)
#  
#
#
#