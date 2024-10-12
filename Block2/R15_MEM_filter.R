#### Spatial filtering by Getis (illustrative example)
#
#
#  
#   Example of a spatial lag model for NUTS2 regions of
#   Austria, Czech Republic, Germany, Hungary, Poland, Slovakia
#
#
# 
# Data, data description & plots
library(dplyr)
library(eurostat)
library(sp)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(spdep) 
library(spatialreg)
library(spmoran)
library(reshape2) 
#
rm(list=ls())
CE_data <- read.csv("datasets/NUTS2_data.csv")
CE_data$log.GDP <- log(CE_data$EUR_HAB_EU_2011)
head(CE_data, 15)
plot(CE_data[ , c(4,7,8)])
#
#
# Data description:
# 
# U_pc_2012              Dependent variable, the general rate of unemployment 
#                        for a NUTS2 region i at time t (2012)
# EUR_HAB_EU_2011        region?s GDP per capita (current EUR prices of 2011) 
#                        expressed as percentage of EU average
# EUR_HAB_EU_2010 
# TechEmp_2012           percentage of employees working in the ?high-tech industry? 
#                        (NACE r.2 code HTC) in a given region and t = 2012
# NUTS_ID                NUTS2 region-identifier (NUTS.2010)
# long, lat              coordinates of regions' centroids
#
#
#      Unemployment model to be estimated:
#
#
#      U_pc_2012 <- log.GDP + TechEmp_2012
#
#
#     Distance based neighbors - maximum neighbor distance threshold: 250 km
#
#
#
# Step 1 Prepare spatial objects for subsequent analysis:
#
# (a) coordinates and IDs
coords <- CE_data[,c("long", "lat")]
coords <- sp::coordinates(coords)
IDs <- CE_data$NUTS_ID
# (b) identify neighbors given tau distance threshold
nb250km <- dnearneigh(coords, d1=0, d2=250, longlat=T, row.names = IDs)
W.matrix <- nb2listw(nb250km)
#
#
# Step 2 Prepare the MEM-filter
#
#
C1 <- nb2mat(nb250km, style = "B") # Connectivity matrix (binary)
colnames(C1) <- rownames(C1)
C1[1:10,1:10] # view sample of the matrix
#

# ?meigen
M1 <- meigen(cmat=C1) # does the eig extraction from the Omega (double cent. con. mat.)
M1.df <- as.data.frame(M1$sf)
M1.df <- cbind(M1.df,IDs)
#
# Plot eigenvectors 1 to 9:
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df20 <- giscoR::gisco_get_nuts(year="2010")
# Merge with M1.df - MEM
MEM.sf <- df20 %>%
  dplyr::inner_join(M1.df[,c(1:9,28)], by = c("NUTS_ID" = "IDs"))  
#
map.df.l <- melt(data = MEM.sf, id.vars = c("NUTS_ID", "geometry"), 
                 measure.vars = c("V1", "V2", "V3","V4", "V5", "V6","V7", "V8", "V9"))
# Plot the data 
ggplot(map.df.l) + # map.df.l is not an sf object (dataframe)
  geom_sf(aes(geometry=geometry,fill = value)) + # geometry=geometry points to a data.frame column
  scale_fill_gradientn(colours=brewer.pal(9, "Purples"))+
  ggtitle("MEM - vectors 1 to 9") +
  facet_wrap(~variable) + 
  coord_sf() +
  theme_minimal()
#
#
# Step 3 Estimate model using the MEM filter (stepwise method)
#
# Reference LRM
basic.LRM <- lm(U_pc_2012 ~ log.GDP + TechEmp_2012, data=CE_data )
summary(basic.LRM)
moran.test(basic.LRM$residuals, W.matrix, alternative = "two.sided")
#
# {spdep} - Built-in MEM-based filtering 
?spatialreg::SpatialFiltering
EI1 <- spatialreg::SpatialFiltering(U_pc_2012~1, ~ log.GDP + TechEmp_2012,
                        data = CE_data, nb = W.matrix$neighbours, style = "B",
                        zero.policy = NULL, tol = 0.1, zerovalue = 1e-02, ExactEV = F,
                        symmetric = TRUE, verbose=T)
summary(lm(U_pc_2012 ~ log.GDP + TechEmp_2012 + fitted(EI1), data=CE_data ))
#
# 
# We have use a buil-in function, i.e. we have not performed 
# the "MC-type" Moran eigenvector selection,
# "manually", using the "M1" matrix of eigenvectors.
# .. however, we can replicate the results using the M1 (MEM) 
# .. and corresponding eigenvectors
#
LRM.MEM <- lm(U_pc_2012 ~ log.GDP + TechEmp_2012
                +M1.df[,3]+M1.df[,2]+M1.df[,10]+M1.df[,5]+M1.df[,7]+M1.df[,6]+M1.df[,21],
                data=CE_data )
summary(LRM.MEM)
moran.test(LRM.MEM$residuals, W.matrix, alternative = "two.sided")







