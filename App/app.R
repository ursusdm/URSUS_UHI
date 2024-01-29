#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# installing required packages 
packages.required <- c("shiny",
                      "shinyFiles",
                      "stringr",
                      "raster",
                      "leaflet",
                      "sf",
                      "leaflet.extras",
                      "shinydashboard",
                      "reshape2",
                      "ggplot2",
                      "wesanderson",
                      "dplyr",
                      "sp")
packages.missed <- packages.required[!(packages.required %in% installed.packages()[,"Package"])]
if(length(packages.missed)) install.packages(packages.missed)


library(shiny)
library(shinyFiles)
library(stringr)
library(raster)
library(leaflet)
library(sf)
library(leaflet.extras)
library(shinydashboard)
library(reshape2)
library(ggplot2)
library(wesanderson)
library(dplyr)
library(sp)
source('aux.R')
source('UHI.R')



# Define UI for application 
ui <- dashboardPage(
  
    dashboardHeader(title = "URSUS_UHI"),
    
    dashboardSidebar(disable=TRUE),
    
    dashboardBody(
      
      sidebarLayout( 
      
        sidebarPanel ( width = 3, 
          
          verticalLayout( 
            
            box(
                shinyDirButton('folder', 'Folder selector', 'Please select a landsat image folder and push select button', FALSE),
                status = "primary",
                solidHeader = TRUE,
                title = "Select landsat-8 image",
                width = 100
            ),
          
           
            
          )
          
        ),
   
        mainPanel (   width = 9,
                      
            tabsetPanel(
            type = "tabs",
            
            tabPanel("Main", 
                     
                     verticalLayout( 
                       
                       box(
                         title = "Area selected to determine the most unfavorable zones due to the urban heat island (UHI) effect ",
                         status = "info",
                         solidHeader = TRUE,
                         leafletOutput("mymap"),
                         
                         p(),
                         actionButton("processUrbanArea", "Process urban area"),
                         width = 12
                         
                       ),
                       
                       
                       box(
                         title = "Disadvantaged Area Index (DAI) for the unfavourable area cluster",
                         status = "danger",
                         solidHeader = TRUE,
                         width = 12,
                         plotOutput("DAI")
                       )
                       
                     )
                     
            ),
            
            tabPanel("Additional information",
            
              verticalLayout( 
                
                # box(
                #   title = "Cropped Landsat Image",
                #   status = "danger",
                #   solidHeader = TRUE,
                #   plotOutput("CROPPED"),
                #   width = 200
                # ),
                
                
                box(
                  title = "LST",
                  status = "danger",
                  solidHeader = TRUE,
                  plotOutput("LST"),
                  width = 200
                  
                ),
                
                box(
                  title = "NDVI",
                  status = "success",
                  solidHeader = TRUE,
                  width = 200,
                  plotOutput("NDVI"),
                  
                ),
                
                
                
                box(
                  title = "Clusters",
                  status = "warning",
                  solidHeader = TRUE,
                  plotOutput("CLUSTERS"),
                  width = 200
                )
              
              )
  
            )
            
          ),
          
          
        ),
        
        
      ),
      
      
    )
    
)

# Define server logic 
server <- function(input, output, session) {
  
  # Select image folder logic
  
  shinyDirChoose(input, 'folder', roots=c(wd='./data'), filetypes=c())
  
  observe({  
    
    # If a landsat 8 folder is selected, a multiband layer from image is created
    if(!is.integer(input$folder)){
      
      shinyDirChoose(input, 'folder', roots=c(wd='./data'))
      dirinfo <- parseDirPath(roots=c(wd='./data'), input$folder)
      
      # Reag landsat 8 satellite multiband and metadata from landsat 8 image
      multibandLayer <<- readMultibandRasterLayer(dirinfo)
      
      #Read metadata file for LST calculation
      metad <<- readMetadata(dirinfo)
      
      extentCoordinatesLatLng <- utmToGPSExtent (multibandLayer[[1]])
      
      
      
      #Leflet map
      output$mymap <- renderLeaflet({
        
        leaflet() %>% 
          
          # center leaflet map on landsat image coordinates
          fitBounds(lng1 = extentCoordinatesLatLng[[1]][[1]] , lng2 = extentCoordinatesLatLng[[1]][[2]] ,
                  lat1 = extentCoordinatesLatLng[[2]][[1]], lat2 = extentCoordinatesLatLng[[2]][[2]]
                 ) %>%
          
          #plot rectangle with covered area over leaflet map
          addRectangles(
            lng1=extentCoordinatesLatLng[[1]][[1]], lat1=extentCoordinatesLatLng[[2]][[1]],
            lng2= extentCoordinatesLatLng[[1]][[2]], lat2=extentCoordinatesLatLng[[2]][[2]],
            color = "red",
            fillColor = "transparent"
          ) %>%
          
        
          addDrawToolbar(
            targetGroup='draw',
            polylineOptions = FALSE,
            polygonOptions = FALSE,
            circleOptions = FALSE,
            rectangleOptions = drawRectangleOptions(),
            markerOptions = FALSE,
            circleMarkerOptions = FALSE, 
            singleFeature = FALSE,
            editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
          ) %>%
          
          
          addProviderTiles('Esri.WorldImagery')
        
      })
      
    }
    
  })
  
  #Observer polygon crop area over map
  feature <- eventReactive( input$mymap_draw_new_feature, {
    input$mymap_draw_new_feature
  })
  
  #Observer polygon crop area over map
  observeEvent(input$processUrbanArea, {
    
    # read coords from polygon cropped area
    coords_ <- feature()$geometry$coordinates[[1]]
 
    croppedImage <- cropSelectedAreaFromLandsatImage (coords_,multibandLayer)
    
    NDVILayer <- calculateNDVI (croppedImage)
    
    rasterLST <- lstCalculation (croppedImage,NDVILayer,10) 
    
    rasterDAI <- calculateDAI(NDVILayer,rasterLST)
    
    normalizeLST <- normalizeLST(rasterLST)
    
    normalizeNDVI <- normalizeNDVI(NDVILayer)
    
    dfForPixelClustering <- createNormalizedDatasetForClustering (normalizeLST,normalizeNDVI)
    
    DFWithCluster <- getClusters (dfForPixelClustering)
    
    clusteringRaster <- getClusteredImage(DFWithCluster,NDVILayer)
    
    colorForClustering <- getClustersColors (rasterDAI, clusteringRaster)
    
    
    clusterMoreDisfavourable <- getClusterDisfavourable (rasterDAI, clusteringRaster)
    
    DAIForClusterDisfavourable <- removeFavourableAreasFromDAI (rasterDAI,clusterMoreDisfavourable,clusteringRaster)
    
    #disfAras <- getMoreDisfavourableAreas(rasterDAI, clusteringRaster)
    
    #Plot RDG image landsat8
    # output$CROPPED <- renderPlot ({
    #   plotRGBImage(croppedImage)
    # })
    
    
    #calculate NDVI
    output$NDVI <- renderPlot ( {
      
      plot(NDVILayer, axes=FALSE, box=FALSE, horizontal = TRUE,
           legend.args = list(text = 'NDVI'))
      
      
    } )
    

    
    #calculate LST

    output$LST <- renderPlot ( {
                                 
      plot(rasterLST, axes=FALSE, box=FALSE, col = rev(heat.colors(300)), horizontal = TRUE,
           legend.args = list(text = 'LST') )
                    
      
      
                   
    }, height = 'auto', width = 'auto')
    
    # DAI for unfavourable areas
    
    output$DAI <- renderPlot ({
      #plot_DAI(DAIForClusterDisfavourable)

      plot(DAIForClusterDisfavourable, axes=FALSE, box=FALSE, col =  wes_palette("Zissou1", 10, type = "continuous"), horizontal = TRUE,
           legend.args = list(text = 'DAI'))
      
      #legend("bottom", legend = labels, fill = colours)
      
    })
    
    #calculate cluster

    output$CLUSTERS <- renderPlot ({
      
      #plot_CLUSTERS_2 (clusteringRaster, clusterColor =  colorForClustering)
      labels = unlist(colorForClustering$label[[1]])
      colours = colorForClustering$color[[1]]
                      
      plot(clusteringRaster, axes=FALSE, box=FALSE, col = colours, legend = FALSE,  
           legend.args = list(text = 'CLUSTERS'))
      
      legend("bottom", legend = labels, fill = colours)
      
    },height = 'auto', width = 'auto')
    

    
  })
  
    
}

# Run the application 
shinyApp(ui = ui, server = server)
