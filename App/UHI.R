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