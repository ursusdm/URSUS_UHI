

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




#Temperature of atmosphere calculation
#!imp (bandNumber=10|bandNumber=11)

calculateTOA <- function(r,multibandLayer,bandNumber) {
  
  metaData <- readMeta(r)
  
  RADIANCE_MULT_BAND <- metaData$CALRAD$gain[bandNumber] 
  
  RADIANCE_ADD_BAND <- metaData$CALRAD$offset[bandNumber]

  if (bandNumber==10)
    bandLayer <- multibandLayer[[5]]
  else
    bandLayer <- multibandLayer[[6]]
  
  toaLayer <- calc(bandLayer, fun=function(x){RADIANCE_MULT_BAND * x + RADIANCE_ADD_BAND})
  
  return (toaLayer)
  
}

# Calculatio of bright temperature
calculateBT <- function(r,toaLayer,bandNumber) {
  
  metaData <- readMeta(r)
  
  if (bandNumber==10) {
    K1_CONSTANT_BAND <- metaData$CALBT$K1[1]
    K2_CONSTANT_BAND <- metaData$CALBT$K2[1]
  }
  else{
    K1_CONSTANT_BAND <- metaData$CALBT$K1[2] 
    K2_CONSTANT_BAND <- metaData$CALBT$K2[2]
  } 
      
  toaLayerKelvin <- calc(toaLayer, fun=function(x){
    (K2_CONSTANT_BAND/log( (K1_CONSTANT_BAND/x) + 1))
  })
    
  toaLayerCelsius <- calc(toaLayerKelvin, fun=function(x){x - 273.15})
  
  return (toaLayerCelsius)
    
}


#LST calculation

lstCalculation = function (multibandLayer,ndviRaster,r,bandNumber) {
  
  toaLayer <- calculateTOA(r,multibandLayer,bandNumber)
  
  BTLayer <- calculateBT(r,toaLayer,bandNumber)
  
  PVLayer <- PVCalculation (ndviRaster)
  
  # Calculate emissivity layer using Sobrino
  emmisivityLayer <- EmissivityCalculation(multibandLayer[[3]],ndviRaster)
  
  if (bandNumber==10)
    alpha_ <- 10.8
  else
    alpha <- 12
  
  p <- 14388

  lstRaster <- (BTLayer/ ( 1 +  ( (alpha_*BTLayer)/p)   * log (emmisivityLayer)     ) )

  return (lstRaster)
  
}


plotLST <- function(lstRaster) {
  
  plot(lstRaster,col = rev(heat.colors(12)), legend.args =
         list(paste(text='LST','')),
       axes=FALSE, horizontal = TRUE, box = FALSE)

}


