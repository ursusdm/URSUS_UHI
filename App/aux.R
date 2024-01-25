
# Return a multilayer raster layer band for landsat-8 image
readMultibandRasterLayer <- function (rasterImageFolder) {
  
  files <- list.files(path = rasterImageFolder, pattern = "*TIF", full.names = TRUE)
 
  for (f in files) {
    
    #If file is a band file, create corresponding band raster object

    ##B2, Blue.
    if (str_detect(f, "B2.TIF", negate = FALSE)) {
      b2 <- raster::raster(f)
    }
    
    #B3 Green
    else if (str_detect(f, "B3.TIF", negate = FALSE)){
      b3 <- raster(f)
    } 
    
    #B4 Red
    else if (str_detect(f, "B4.TIF", negate = FALSE)){
      b4 <- raster(f)
    } 
    
    #B5 NIR
    else if (str_detect(f, "B5.TIF", negate = FALSE)){
      b5 <- raster(f)
    } 
    
    #B10
    else if (str_detect(f, "B10.TIF", negate = FALSE)){
      b10 <- raster(f)
    }
    
    #B11
    else if (str_detect(f, "B11.TIF", negate = FALSE)){
      b11 <- raster(f)
    } 
    
  }
  
  multibandLayer <- stack(b2,b3,b4,b5,b10,b11)
  
  return  (multibandLayer)
  
}

# Return metadata for landsat-8 image
readMetadata <- function (rasterImageFolder) {

  files <- list.files(path = rasterImageFolder, pattern = "*MTL.txt", full.names = TRUE)
  
  for (f in files) {
    if (str_detect(f, "MTL.txt", negate = FALSE)){
      metad <- f
    } 
  }
  
  return (metad)
  
}


#Plot RGB image from multibandRasterLayer
plotRGBImage <- function (multibandRasterLayer) {
  
  plotRGB(multibandRasterLayer,3,2,1, stretch="lin", scale ="1200", colNA='white')
  
}

# convert landsat extents UTM to lat tng proyection system 
utmToGPSExtent <- function(im) {

    e <- extent (im)
    
    lng1 <- xmin (extent (e))
    lat1 <- ymin (extent (e))
    lng2 <- xmax (extent (e))
    lat2 <- ymax (extent (e))
    
    minDF <- cbind (lng1,lat1)
    maxDF <- cbind (lng2,lat2)
    
    fDF <- as.data.frame(rbind(minDF,maxDF))
    colnames (fDF) <- c("lng","lat")
    
    cord.UTM = SpatialPoints(cbind(fDF$lng, fDF$lat),
                             proj4string=crs(im))
    
    cord.DEC<- spTransform(cord.UTM, CRS("+proj=longlat"))
    
    lngMin <- xmin(extent(cord.DEC))
    latMin <- ymin(extent(cord.DEC))
    lngMax <- xmax(extent(cord.DEC))
    latMax <- ymax(extent(cord.DEC))
    
    lng <- list(lngMin,lngMax)
    lat <- list(latMin,latMax)
    
    return (list(lng,lat))
  
}


cropSelectedAreaFromLandsatImage <- function(coords_,multibandLayer) {
  
  #Create df with polygon coordw
  df <- data.frame(matrix(unlist(coords_), nrow=length(coords_), byrow=T))
  colnames(df) <- c("x_coord","y_coord")
  
  # Create  SpatialPoints object with lat,lng from polygin
  cord.dec = SpatialPoints(cbind(df$x_coord, df$y_coord), proj4string=CRS("+proj=longlat"))
  
  # Convert crop area from lat,lng to UTM 
  cord.UTM <- spTransform(cord.dec, crs(multibandLayer))
  
  # cropping over lidar image
  
  x_min <- xmin (extent (cord.UTM))
  x_max <- xmax (extent (cord.UTM))
  y_min <- ymin (extent (cord.UTM))
  y_max <- ymax (extent (cord.UTM))
  
  e <- as(extent(x_min, x_max, y_min, y_max), 'SpatialPolygons')

  r <- crop(multibandLayer, e)
  
  return (r)
  
}




