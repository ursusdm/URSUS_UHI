

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


E_Valor <- function(NDVI){
  #Read the NDVI band
  ndvi <- NDVI
  
  #Pv calculation
  Pv <- ((ndvi - 0.2)/(0.5 - 0.2))^2
  Pv_df <- raster::as.data.frame(Pv, xy = T)
  #Emissivity calculation
  E_Valor <- 0.985*Pv_df[3] + 0.960*(1 - Pv_df[3]) + 0.06*Pv_df[3]*(1 - Pv_df[3])
  #E_Valor[E_Valor>1] <- 1
  E_Valor_xyz <- cbind.data.frame(Pv_df[1:2], E_Valor)
  E_Valor_raster <- raster::rasterFromXYZ(E_Valor_xyz)
  return(E_Valor_raster)
}


BT <- function(MultilayerBand, bandNumber){
  
  K1_CONSTANT_BAND_10 = 774.8853
  K2_CONSTANT_BAND_10 = 1321.0789


  K1_CONSTANT_BAND_11 <- 480.8883
  K2_CONSTANT_BAND_11 <- 1201.1442
  
  RAD_MUL_BAND <- 3.3420*10^-4
  RADIANCE_ADD_BAND <- 0.1
  
  
  if (bandNumber==10) {
    Q_CAL <- MultilayerBand[[5]]
  }
  else
    Q_CAL <- MultilayerBand[[6]]

  l_lambda <- RAD_MUL_BAND *Q_CAL + RADIANCE_ADD_BAND
  
    
  if (bandNumber==10)
    BT <- ( K2_CONSTANT_BAND_10 / (log(K1_CONSTANT_BAND_10/l_lambda + 1) ) )
  else
    BT<- ( K2_CONSTANT_BAND_11 / (log(K1_CONSTANT_BAND_11/l_lambda + 1) ) )
  
  temp_celsius <- calc(BT, fun=function(x){x - 273.15})
  
  return(temp_celsius)
  
}


#LST calculation

lstCalculation = function (multibandLayer,ndviRaster,bandNumber) {
  
  BTLayer <- BT(multibandLayer,bandNumber)
  
  emmisivityLayer <- 1.094 + 0.047*log(ndviRaster)
  
  if (bandNumber==10)
    alpha_ <- 10.8
  else
    alpha_ <- 12
  
  p <- 14388
  
  lstRaster <- ( BTLayer/ ( 1 +  ( (alpha_*BTLayer)/p)   * log (E_Valor(ndviRaster))     )  )

  ########## Cambiar por lstRaster ################
  return (lstRaster)
  
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


plot_DAI <- function(layerToPaint,name="DAI") {
  
  layerPoints <- rasterToPoints(layerToPaint, spatial = TRUE)
  layerDF <- data.frame(layerPoints)
  layerDF <- cbind(layerDF, alpha = 1)

  ggplot() +
    geom_raster(data = layerDF ,
                aes(x = x,
                    y = y,
                    fill = layer)) +
    guides(fill = guide_colorbar(title = name)) +
    scale_fill_gradientn(colours = wes_palette("Zissou1", 10, type = "continuous"))+
    theme_void()
}

plot_CLUSTERS_2 <- function(layerToPaint,name="CLUSTERS",clusterColor) {
  
  layerPoints <- rasterToPoints(layerToPaint, spatial = TRUE)
  layerDF <- data.frame(layerPoints)
  layerDF <- cbind(layerDF, alpha = 1)
  
  
    ggplot(data = layerDF) +
      geom_raster(aes(x = x, y = y, fill = layer)) + 
      guides(fill = guide_colorbar(title = name)) +

      scale_fill_gradientn(name = "", 
                            limits= c (1,3),
                            breaks = c(1:3),
                            colours = clusterColor$color[[1]],
                            labels = unlist(clusterColor$label[[1]])) +
      theme_void() +

      theme(
        legend.position = "right",
        legend.text=element_text(size=10)

      )

}


plot_NDVI<- function(layerToPaint,name="NDVI") {
  
  layerPoints <- rasterToPoints(layerToPaint, spatial = TRUE)
  layerDF <- data.frame(layerPoints)
  layerDF <- cbind(layerDF, alpha = 1)
  
  ggplot() +
    geom_raster(data = layerDF ,
                aes(x = x,
                    y = y,
                    fill = layer)) +
    guides(fill = guide_colorbar(title = name)) +
    scale_fill_gradientn(colours = rev(terrain.colors(10)))+
    theme_void()
  
}

plot_LST<- function(layerToPaint,name="LST") {
  
  layerPoints <- rasterToPoints(layerToPaint, spatial = TRUE)
  layerDF <- data.frame(layerPoints)
  layerDF <- cbind(layerDF, alpha = 1)
  
  ggplot() +
    geom_raster(data = layerDF ,
                aes(x = x,
                    y = y,
                    fill = layer)) +
    guides(fill = guide_colorbar(title = name)) +
    scale_fill_gradientn(colours = rev(heat.colors(10)))+
    theme_void()
  
}


# calculation of a raster with DAI pixels values for the cluster with the more disfavourable areas
removeFavourableAreasFromDAI <- function(DAI, disvavourableCluster, clusterRaster) {
  DAIMoreDisfavourableAreas <- DAI

  DAIMoreDisfavourableAreas [clusterRaster!=disvavourableCluster] <- NA

  return (DAIMoreDisfavourableAreas)
  
  
  
  
}


plot_disfavourableAreas <- function(layerToPaint,name="DISFAVOURABLE AREAS",clusterColor, DAI) {
  
  layerPoints <- rasterToPoints(layerToPaint, spatial = TRUE)
  layerDF <- data.frame(layerPoints)
  layerDF <- cbind(layerDF, alpha = 1)
  
  
  ggplot(data = layerDF) +
    geom_raster(aes(x = x, y = y, fill = layer)) + 
    guides(fill = guide_colorbar(title = name)) +
    
    scale_fill_gradientn(name = "", 
                         limits= c (1,3),
                         breaks = c(1:3),
                         colours = clusterColor$color[[1]],
                         labels = unlist(clusterColor$label[[1]])) +
    theme_void() +
    
    theme(
      legend.position = "right",
      legend.text=element_text(size=10)
      
    )
  
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

# return Landsat image with cluster assigned
getClusteredImage <- function (DFWithCluster,NDVIRaster) {
  imgClusteredPixels <- DFWithCluster
  imgRaster <- NDVIRaster
  imgRaster[!is.na(NDVIRaster)] <- imgClusteredPixels$CLUSTER
  return (imgRaster)
}

# not in
'%!in%' <- function(x,y)!('%in%'(x,y))



getClusterDisfavourable <- function (DAIPixels, clusteredPixels) {
  
  dfIMG <- data.frame (DAI=as.vector(DAIPixels),CLUSTER=as.vector(clusteredPixels))
  
  summaryForColor <- dfIMG %>% group_by(CLUSTER) %>% summarise(MEDIANA=median(DAI,na.rm=TRUE))
  
  maximo <- max (na.omit(summaryForColor$MEDIANA)) 
  
  maxPosition <- which(na.omit(summaryForColor$MEDIANA) %in% c(maximo))
  
  return (maxPosition)
  
}


# get color and leyend for clusters 

getClustersColors <- function(DAIPixels, clusteredPixels) {
  
  dfIMG <- data.frame (DAI=as.vector(DAIPixels),CLUSTER=as.vector(clusteredPixels))
  
  summaryForColor <- dfIMG %>% group_by(CLUSTER) %>% summarise(MEDIANA=median(DAI,na.rm=TRUE))
  
  maximo <- max (na.omit(summaryForColor$MEDIANA)) 
  
  minimo <- min (na.omit(summaryForColor$MEDIANA)) 
  
  maxPosition <- which(na.omit(summaryForColor$MEDIANA) %in% c(maximo))
  
  minPosition <- which(na.omit(summaryForColor$MEDIANA) %in% c(minimo))
  
  paletteCommon <- wes_palette("Zissou1", 10, type = "continuous")
  
  myColor <- c(1:3)
  myClusterLabel <- c(1:3)
  cluster <- c(1:3)
 
  for (colorIndex in 1:length(myColor)) {
    myColor[colorIndex] <- paletteCommon[6]
    myClusterLabel[colorIndex]  <- "Favourable"
    cluster[colorIndex]  <- 4
  }
  
  myColor [[maxPosition]] <- paletteCommon[10] #red for cluster disfavourable
  myClusterLabel [[maxPosition]] <- "More disfavourable" 
  
  myColor [[minPosition]] <- paletteCommon[1] #blue for water cluster
  myClusterLabel [[minPosition]] <- "More favourable" 
  
  
  cluster [[maxPosition]] <- maxPosition
  cluster [[minPosition]] <- minPosition
  pos <- which (myClusterLabel %!in% c("More disfavourable","More favourable" ) )
  cluster [which(cluster %in% 4)] <- pos

  colors_frame <- tribble(
    ~cluster, ~color, ~label,
    cluster, myColor, myClusterLabel
  )
  
  return (colors_frame)

}



getMoreDisfavourableAreas <- function (DAIPixels, clusteredPixels) {
  
  myColor <- getClustersColors (DAIPixels, clusteredPixels)
  
  dfFull<- data.frame(DAI=as.vector(DAIPixels),CLUSTER=as.vector(clusteredPixels))
  
  #umNumberOfPixelOfClusDisfForImg <- dfFull %>% filter (CLUSTER==2) %>% group_by(IM_ID) %>% summarise(n = n())
  
  
  
}



