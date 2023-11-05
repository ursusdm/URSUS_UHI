

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
  PVRasterLayer <- ((NDVIrasterLayer - minNDVI)/(maxNDVI - minNDVI))^2
  return(PVRasterLayer)
}



EmissivityCalculation <- function(red, ndvi, Pv){

  #Pv calculation
  Pv <- ((ndvi - 0.2)/(0.5 - 0.2))^2
  
  E1_Sobrino <- 0.004*Pv + 0.986
  
  E_Sobrino <- ndvi
  
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
  
  # Calculate emissivity layer
  emmisivityLayer <- EmissivityCalculation(multibandLayer[[3]],ndviRaster,PVLayer)
  
  if (bandNumber==10)
    alpha_ <- 10.8
  else
    alpha_ <- 12
  
  p <- 14388

  lstRaster <- (BTLayer/ ( 1 +  ( (alpha_*BTLayer)/p)   * log (emmisivityLayer)     ) )

  #print ("lstRaster")
  #print (plot (lstRaster, title("lstRaster")))

  return (BTLayer)
  
}


plotLST <- function(lstRaster) {
  
  plot(lstRaster,col = rev(heat.colors(12)), legend.args =
         list(paste(text='LST','')),
       axes=FALSE, horizontal = TRUE, box = FALSE)

}






#Aux functions for DAI calculation

F <- function(x) {1 - tanh(x) / tanh(1)}

G <- function(x){ tanh(x)}

#Calculate DAI raster layer
calculateDAI <- function(ndviLayer,lstLayer) {
  
  ndviImg <- ndviLayer
  lstImg <- lstLayer
  
  lst_m <- mean(na.omit((lstLayer [ndviLayer>0])))
  lst_sd <- sd(na.omit((lstLayer [ndviLayer>0]))) 
  
  DAIImage <- F(ndviImg) * G ((lstImg-lst_m) / lst_sd)
  
  return (DAIImage)
  
}

#NormLIZE LST
normalizeLST <-  function(lstLayer) {
  
  lstImgMean <- mean (na.omit(values (lstLayer)))
  lstImgSD <- sd (na.omit(values (lstLayer)))
  lstI <- lstLayer
  lstTip <- (lstI-lstImgMean)/lstImgSD
  return (lstTip)
}

#NormLIZE NDVI
normalizeNDVI <-  function(ndviLayer) {
  
  ndviImgMean<- mean (na.omit(values (ndviLayer)))
  ndviImgtSD <- sd (na.omit(values (ndviLayer)))
  ndviI <- ndviLayer
  ndviTip <- (ndviI-ndviImgMean)/ndviImgtSD 
  return (ndviTip)
}

#create a normalized ndvi and lst for clustering
createNormalizedDatasetForClustering <- function(lstTip, ndviTip) {
  lstPixelDF <- as.data.frame(values(lstTip))
  ndviPixelDF <- as.data.frame(values(ndviTip))
  dfForPixelClustering  <- cbind (lstPixelDF,ndviPixelDF)
  names(dfForPixelClustering) <- c("lst","ndvi")
  return (dfForPixelClustering)
}


plot_DAI <- function(capa_a_pintar,name="DAI") {
  capa_pts <- rasterToPoints(capa_a_pintar, spatial = TRUE)
  capa_df <- data.frame(capa_pts)
  capa_df <- cbind(capa_df, alpha = 1)
  ggplot() +
    geom_raster(data = capa_df ,
                aes(x = x,
                    y = y,
                    fill = layer)) +
    guides(fill = guide_colorbar(title = name)) +
    scale_fill_gradientn(colours = wes_palette("Zissou1", 10, type = "continuous"))+
    theme_void()
}

# Induce kmeans model witn 3 cluster and pixels will be assigned to clusters
# Return a dataset with asigned cluster for each pixel of image

getClusters <- function(dfForPixelClustering) {
  
  kmncluster <- kmeans(na.omit(dfForPixelClustering),
                       centers = 3, iter.max =  1000, nstart =10, algorithm = "Lloyd")
  
  # Add asigned cluster for each pixel
  DFWithCluster <- cbind(na.omit(dfForPixelClustering),
                         as.data.frame(kmncluster$cluster))
  
  names(DFWithCluster)[3] <- "CLUSTER"
  
  return (DFWithCluster)
  
}

# Landsat image with cluster assigned
getClusteredImage <- function (DFWithCluster,NDVIRaster) {
  #Create raster images list with clusters assigned for image's pixels
  #get image
  imgClusteredPixels <- DFWithCluster
  
  imgRaster <- NDVIRaster
  imgRaster[!is.na(NDVIRaster)] <- imgClusteredPixels$CLUSTER
  #plot (imgRaster,col=heat.colors(3))
  return (imgRaster)
  
}



