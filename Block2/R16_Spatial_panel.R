#######################################################
#
#
library(httr2)
library(sp)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(splm) 
library(dplyr)
library(spdep)
# 
# 
rm(list=ls())
Pdata <- read.csv("datasets/PanelData.csv")
PdataF <- plm::pdata.frame(Pdata,index = c("NUTS_ID", "time"))
str(Pdata)
summary(Pdata)
#
#
### Data
#
# Pdata$EUR_HAB ... Pdata$PPS_HAB_EU - GDP per capita, etc. 
#
# Pdata$U_pc ... unemployment %
#
# Pdata$A_B ... Pdata$S  ... labor market structure, see 
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=htec_emp_reg2&lang=en
#
# Pdata$long, lat - centroids
#
# Pdata$HUClstr 
# High unemployment cluster in:
# HU10, HU31, PL21, PL22, PL32, PL33, SK03, SK04 
#
# Pdata$Y2010, etc. - Year dummies
#
# Pdata$OLD.EU Austria, West Germany (inc. Berlin)
#
#
# Individual (within) means for CRE estimation....
Pdata <- Pdata %>% 
  arrange(NUTS_ID,time) %>% 
  group_by(NUTS_ID) %>% 
  mutate(EUR_HAB_EU_bar=mean(EUR_HAB_EU), 
         HTC_bar=mean(HTC)) %>% 
  ungroup()
#
## Plot the Unemployment data
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df20 <- giscoR::gisco_get_nuts(year=2013)
# df20 <-sf::st_read("datasets/NUTS_RG_60M_2013_4326.geojson")
#
df20 %>% 
  dplyr::inner_join(Pdata, by = "NUTS_ID") %>% 
  filter(time == 2009 | time == 2014) %>% 
  ggplot() +
    geom_sf(aes(fill = U_pc)) +
    scale_fill_gradientn('Unem', colours=brewer.pal(9, "Reds"))+
    ggtitle("Unemployment rates in %") +
    facet_wrap(~time, ncol=1)+
    theme_bw()
#
#
# Geographic information
coords <- Pdata[Pdata$time==2011,c("long", "lat")]
coords <- sp::coordinates(coords)
summary(coords)
nb <- dnearneigh(coords, d1=0, d2=240, longlat=T)
CE_data.listw <- nb2listw(nb)
W_matrix <- nb2mat(nb)
# 
#
#
#
#
#
#
### Model estimaton 
#
# Provide model formula separately, for syntax simplicity
fm1 <- U_pc ~ EUR_HAB_EU + HTC +HUClstr +I(HTC*HUClstr) + EUR_HAB_EU_bar + HTC_bar 
#
#
#  Pesaran, M.H. (2004), General Diagnostic Tests for Cross Section Dependence in Panels
#
rwtest(fm1, data = Pdata, w = W_matrix, 
       index = c("NUTS_ID", "time"), model = "within")
#
# ML - pooled regression
?spml
mod.1 <- spml(formula = fm1, data = Pdata, index = c("NUTS_ID","time"),
              listw = CE_data.listw, model = "pooling",
              lag = F, spatial.error = "none")
summary(mod.1)
#
#
#
# ML - RE Spatial lag model
Lag_mod <- spml(formula = fm1, data = Pdata, index = c("NUTS_ID","time"),
              listw = CE_data.listw, model = "random",
              lag = T, spatial.error = "none",
              effect = "individual",
              LeeYu = T, Hess = F)
summary(Lag_mod)
#
#
### Marginal effects - impacts
#
time <- length(unique(Pdata$time))
#
# ?impacts
set.seed(1128)
imp1 <- impacts(Lag_mod, listw = CE_data.listw, time = time, R = 1000)
imp2 <- summary(imp1, zstats = T, short = T)
imp2
# plot(impacts) can be used to assess the mcmc simulation used for inference
# plot(imp1$sres$direct[,1:3])
# plot(imp1$sres$direct[,4:6])
# plot(imp1$sres$indirect[,1:3])
# plot(imp1$sres$indirect[,4:6])
#
#
#
s2.df <- NULL
s2.df <- data.frame(max.dist=0, LL=0, Lambda=0, Lambda.SE=0,
                    GDP.DI=0, GDP.DI.SE = 0, 
                    GDP.IN=0, GDP.IN.SE = 0, 
                    HTC.DI=0, HTC.DI.SE = 0,
                    HTC.IN=0, HTC.IN.SE = 0,
                    Interact.DI=0, Interact.DI.SE = 0,
                    Interact.IN=0, Interact.IN.SE = 0)
set.seed(300)
for(j in 16:100) {
  nb <- dnearneigh(coords, d1=0, d2=j*10, longlat=T)
  CE.listw <- nb2listw(nb)
  #
  Lag_mod <- spml(formula = fm1, data = Pdata, index = c("NUTS_ID","time"),
                  listw = CE.listw, model = "random",
                  lag = T, spatial.error = "none",
                  effect = "individual",
                  LeeYu = T, Hess = F)
  sumLagmod <- summary(Lag_mod)
  #
  imp1 <- impacts(Lag_mod, listw = CE.listw, time = 6, R = 1000)
  imp2 <- summary(imp1, zstats = T, short = T)
  #
  s2.df <- rbind(s2.df, c(j*10, Lag_mod$logLik, sumLagmod$ARCoefTable[1,1], sumLagmod$ARCoefTable[1,2],
                          imp2$res$direct[1], imp2$res$direct[1]/imp2$zmat[1,1],
                          imp2$res$indirect[1], imp2$res$indirect[1]/imp2$zmat[1,2],
                          imp2$res$direct[2], imp2$res$direct[2]/imp2$zmat[2,1],
                          imp2$res$indirect[2], imp2$res$indirect[2]/imp2$zmat[2,2], 
                          imp2$res$direct[4], imp2$res$direct[4]/imp2$zmat[4,1],
                          imp2$res$indirect[4], imp2$res$indirect[4]/imp2$zmat[4,2]))
} 
s2.df <- s2.df[-1,]
#

par(mfrow=c(4,2))
#
plot(s2.df$LL~s2.df$max.dist, type="l", ylab="LogLik",xlab="Maximum neighbor distance (km)")
abline(v=220, lty=3)
#
plot(s2.df$Lambda~s2.df$max.dist, type="l", ylab="[Lambda]",xlab="Maximum neighbor distance (km)",
     ylim=c(0.5, 1))
lines((s2.df$Lambda+s2.df$Lambda.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$Lambda-s2.df$Lambda.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=1, lty=3, col="red")
#
#
plot(s2.df$GDP.DI~s2.df$max.dist, type="l", ylab="[GDP Direct impact]",xlab="Maximum neighbor distance (km)",
     ylim=c(-0.15,0.05))
lines((s2.df$GDP.DI-s2.df$GDP.DI.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$GDP.DI+s2.df$GDP.DI.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=0, lty=3, col="red")
#
plot(s2.df$GDP.IN~s2.df$max.dist, type="l", ylab="[GDP Indirect impact]",xlab="Maximum neighbor distance (km)",
     ylim=c(-0.6,0.1))
lines((s2.df$GDP.IN-s2.df$GDP.IN.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$GDP.IN+s2.df$GDP.IN.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=0, lty=3, col="red")
#
plot(s2.df$HTC.DI~s2.df$max.dist, type="l", ylab="[TechEmp Direct impact]",xlab="Maximum neighbor distance (km)",
     ylim=c(-0.1,0.7))
lines((s2.df$HTC.DI+s2.df$HTC.DI.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$HTC.DI-s2.df$HTC.DI.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=0, lty=3, col="red")
#
plot(s2.df$HTC.IN~s2.df$max.dist, type="l", ylab="[TechEmp Indirect impact]",xlab="Maximum neighbor distance (km)",
     ylim=c(-0.3, 4.5))
lines((s2.df$HTC.IN+s2.df$HTC.IN.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$HTC.IN-s2.df$HTC.IN.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=0, lty=3, col="red")
#
plot(s2.df$Interact.DI~s2.df$max.dist, type="l", ylab="[HTC:HUCL Direct impact]",xlab="Maximum neighbor distance (km)",
     ylim=c(-1, 0.3))
lines((s2.df$Interact.DI+s2.df$Interact.DI.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$Interact.DI-s2.df$Interact.DI.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=0, lty=3, col="red")
#
plot(s2.df$Interact.IN~s2.df$max.dist, type="l", ylab="[HTC:HUCL Indirect impact]",xlab="Maximum neighbor distance (km)",
     ylim=c(-4, 0.5))
lines((s2.df$Interact.IN+s2.df$Interact.IN.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$Interact.IN-s2.df$Interact.IN.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=220, lty=3)
abline(h=0, lty=3, col="red")
#
par(mfrow=c(1,1))
#