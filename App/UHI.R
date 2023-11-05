

#CONSTANT

NDVI_V <- 0.5 #NDVI vegetation proportion
NDVI_F <- 0.2 #NDVI floor proportion

#NDVI calculation function (@param: bk:capa raster con la band 5,bi:band 4)
vi <- function(bk, bi) {
  vi <- (bk - bi) / (bk + bi)
  return(vi)
}

calculateNDVI <- function(landsatCroppedImage){
  
  band_5 <- landsatCroppedImage[[4]]
  band4 <- landsatCroppedImage[[3]]
  
  # For Landsat NIR = 5, red = 4.
  ndvi <- vi(band_5, band4)
  
  ## Remove outliers values (< -1 and > -1)
  ndvi[ndvi>1] <- 1
  ndvi[ndvi< -1] <- -1
  
  return (ndvi)
  
}

##################### Functions for Land Surface Temperature ##########
#####################                                        ##########
#######################################################################

PVCalculation <- function(NDVIrasterLayer){
  
  minNDVI <- min (na.omit(values(NDVIrasterLayer)))
  maxNDVI <- max (na.omit(values(NDVIrasterLayer)))
  
  #Pv calculation
  PVRasterLayer <- ((NDVIrasterLayer - minNDVI)/(maxNDVI - minNDVI))^2
  return(PVRasterLayer)
}



EmissivityCalculation <- function(red = red, NDVI = NDVI){
  #Read the NDVI band
  ndvi <- NDVI
  
  #Pv calculation
  Pv <- ((ndvi - 0.2)/(0.5 - 0.2))^2
  E1_Sobrino <- 0.004*Pv + 0.986
  E_Sobrino <- raster::raster(ndvi)
  red <- (0.979 - 0.035*red)
  #where NDVI < 0.2, take the value from red band otherwise use NA:
  E_Sobrino[] = ifelse(ndvi[]<0.2, red[], NA)
  
  #where NDVI is over 0.5 set E to 0.99, otherwise use whatever was in E:
  E_Sobrino[] = ifelse(ndvi[]>0.5, 0.99, E_Sobrino[])
  
  #if NDVI is between 0.2 and 0.5 take the value from b otherwise use whatever was in E:
  E_Sobrino[] = ifelse(ndvi[]>=0.2 & ndvi[]<=0.5, E1_Sobrino[], E_Sobrino[])
  
  return(E_Sobrino)
}


BT <- function(MultilayerBand, bandNumber){
  
  K1_CONSTANT_BAND_10 = 774.8853
  K2_CONSTANT_BAND_10 = 1321.0789


  K1_CONSTANT_BAND_11 <- 480.8883
  K2_CONSTANT_BAND_11 <- 1201.1442
  
  
  if (bandNumber==10) {
    LandsatLAyer <- MultilayerBand[[5]]
  }
  else
    LandsatLAyer <- MultilayerBand[[6]]

  l_lambda <- 3.3420*10^-4*LandsatLAyer + 0.1
    
  if (bandNumber==10)
    BT <- (K2_CONSTANT_BAND_10/(log(K1_CONSTANT_BAND_10/l_lambda + 1)))
  else
    BT<- (K2_CONSTANT_BAND_11/(log(K1_CONSTANT_BAND_11/l_lambda + 1)))
  
  temp_celsius <- calc(BT, fun=function(x){x - 273.15})
  
  return(temp_celsius)
  
}



#LST calculation

lstCalculation = function (multibandLayer,ndviRaster,bandNumber) {
  
  BTLayer <- BT(multibandLayer,bandNumber)
  
  PVLayer <- PVCalculation (ndviRaster)
  
  # Calculate emissivity layer using Sobrino
  emmisivityLayer <- EmissivityCalculation(multibandLayer[[3]],ndviRaster)
  
  if (bandNumber==10)
    alpha_ <- 10.8
  else
    alpha_ <- 12
  
  p <- 14388

  lstRaster <- (BTLayer/ ( 1 +  ( (alpha_*BTLayer)/p)   * log (emmisivityLayer)     ) )

  print ("lstRaster")
  print (lstRaster)
  
  return (lstRaster)
  
}


plotLST <- function(lstRaster) {
  
  plot(lstRaster,col = rev(heat.colors(12)), legend.args =
         list(paste(text='LST','')),
       axes=FALSE, horizontal = TRUE, box = FALSE)

}


